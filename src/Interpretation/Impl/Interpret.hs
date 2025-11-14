{-# LANGUAGE BangPatterns #-}
module Interpretation.Impl.Interpret where


import Utils.Error
import Utils.Maps

import RL.AST
import RL.Operators
import RL.Values
import RL.Variables
import RL.Program

import qualified Control.Monad.State as S

type SLEM = S.StateT Stats LEM

-- Monad utility function
lift' :: EM a -> SLEM a
lift' = S.lift . raise

data Stats = Stats
  { steps :: !Int
  , jumps :: !Int
  , assertions :: !Int
  } deriving Show

prettyStats :: Stats -> String
prettyStats stats@Stats{steps = s, jumps = j} =
  "Total Steps: " ++ show s
  ++ ", Total Jumps: " ++ show j
  ++ ", Combined Total: " ++ show (totalSteps stats)

prettyStats2 :: Stats -> Stats -> String
prettyStats2 stats1@Stats{steps = s1, jumps = j1} stats2@Stats{steps = s2, jumps = j2} =
  "Total Steps: " ++ show s1 ++ brace (show s2)
      ++ ", Total Jumps: " ++ show j1 ++ brace (show j2)
      ++ ", Combined Total: " ++ show (totalSteps stats1) ++ brace (show $ totalSteps stats2)
  where brace s = " (" ++ s ++ ")"

totalSteps :: Stats -> Int
totalSteps Stats{steps = s, jumps = j} = s + j * 2

-- Base stats for collection
initStats :: Stats
initStats = Stats 0 0 0

-- Interpret a program with a given (verifiable wellformed) input
-- output: program output and statistics
runProgram :: (Eq a, Show a) => Program a () -> Store -> LEM (Store, Stats)
runProgram (decl, prog) inpstore =
  do  entry <- raise $ getEntry prog
      store <- raise $ createStore decl inpstore
      evalBlocks prog (output decl) store entry Nothing initStats

-- Interpret a program with a (possibly mallformed) input
-- Non-input values in a store are ignored
-- output: program output and statistics
runProgram' :: Program a () -> Store -> LEM (Store, Stats)
runProgram' (_, _) _ = undefined

-- Create a proper store given an input store
-- verifies that input store is wellformed
createStore :: VariableDecl -> Store -> EM Store
createStore decl store =
  let anyTemp = any (\n -> n `elem` temp decl) (keys store)
      anyOut = any (\n -> n `elem` output decl
                       && n `notElem` output decl) (keys store)
      allPresent = all (`elem` keys store) (input decl)
  in if anyTemp || anyOut || not allPresent
  then Left "Invalid input store"
  else
    let nilStore = fromList . map (\n -> (n, Nil)) $ nonInput decl
    in return $ combine store nilStore

-- interpret program till exit
-- output: the output store
evalBlocks :: (Eq a, Show a) =>
  [Block a ()] -> [Name] -> Store -> (a, ()) -> Maybe (a, ()) -> Stats -> LEM (Store, Stats)
evalBlocks prog outputs store l origin stats =
  do block <- raise $ getBlockErr prog l
     (label', store', stats') <- evalBlock store block origin stats
     case label' of
       Nothing -> return $ (store' `onlyIn` outputs, stats')
       Just l'  -> evalBlocks prog outputs store' (l', ()) (Just l) stats'
 

-- interpret a given block
evalBlock :: Eq a => Store -> Block a () -> Maybe (a, ()) -> Stats -> LEM (Maybe a, Store, Stats)
evalBlock s b l stats =
  do evalFrom s (from b) l
     (s', stats') <- evalSteps s (body b) stats
     (l', stats'') <- evalJump s' (jump b) stats'
     return (l', s', stats'')

-- interpret a come-from statement
-- error if control-flow violates backwards determinism
evalFrom :: Eq a => Store -> ComeFrom a () -> Maybe (a, ()) -> LEM ()
evalFrom _ (From (l, ())) (Just (l', ())) =
  if l == l' then return ()
  else raise $ Left "Unconditional from failed"
evalFrom s (Fi e (l1, ()) (l2, ())) (Just (l', ())) =
  do v <- raise $ evalExpr s e
     let l = if truthy v then l1 else l2
     if l == l' then return ()
     else raise $ Left ("Assertion failed in Fi " ++ show e) -- added for error searching
evalFrom _ (Entry ()) Nothing = return ()
evalFrom _ _ _ = raise $ Left "Unexpected jump to entry, or wrong start"

-- interpret a jump statement
-- outputs label of next block
evalJump :: Store -> Jump a () -> Stats -> LEM (Maybe a, Stats)
evalJump _ (Goto (l, ())) stats = return (Just l, incJump stats)
evalJump s (If e (l1, ()) (l2, ())) stats =
  do v <- raise $ evalExpr s e
     return (Just (if truthy v then l1 else l2), incJump stats)
evalJump _ (Exit ()) stats = return (Nothing, stats)

-- interpret multiple steps
evalSteps :: Store -> [Step] -> Stats -> LEM (Store, Stats)
evalSteps !s [] stats = return (s, stats)
evalSteps !s (step:stepss) stats =
  do (!s', !stats') <- evalStep s step stats
     evalSteps s' stepss stats'

-- interpret a given step
evalStep :: Store -> Step -> Stats -> LEM (Store, Stats)
evalStep !s Skip stats = return (s, stats)
evalStep !s (Assert e) stats =
  do v <- raise $ evalExpr s e
     if truthy v then return (s, stats)
     else raise $ Left ("failed assertion: " ++ show e)
evalStep !s (Replacement q1 q2) stats =
  do (!s1, !v) <- raise $ construct s q2
     let !s2 = deconstruct s1 v q1
     return (s2, stats)
evalStep !s (Update n op e) stats =
  do v1 <- raise $ find n s
     v2 <- raise $ evalExpr (s `without` n) e
     v3 <- raise $ calcR op v1 v2
     return (set n v3 s, stats)

-- construct an intermediate value and store for a replacement
construct :: Store -> Pattern -> EM (Store, Value)
construct !store (QConst v) = return (store,v)
construct !store (QVar n) =
  do !v <- find n store
     let !store' = set n Nil store
     return (store', v)
construct !store (QPair q1' q2') =
  do (!store', !v)   <- construct store q1'
     (!store'', !v') <- construct store' q2'
     return (store'', Pair v v')

-- deconstruct intermediate value into new store
-- errors if cannot match
deconstruct :: Store -> Value -> Pattern -> Store
deconstruct !store !v (QConst v') = store
deconstruct !store !v (QVar n) = set n v store
deconstruct !store (Pair v1 v2) (QPair q1' q2') =
  let !store' = deconstruct store v1 q1'
  in deconstruct store' v2 q2'
deconstruct !store _ _ = store

-- evaluate an expression
evalExpr :: Store -> Expr -> EM Value
evalExpr _ (Const v) = return v
evalExpr s (Var n) = find n s
evalExpr s (Op op e1 e2) =
  do v1 <- evalExpr s e1
     v2 <- evalExpr s e2
     calc op v1 v2
evalExpr s (UOp op e) =
  do v <- evalExpr s e
     calcU op v

find :: Name -> Store -> EM Value
find n s =
  case lookupM n s of
    Just v -> return v
    _ -> Left $ "Variable \"" ++ n ++ "\" not found during lookup"

-- helper functions for statistics
incAssert :: Stats -> Stats
incAssert stats = stats{assertions = assertions stats + 1}

incJump :: Stats -> Stats
incJump stats = stats{jumps = jumps stats + 1}

incStep :: Stats -> Stats
incStep stats = stats{steps = steps stats + 1}
