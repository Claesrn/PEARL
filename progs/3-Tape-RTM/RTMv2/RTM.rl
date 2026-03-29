(Start End Rules S_right_t1 S_right_t2 S_right_t3)
    -> (Start End Rules S_right_t1 S_right_t2 S_right_t3)
    with (Q Q1 Q2 S1_t1 S2_t1 S1_t2 S2_t2 S1_t3 S2_t3
          S_t1 S_t2 S_t3 S_left_t1 S_left_t2 S_left_t3
          RulesRev Rule)

init: entry
      S_t1 ^= 'BLANK
      S_t2 ^= 'BLANK
      S_t3 ^= 'BLANK
      Q ^= Start
      goto act1

act1: fi !RulesRev && Q = Start
         from init else act3
      (Rule . Rules) <- Rules
      (Q1 . (S1_t1 . (S2_t1 . (S1_t2 . (S2_t2 . (S1_t3 . (S2_t3 . Q2))))))) <- Rule
      if S1_t1 = 'SLASH && S1_t2 = 'SLASH && S1_t3 = 'SLASH
         goto shft else symbol

symbol: from act1
        if Q = Q1 && S_t1 = S1_t1 && S_t2 = S1_t2 && S_t3 = S1_t3
           goto symbol1 else symbol2

symbol1: from symbol
         Q ^= Q1
         Q ^= Q2
         S_t3 ^= S1_t3
         S_t2 ^= S1_t2
         S_t1 ^= S1_t1
         S_t1 ^= S2_t1
         S_t2 ^= S2_t2
         S_t3 ^= S2_t3
         goto symbol2

symbol2: fi Q = Q2 && S_t1 = S2_t1 && S_t2 = S2_t2 && S_t3 = S2_t3
            from symbol1 else symbol
         goto act2

shft: from act1
      if Q = Q1 goto shft1 else shft3

shft1: from shft
       Q ^= Q1
       Q ^= Q2
       goto save_t1

// --- Save Tape 1 ---
save_t1: from shft1
         if S2_t1 = 'LEFT goto save_left_t1 else save_right_or_stay_t1

save_right_or_stay_t1: from save_t1
                       if S2_t1 = 'RIGHT goto save_right_t1 else save_stay_t1

save_stay_t1: from save_right_or_stay_t1
              goto save_t1_done

// LEFT save t1: push S_t1 onto S_right_t1
save_left_t1: from save_t1
              if S_right_t1 = 'nil && S_t1 = 'BLANK
                 goto save_left_1b_t1 else save_left_1p_t1

save_left_1b_t1: from save_left_t1
                 S_t1 ^= 'BLANK
                 goto save_left_d_t1

save_left_1p_t1: from save_left_t1
                 S_right_t1 <- (S_t1 . S_right_t1)
                 goto save_left_d_t1

save_left_d_t1: fi S_right_t1 = 'nil
                   from save_left_1b_t1 else save_left_1p_t1
                goto save_t1_left_done

save_t1_left_done: from save_left_d_t1
                   goto save_t2

// RIGHT save t1: push S_t1 onto S_left_t1
save_right_t1: from save_right_or_stay_t1
               if S_left_t1 = 'nil && S_t1 = 'BLANK
                  goto save_right_1b_t1 else save_right_1p_t1

save_right_1b_t1: from save_right_t1
                  S_t1 ^= 'BLANK
                  goto save_right_d_t1

save_right_1p_t1: from save_right_t1
                  S_left_t1 <- (S_t1 . S_left_t1)
                  goto save_right_d_t1

save_right_d_t1: fi S_left_t1 = 'nil
                    from save_right_1b_t1 else save_right_1p_t1
                 goto save_t1_right_done

save_t1_right_done: from save_right_d_t1
                    goto save_t1_done

save_t1_done: fi S2_t1 = 'RIGHT
                 from save_t1_right_done else save_stay_t1
              goto save_t2

// --- Save Tape 2 ---
save_t2: fi S2_t1 = 'LEFT
            from save_t1_left_done else save_t1_done
         if S2_t2 = 'LEFT goto save_left_t2 else save_right_or_stay_t2

save_right_or_stay_t2: from save_t2
                       if S2_t2 = 'RIGHT goto save_right_t2 else save_stay_t2

save_stay_t2: from save_right_or_stay_t2
              goto save_t2_done

// LEFT save t2: push S_t2 onto S_right_t2
save_left_t2: from save_t2
              if S_right_t2 = 'nil && S_t2 = 'BLANK
                 goto save_left_1b_t2 else save_left_1p_t2

save_left_1b_t2: from save_left_t2
                 S_t2 ^= 'BLANK
                 goto save_left_d_t2

save_left_1p_t2: from save_left_t2
                 S_right_t2 <- (S_t2 . S_right_t2)
                 goto save_left_d_t2

save_left_d_t2: fi S_right_t2 = 'nil
                   from save_left_1b_t2 else save_left_1p_t2
                goto save_t2_left_done

save_t2_left_done: from save_left_d_t2
                   goto save_t3

// RIGHT save t2: push S_t2 onto S_left_t2
save_right_t2: from save_right_or_stay_t2
               if S_left_t2 = 'nil && S_t2 = 'BLANK
                  goto save_right_1b_t2 else save_right_1p_t2

save_right_1b_t2: from save_right_t2
                  S_t2 ^= 'BLANK
                  goto save_right_d_t2

save_right_1p_t2: from save_right_t2
                  S_left_t2 <- (S_t2 . S_left_t2)
                  goto save_right_d_t2

save_right_d_t2: fi S_left_t2 = 'nil
                    from save_right_1b_t2 else save_right_1p_t2
                 goto save_t2_right_done

save_t2_right_done: from save_right_d_t2
                    goto save_t2_done

save_t2_done: fi S2_t2 = 'RIGHT
                 from save_t2_right_done else save_stay_t2
              goto save_t3

// --- Save Tape 3 ---
save_t3: fi S2_t2 = 'LEFT
            from save_t2_left_done else save_t2_done
         if S2_t3 = 'LEFT goto save_left_t3 else save_right_or_stay_t3

save_right_or_stay_t3: from save_t3
                       if S2_t3 = 'RIGHT goto save_right_t3 else save_stay_t3

save_stay_t3: from save_right_or_stay_t3
              goto save_t3_done

// LEFT save t3: push S_t3 onto S_right_t3
save_left_t3: from save_t3
              if S_right_t3 = 'nil && S_t3 = 'BLANK
                 goto save_left_1b_t3 else save_left_1p_t3

save_left_1b_t3: from save_left_t3
                 S_t3 ^= 'BLANK
                 goto save_left_d_t3

save_left_1p_t3: from save_left_t3
                 S_right_t3 <- (S_t3 . S_right_t3)
                 goto save_left_d_t3

save_left_d_t3: fi S_right_t3 = 'nil
                   from save_left_1b_t3 else save_left_1p_t3
                goto save_t3_left_done

save_t3_left_done: from save_left_d_t3
                   goto save_t3_final

// RIGHT save t3: push S_t3 onto S_left_t3
save_right_t3: from save_right_or_stay_t3
               if S_left_t3 = 'nil && S_t3 = 'BLANK
                  goto save_right_1b_t3 else save_right_1p_t3

save_right_1b_t3: from save_right_t3
                  S_t3 ^= 'BLANK
                  goto save_right_d_t3

save_right_1p_t3: from save_right_t3
                  S_left_t3 <- (S_t3 . S_left_t3)
                  goto save_right_d_t3

save_right_d_t3: fi S_left_t3 = 'nil
                    from save_right_1b_t3 else save_right_1p_t3
                 goto save_t3_right_done

save_t3_right_done: from save_right_d_t3
                    goto save_t3_done

save_t3_done: fi S2_t3 = 'RIGHT
                 from save_t3_right_done else save_stay_t3
              goto save_t3_final

// Merge save t3 paths → transition to load phase
save_t3_final: fi S2_t3 = 'LEFT
                  from save_t3_left_done else save_t3_done
               goto load_t3

// --- Load Tape 3 ---
load_t3: from save_t3_final
         if S2_t3 = 'LEFT goto load_left_t3 else load_right_or_stay_t3

load_right_or_stay_t3: from load_t3
                       if S2_t3 = 'RIGHT goto load_right_t3 else load_stay_t3

load_stay_t3: from load_right_or_stay_t3
              goto load_t3_done

// LEFT load t3: pop from S_left_t3 into S_t3
load_left_t3: from load_t3
              if S_left_t3 = 'nil
                 goto load_left_2b_t3 else load_left_2p_t3

load_left_2b_t3: from load_left_t3
                 S_t3 ^= 'BLANK
                 goto load_left_d_t3

load_left_2p_t3: from load_left_t3
                 (S_t3 . S_left_t3) <- S_left_t3
                 goto load_left_d_t3

load_left_d_t3: fi S_left_t3 = 'nil && S_t3 = 'BLANK
                   from load_left_2b_t3 else load_left_2p_t3
                goto load_t3_left_done

load_t3_left_done: from load_left_d_t3
                   goto load_t2

// RIGHT load t3: pop from S_right_t3 into S_t3
load_right_t3: from load_right_or_stay_t3
               if S_right_t3 = 'nil
                  goto load_right_2b_t3 else load_right_2p_t3

load_right_2b_t3: from load_right_t3
                  S_t3 ^= 'BLANK
                  goto load_right_d_t3

load_right_2p_t3: from load_right_t3
                  (S_t3 . S_right_t3) <- S_right_t3
                  goto load_right_d_t3

load_right_d_t3: fi S_right_t3 = 'nil && S_t3 = 'BLANK
                    from load_right_2b_t3 else load_right_2p_t3
                 goto load_t3_right_done

load_t3_right_done: from load_right_d_t3
                    goto load_t3_done

load_t3_done: fi S2_t3 = 'RIGHT
                 from load_t3_right_done else load_stay_t3
              goto load_t2

// --- Load Tape 2 ---
load_t2: fi S2_t3 = 'LEFT
            from load_t3_left_done else load_t3_done
         if S2_t2 = 'LEFT goto load_left_t2 else load_right_or_stay_t2

load_right_or_stay_t2: from load_t2
                       if S2_t2 = 'RIGHT goto load_right_t2 else load_stay_t2

load_stay_t2: from load_right_or_stay_t2
              goto load_t2_done

// LEFT load t2: pop from S_left_t2 into S_t2
load_left_t2: from load_t2
              if S_left_t2 = 'nil
                 goto load_left_2b_t2 else load_left_2p_t2

load_left_2b_t2: from load_left_t2
                 S_t2 ^= 'BLANK
                 goto load_left_d_t2

load_left_2p_t2: from load_left_t2
                 (S_t2 . S_left_t2) <- S_left_t2
                 goto load_left_d_t2

load_left_d_t2: fi S_left_t2 = 'nil && S_t2 = 'BLANK
                   from load_left_2b_t2 else load_left_2p_t2
                goto load_t2_left_done

load_t2_left_done: from load_left_d_t2
                   goto load_t1

// RIGHT load t2: pop from S_right_t2 into S_t2
load_right_t2: from load_right_or_stay_t2
               if S_right_t2 = 'nil
                  goto load_right_2b_t2 else load_right_2p_t2

load_right_2b_t2: from load_right_t2
                  S_t2 ^= 'BLANK
                  goto load_right_d_t2

load_right_2p_t2: from load_right_t2
                  (S_t2 . S_right_t2) <- S_right_t2
                  goto load_right_d_t2

load_right_d_t2: fi S_right_t2 = 'nil && S_t2 = 'BLANK
                    from load_right_2b_t2 else load_right_2p_t2
                 goto load_t2_right_done

load_t2_right_done: from load_right_d_t2
                    goto load_t2_done

load_t2_done: fi S2_t2 = 'RIGHT
                 from load_t2_right_done else load_stay_t2
              goto load_t1

// --- Load Tape 1 ---
load_t1: fi S2_t2 = 'LEFT
            from load_t2_left_done else load_t2_done
         if S2_t1 = 'LEFT goto load_left_t1 else load_right_or_stay_t1

load_right_or_stay_t1: from load_t1
                       if S2_t1 = 'RIGHT goto load_right_t1 else load_stay_t1

load_stay_t1: from load_right_or_stay_t1
              goto load_t1_done

// LEFT load t1: pop from S_left_t1 into S_t1
load_left_t1: from load_t1
              if S_left_t1 = 'nil
                 goto load_left_2b_t1 else load_left_2p_t1

load_left_2b_t1: from load_left_t1
                 S_t1 ^= 'BLANK
                 goto load_left_d_t1

load_left_2p_t1: from load_left_t1
                 (S_t1 . S_left_t1) <- S_left_t1
                 goto load_left_d_t1

load_left_d_t1: fi S_left_t1 = 'nil && S_t1 = 'BLANK
                   from load_left_2b_t1 else load_left_2p_t1
                goto load_t1_left_done

load_t1_left_done: from load_left_d_t1
                   goto shft2

// RIGHT load t1: pop from S_right_t1 into S_t1
load_right_t1: from load_right_or_stay_t1
               if S_right_t1 = 'nil
                  goto load_right_2b_t1 else load_right_2p_t1

load_right_2b_t1: from load_right_t1
                  S_t1 ^= 'BLANK
                  goto load_right_d_t1

load_right_2p_t1: from load_right_t1
                  (S_t1 . S_right_t1) <- S_right_t1
                  goto load_right_d_t1

load_right_d_t1: fi S_right_t1 = 'nil && S_t1 = 'BLANK
                    from load_right_2b_t1 else load_right_2p_t1
                 goto load_t1_right_done

load_t1_right_done: from load_right_d_t1
                    goto load_t1_done

load_t1_done: fi S2_t1 = 'RIGHT
                 from load_t1_right_done else load_stay_t1
              goto shft2

// ================================================================

shft2: fi S2_t1 = 'LEFT
          from load_t1_left_done else load_t1_done
       goto shft3

shft3: fi Q = Q2
          from shft2 else shft
       goto act2

act2: fi S1_t1 = 'SLASH && S1_t2 = 'SLASH && S1_t3 = 'SLASH
         from shft3 else symbol2
      Rule <- (Q1 . (S1_t1 . (S2_t1 . (S1_t2 . (S2_t2 . (S1_t3 . (S2_t3 . Q2)))))))
      RulesRev <- (Rule . RulesRev)
      if Rules goto act3 else reload

reload: fi Rules
           from reload else act2
        (Rule . RulesRev) <- RulesRev
        Rules <- (Rule . Rules)
        if RulesRev
           goto reload else act3

act3: fi !RulesRev
         from reload else act2
      if !RulesRev && Q = End
         goto stop else act1

stop: from act3
      Q ^= End
      S_t3 ^= 'BLANK
      S_t2 ^= 'BLANK
      S_t1 ^= 'BLANK
      exit
