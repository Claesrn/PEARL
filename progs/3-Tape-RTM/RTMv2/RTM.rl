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
         S_t1 ^= S1_t1
         S_t2 ^= S1_t2
         S_t3 ^= S1_t3
         S_t3 ^= S2_t3
         S_t2 ^= S2_t2
         S_t1 ^= S2_t1
         goto symbol2

symbol2: fi Q = Q2 && S_t1 = S2_t1 && S_t2 = S2_t2 && S_t3 = S2_t3
            from symbol1 else symbol
         goto act2

shft: from act1
      if Q = Q1 goto shft1 else shft3

shft1: from shft
       Q ^= Q1
       Q ^= Q2
       goto move_t1

// Tape 1 movement
move_t1: from shft1
         if S2_t1 = 'LEFT goto left_t1 else right_or_stay_t1

right_or_stay_t1: from move_t1
                  if S2_t1 = 'RIGHT goto right_t1 else stay_t1

stay_t1: from right_or_stay_t1
         goto move_t1_done

left_t1: from move_t1
         if S_right_t1 = 'nil && S_t1 = 'BLANK
            goto left_1b_t1 else left_1p_t1

left_1b_t1: from left_t1
            S_t1 ^= 'BLANK
            goto left1_t1

left_1p_t1: from left_t1
            S_right_t1 <- (S_t1 . S_right_t1)
            goto left1_t1

left1_t1: fi S_right_t1 = 'nil
             from left_1b_t1 else left_1p_t1
          if S_left_t1 = 'nil
             goto left_2b_t1 else left_2p_t1

left_2b_t1: from left1_t1
            S_t1 ^= 'BLANK
            goto left2_t1

left_2p_t1: from left1_t1
            (S_t1 . S_left_t1) <- S_left_t1
            goto left2_t1

left2_t1: fi S_left_t1 = 'nil && S_t1 = 'BLANK
             from left_2b_t1 else left_2p_t1
          goto move_t1_left_done

move_t1_left_done: from left2_t1
                   goto move_t2

right_t1: from right_or_stay_t1
          if S_left_t1 = 'nil && S_t1 = 'BLANK
             goto right_1b_t1 else right_1p_t1

right_1b_t1: from right_t1
             S_t1 ^= 'BLANK
             goto right1_t1

right_1p_t1: from right_t1
             S_left_t1 <- (S_t1 . S_left_t1)
             goto right1_t1

right1_t1: fi S_left_t1 = 'nil
              from right_1b_t1 else right_1p_t1
           if S_right_t1 = 'nil
              goto right_2b_t1 else right_2p_t1

right_2b_t1: from right1_t1
             S_t1 ^= 'BLANK
             goto right2_t1

right_2p_t1: from right1_t1
             (S_t1 . S_right_t1) <- S_right_t1
             goto right2_t1

right2_t1: fi S_right_t1 = 'nil && S_t1 = 'BLANK
              from right_2b_t1 else right_2p_t1
           goto move_t1_right_done

move_t1_right_done: from right2_t1
                    goto move_t1_done

move_t1_done: fi S2_t1 = 'RIGHT
                 from move_t1_right_done else stay_t1
              goto move_t2

// Tape 2 movement
move_t2: fi S2_t1 = 'LEFT
            from move_t1_left_done else move_t1_done
         if S2_t2 = 'LEFT goto left_t2 else right_or_stay_t2

right_or_stay_t2: from move_t2
                  if S2_t2 = 'RIGHT goto right_t2 else stay_t2

stay_t2: from right_or_stay_t2
         goto move_t2_done

left_t2: from move_t2
         if S_right_t2 = 'nil && S_t2 = 'BLANK
            goto left_1b_t2 else left_1p_t2

left_1b_t2: from left_t2
            S_t2 ^= 'BLANK
            goto left1_t2

left_1p_t2: from left_t2
            S_right_t2 <- (S_t2 . S_right_t2)
            goto left1_t2

left1_t2: fi S_right_t2 = 'nil
             from left_1b_t2 else left_1p_t2
          if S_left_t2 = 'nil
             goto left_2b_t2 else left_2p_t2

left_2b_t2: from left1_t2
            S_t2 ^= 'BLANK
            goto left2_t2

left_2p_t2: from left1_t2
            (S_t2 . S_left_t2) <- S_left_t2
            goto left2_t2

left2_t2: fi S_left_t2 = 'nil && S_t2 = 'BLANK
             from left_2b_t2 else left_2p_t2
          goto move_t2_left_done

move_t2_left_done: from left2_t2
                   goto move_t3

right_t2: from right_or_stay_t2
          if S_left_t2 = 'nil && S_t2 = 'BLANK
             goto right_1b_t2 else right_1p_t2

right_1b_t2: from right_t2
             S_t2 ^= 'BLANK
             goto right1_t2

right_1p_t2: from right_t2
             S_left_t2 <- (S_t2 . S_left_t2)
             goto right1_t2

right1_t2: fi S_left_t2 = 'nil
              from right_1b_t2 else right_1p_t2
           if S_right_t2 = 'nil
              goto right_2b_t2 else right_2p_t2

right_2b_t2: from right1_t2
             S_t2 ^= 'BLANK
             goto right2_t2

right_2p_t2: from right1_t2
             (S_t2 . S_right_t2) <- S_right_t2
             goto right2_t2

right2_t2: fi S_right_t2 = 'nil && S_t2 = 'BLANK
              from right_2b_t2 else right_2p_t2
           goto move_t2_right_done

move_t2_right_done: from right2_t2
                    goto move_t2_done

move_t2_done: fi S2_t2 = 'RIGHT
                 from move_t2_right_done else stay_t2
              goto move_t3

// Tape 3 movement
move_t3: fi S2_t2 = 'LEFT
            from move_t2_left_done else move_t2_done
         if S2_t3 = 'LEFT goto left_t3 else right_or_stay_t3

right_or_stay_t3: from move_t3
                  if S2_t3 = 'RIGHT goto right_t3 else stay_t3

stay_t3: from right_or_stay_t3
         goto move_t3_done

left_t3: from move_t3
         if S_right_t3 = 'nil && S_t3 = 'BLANK
            goto left_1b_t3 else left_1p_t3

left_1b_t3: from left_t3
            S_t3 ^= 'BLANK
            goto left1_t3

left_1p_t3: from left_t3
            S_right_t3 <- (S_t3 . S_right_t3)
            goto left1_t3

left1_t3: fi S_right_t3 = 'nil
             from left_1b_t3 else left_1p_t3
          if S_left_t3 = 'nil
             goto left_2b_t3 else left_2p_t3

left_2b_t3: from left1_t3
            S_t3 ^= 'BLANK
            goto left2_t3

left_2p_t3: from left1_t3
            (S_t3 . S_left_t3) <- S_left_t3
            goto left2_t3

left2_t3: fi S_left_t3 = 'nil && S_t3 = 'BLANK
             from left_2b_t3 else left_2p_t3
          goto move_t3_left_done

move_t3_left_done: from left2_t3
                   goto shft2

right_t3: from right_or_stay_t3
          if S_left_t3 = 'nil && S_t3 = 'BLANK
             goto right_1b_t3 else right_1p_t3

right_1b_t3: from right_t3
             S_t3 ^= 'BLANK
             goto right1_t3

right_1p_t3: from right_t3
             S_left_t3 <- (S_t3 . S_left_t3)
             goto right1_t3

right1_t3: fi S_left_t3 = 'nil
              from right_1b_t3 else right_1p_t3
           if S_right_t3 = 'nil
              goto right_2b_t3 else right_2p_t3

right_2b_t3: from right1_t3
             S_t3 ^= 'BLANK
             goto right2_t3

right_2p_t3: from right1_t3
             (S_t3 . S_right_t3) <- S_right_t3
             goto right2_t3

right2_t3: fi S_right_t3 = 'nil && S_t3 = 'BLANK
              from right_2b_t3 else right_2p_t3
           goto move_t3_right_done

move_t3_right_done: from right2_t3
                    goto move_t3_done

move_t3_done: fi S2_t3 = 'RIGHT
                 from move_t3_right_done else stay_t3
              goto shft2

shft2: fi S2_t3 = 'LEFT
          from move_t3_left_done else move_t3_done
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
