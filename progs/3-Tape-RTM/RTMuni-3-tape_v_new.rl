(Start End Rules S_right_t1 S_right_t2 S_right_t3) -> (Start End Rules S_right_t1 S_right_t2 S_right_t3)
with (Q Q1 Q2 S1_t1 S2_t1 S1_t2 S2_t2 S1_t3 S2_t3 S_t1 S_t2 S_t3 S_left_t1 S_left_t2 S_left_t3 RulesRev Rule Rules')

init: entry
      S_t1 <- 'BLANK
      S_t2 <- 'BLANK
      S_t3 <- 'BLANK
      Q ^= Start
      Rules' ^= Rules
      if Start = End goto stop else act1

stop: fi Start = End from init else act4
      Rules' ^= Rules
      'BLANK <- S_t1
      'BLANK <- S_t2
      'BLANK <- S_t3
      Q ^= End
      exit

act1: fi !RulesRev && Q = Start from init else act4
      ((Q1 . (S1_t1 . (S2_t1 . (S1_t2 . (S2_t2 . (S1_t3 . (S2_t3 . Q2))))))) . Rules') <- Rules' 
      if Q = Q1 && S_t1 = S1_t1 && S_t2 = S1_t2 && S_t3 = S1_t3 goto write else act2

write: from act1
       Q ^= Q1
       Q ^= Q2
       S_t1 ^= S1_t1
       S_t1 ^= S2_t1
       S_t2 ^= S1_t2
       S_t2 ^= S2_t2
       S_t3 ^= S1_t3
       S_t3 ^= S2_t3
       goto act2

act2: fi Q = Q2 && S_t1 = S2_t1 && S_t2 = S2_t2 && S_t3 = S2_t3 from write else act1
      if Q = Q1 && S1_t1 = 'SLASH && S1_t2 = 'SLASH && S1_t3 = 'SLASH goto move_t1 else act3

act3: fi Q = Q2 && S1_t1 = 'SLASH && S1_t2 = 'SLASH && S1_t3 = 'SLASH from move1 else act2
      RulesRev <- ((Q1 . (S1_t1 . (S2_t1 . (S1_t2 . (S2_t2 . (S1_t3 . (S2_t3 . Q2))))))) . RulesRev) 
      if Rules' goto act4 else reload

reload: fi Rules' from reload else act3
        (Rule . RulesRev) <- RulesRev
        Rules' <- (Rule . Rules')
        if RulesRev goto reload else act4

act4: fi !RulesRev from reload else act3
      if !RulesRev && Q = End goto stop else act1

// ------ Moving rules regarding the first tape ----------

move_t1: from act2
      Q ^= Q1
      Q ^= Q2
      if S2_t1 = 'LEFT goto left_or_other_t1 else right_or_stay_t1

left_or_other_t1: from move_t1
      goto left_t1

left_t1: from left_or_other_t1
      if S_right_t1 = 'nil && S_t1 = 'BLANK goto left_1b_t1 else left_1p_t1 

left_1b_t1: from left_t1
         S_t1 ^= 'BLANK
         goto left1_t1

left_1p_t1: from left_t1
         S_right_t1 <- (S_t1 . S_right_t1)
         goto left1_t1

left1_t1: fi S_right_t1 = 'nil from left_1b_t1 else left_1p_t1
       if S_left_t1 = 'nil goto left_2b_t1 else left_2p_t1

left_2b_t1: from left1_t1
         S_t1 ^= 'BLANK
         goto left2_t1

left_2p_t1: from left1_t1
         (S_t1 . S_left_t1) <- S_left_t1
         goto left2_t1

left2_t1: fi S_left_t1 = 'nil && S_t1 = 'BLANK from left_2b_t1 else left_2p_t1
       goto move_t1_left_or_other

move_t1_left_or_other: from left2_t1
       goto move_t2

right_or_stay_t1: from move_t1
       if S2_t1 = 'RIGHT goto right_t1 else stay_t1

right_t1: from right_or_stay_t1
       if S_left_t1 = 'nil && S_t1 = 'BLANK goto right_1b_t1 else right_1p_t1

right_1b_t1: from right_t1
          S_t1 ^= 'BLANK
          goto right1_t1

right_1p_t1: from right_t1
          S_left_t1 <- (S_t1 . S_left_t1)
          goto right1_t1

right1_t1: fi S_left_t1 = 'nil from right_1b_t1 else right_1p_t1
        if S_right_t1 = 'nil goto right_2b_t1 else right_2p_t1

right_2b_t1: from right1_t1
          S_t1 ^= 'BLANK
          goto right2_t1

right_2p_t1: from right1_t1
          (S_t1 . S_right_t1) <- S_right_t1
          goto right2_t1

right2_t1: fi S_right_t1 = 'nil && S_t1 = 'BLANK from right_2b_t1 else right_2p_t1
        goto move_t1_right_or_stay

stay_t1: from right_or_stay_t1
      if S_left_t1 = 'nil goto stay_1b_t1 else stay_1p_t1

stay_1b_t1: from stay_t1
      goto stay1_t1

stay_1p_t1: from stay_t1
      goto stay1_t1

stay1_t1: fi S_left_t1 = 'nil from stay_1b_t1 else stay_1p_t1
      if S_right_t1 = 'nil goto stay_2b_t1 else stay_2p_t1

stay_2b_t1: from stay1_t1
      goto stay2_t1

stay_2p_t1: from stay1_t1
      goto stay2_t1

stay2_t1: fi S_right_t1 = 'nil from stay_2b_t1 else stay_2p_t1
      goto move_t1_right_or_stay

move_t1_right_or_stay: fi S2_t1 = 'RIGHT from right2_t1 else stay2_t1
      goto move_t2

move_t2: fi S2_t1 = 'LEFT from move_t1_left_or_other else move_t1_right_or_stay
      if S2_t2 = 'LEFT goto left_or_other_t2 else right_or_stay_t2

// ------ Moving rules regarding the second tape ----------

left_or_other_t2: from move_t2
      goto left_t2

left_t2: from left_or_other_t2
      if S_right_t2 = 'nil && S_t2 = 'BLANK goto left_1b_t2 else left_1p_t2 

left_1b_t2: from left_t2
         S_t2 ^= 'BLANK
         goto left1_t2

left_1p_t2: from left_t2
         S_right_t2 <- (S_t2 . S_right_t2)
         goto left1_t2

left1_t2: fi S_right_t2 = 'nil from left_1b_t2 else left_1p_t2
       if S_left_t2 = 'nil goto left_2b_t2 else left_2p_t2

left_2b_t2: from left1_t2
         S_t2 ^= 'BLANK
         goto left2_t2

left_2p_t2: from left1_t2
         (S_t2 . S_left_t2) <- S_left_t2
         goto left2_t2

left2_t2: fi S_left_t2 = 'nil && S_t2 = 'BLANK from left_2b_t2 else left_2p_t2
       goto move_t2_left_or_other

move_t2_left_or_other: from left2_t2
       goto move_t3

right_or_stay_t2: from move_t2
       if S2_t2 = 'RIGHT goto right_t2 else stay_t2

right_t2: from right_or_stay_t2
       if S_left_t2 = 'nil && S_t2 = 'BLANK goto right_1b_t2 else right_1p_t2

right_1b_t2: from right_t2
          S_t2 ^= 'BLANK
          goto right1_t2

right_1p_t2: from right_t2
          S_left_t2 <- (S_t2 . S_left_t2)
          goto right1_t2

right1_t2: fi S_left_t2 = 'nil from right_1b_t2 else right_1p_t2
        if S_right_t2 = 'nil goto right_2b_t2 else right_2p_t2

right_2b_t2: from right1_t2
          S_t2 ^= 'BLANK
          goto right2_t2

right_2p_t2: from right1_t2
          (S_t2 . S_right_t2) <- S_right_t2
          goto right2_t2

right2_t2: fi S_right_t2 = 'nil && S_t2 = 'BLANK from right_2b_t2 else right_2p_t2
        goto move1_right_or_stay

stay_t2: from right_or_stay_t2
      if S_left_t2 = 'nil goto stay_1b_t2 else stay_1p_t2

stay_1b_t2: from stay_t2
      goto stay1_t2

stay_1p_t2: from stay_t2
      goto stay1_t2

stay1_t2: fi S_left_t2 = 'nil from stay_1b_t2 else stay_1p_t2
      if S_right_t2 = 'nil goto stay_2b_t2 else stay_2p_t2

stay_2b_t2: from stay1_t2
      goto stay2_t2

stay_2p_t2: from stay1_t2
      goto stay2_t2

stay2_t2: fi S_right_t2 = 'nil from stay_2b_t2 else stay_2p_t2
      goto move1_right_or_stay

move1_right_or_stay: fi S2_t2 = 'RIGHT from right2_t2 else stay2_t2
      goto move_t3

move_t3:  fi S2_t2 = 'LEFT from move_t2_left_or_other else move1_right_or_stay
      if S2_t3 = 'LEFT goto left_or_other_t3 else right_or_stay_t3

// ------ Moving rules regarding the third tape ----------

left_or_other_t3: from move_t3
      goto left_t3

left_t3: from left_or_other_t3
      if S_right_t3 = 'nil && S_t3 = 'BLANK goto left_1b_t3 else left_1p_t3 

left_1b_t3: from left_t3
         S_t3 ^= 'BLANK
         goto left1_t3

left_1p_t3: from left_t3
         S_right_t3 <- (S_t3 . S_right_t3)
         goto left1_t3

left1_t3: fi S_right_t3 = 'nil from left_1b_t3 else left_1p_t3
       if S_left_t3 = 'nil goto left_2b_t3 else left_2p_t3

left_2b_t3: from left1_t3
         S_t3 ^= 'BLANK
         goto left2_t3

left_2p_t3: from left1_t3
         (S_t3 . S_left_t3) <- S_left_t3
         goto left2_t3

left2_t3: fi S_left_t3 = 'nil && S_t3 = 'BLANK from left_2b_t3 else left_2p_t3
       goto move_t3_left_or_other

move_t3_left_or_other: from left2_t3
       goto move1

right_or_stay_t3: from move_t3
       if S2_t3 = 'RIGHT goto right_t3 else stay_t3

right_t3: from right_or_stay_t3
       if S_left_t3 = 'nil && S_t3 = 'BLANK goto right_1b_t3 else right_1p_t3

right_1b_t3: from right_t3
          S_t3 ^= 'BLANK
          goto right1_t3

right_1p_t3: from right_t3
          S_left_t3 <- (S_t3 . S_left_t3)
          goto right1_t3

right1_t3: fi S_left_t3 = 'nil from right_1b_t3 else right_1p_t3
        if S_right_t3 = 'nil goto right_2b_t3 else right_2p_t3

right_2b_t3: from right1_t3
          S_t3 ^= 'BLANK
          goto right2_t3

right_2p_t3: from right1_t3
          (S_t3 . S_right_t3) <- S_right_t3
          goto right2_t3

right2_t3: fi S_right_t3 = 'nil && S_t3 = 'BLANK from right_2b_t3 else right_2p_t3
        goto move1_right_or_stay_t3

stay_t3: from right_or_stay_t3
      if S_left_t3 = 'nil goto stay_1b_t3 else stay_1p_t3

stay_1b_t3: from stay_t3
      goto stay1_t3

stay_1p_t3: from stay_t3
      goto stay1_t3

stay1_t3: fi S_left_t3 = 'nil from stay_1b_t3 else stay_1p_t3
      if S_right_t3 = 'nil goto stay_2b_t3 else stay_2p_t3

stay_2b_t3: from stay1_t3
      goto stay2_t3

stay_2p_t3: from stay1_t3
      goto stay2_t3

stay2_t3: fi S_right_t3 = 'nil from stay_2b_t3 else stay_2p_t3
      goto move1_right_or_stay_t3

move1_right_or_stay_t3: fi S2_t3 = 'RIGHT from right2_t3 else stay2_t3
      goto move1

move1: fi S2_t3 = 'LEFT from move_t3_left_or_other else move1_right_or_stay_t3
       goto act3