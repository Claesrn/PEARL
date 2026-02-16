-- (Commented out for now)
-- module Normalize (normalizeProgram) where

import RL.AST
import RL.Program

import Data.List (sort, union, elemIndex)
import Data.Map.Strict (Map)
import qualified Data.Map.Strict as Map
import Data.Maybe (fromMaybe)

normalizeProgram :: Eq a => Program a () -> Program String ()
normalizeProgram (decl, prog) = (normDecl decl, normBlocks prog)

-- Sort the variables because why not, it should not matter
normDecl :: VariableDecl -> VariableDecl
normDecl VariableDecl{input = inp, output = out, temp = tmp} =
  VariableDecl (sort inp) (sort out) (sort tmp)

-- Make the label order and names uniform
normBlocks :: Eq a => [Block a ()] -> [Block String ()]
normBlocks bs =
  let sorted = topologicalSort bs
      order = map label sorted
      anonymized = mapLabel (anonymizeLabel order) sorted
      canonical = canonicalizeFiAsserts anonymized
  in canonical

-- Canonicalize fi conditions and their associated asserts so that
-- semantically equivalent programs produce identical normalized output.
--
-- 1. Ensure the fi "from" label is numerically <= the "else" label
--    (swapping branches and negating the condition if needed).
-- 2. If the "from" predecessor block ends with a trailing assert
--    before its goto, use that assert expression as the fi condition
--    (it is the exact condition that holds when arriving via that path).
-- 3. Remove trailing asserts from all blocks that goto a fi-block,
--    since these are redundant with the fi condition check.
canonicalizeFiAsserts :: [Block String ()] -> [Block String ()]
canonicalizeFiAsserts prog = map cleanAssert updated
  where
    -- Build a map from block label to block for quick lookup
    blockMap :: Map String (Block String ())
    blockMap = Map.fromList [(fst (name b), b) | b <- prog]

    -- Set of labels whose blocks have a fi
    fiLabels :: Map String (Block String ())
    fiLabels = Map.filter (isFi . from) blockMap

    isFi (Fi _ _ _) = True
    isFi _          = False

    -- Extract the numeric index from "Block_N"
    blockIndex :: String -> Int
    blockIndex s = read (drop 6 s)  -- drop "Block_"

    -- Get the trailing assert expression from a block, if it has one
    trailingAssert :: Block String () -> Maybe Expr
    trailingAssert b = case body b of
      [] -> Nothing
      steps -> case last steps of
        Assert e -> Just e
        _        -> Nothing

    -- Step 1 & 2: Canonicalize each fi-block's condition
    updated :: [Block String ()]
    updated = map updateBlock prog

    updateBlock b = case from b of
      Fi e l1@(l1name, _) l2@(l2name, _) ->
        let -- Step 1: ensure from label index <= else label index
            (e', from_l, else_l) =
              if blockIndex l1name > blockIndex l2name
              then (UOp Not e, l2, l1)
              else (e, l1, l2)
            -- Step 2: if from-predecessor has trailing assert, use it
            fromBlock = Map.lookup (fst from_l) blockMap
            e'' = case fromBlock of
              Just fb -> fromMaybe e' (trailingAssert fb)
              Nothing -> e'
        in b { from = Fi e'' from_l else_l }
      _ -> b

    -- Step 3: remove trailing asserts from blocks that goto fi-blocks
    cleanAssert b = case jump b of
      Goto (l, _) | l `Map.member` fiLabels ->
        b { body = dropTrailingAssert (body b) }
      _ -> b

    dropTrailingAssert [] = []
    dropTrailingAssert steps = case last steps of
      Assert _ -> init steps
      _        -> steps

-- Convert label to string using index in list
anonymizeLabel :: Eq a => [a] -> a -> String
anonymizeLabel labels l =
  case elemIndex l labels of
    Nothing -> error "Label not found in given order"
    Just i -> "Block_" ++ show i

-- Sort the blocks using control flow (entry block is first, etc.)
topologicalSort :: Eq a => [Block a ()] -> [Block a ()]
topologicalSort bs =
  let entry = getEntryLabel bs
  in topSortAcc [(entry, ())] []
  where
    topSortAcc [] acc = map (getBlockUnsafe bs) acc
    topSortAcc (l:pending) acc =
      let newLs = jumpLabels . jump $ getBlockUnsafe bs l
          (pending', acc') = if l `elem` acc then (pending, acc)
                             else (pending `union` newLs, acc ++ [l])
      in topSortAcc pending' acc'
