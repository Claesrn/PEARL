(Start End Rules S_right_t1 S_right_t2 S_right_t3) -> (Start End Rules S_right_t1 S_right_t2 S_right_t3) with (Q Q1 Q2 S1_t1 S2_t1 S1_t2 S2_t2 S1_t3 S2_t3 S_t1 S_t2 S_t3 S_left_t1 S_left_t2 S_left_t3 RulesRev Rule Rules')

init:
	fi (Start = End)
		from stop
		else act1
	Rules' ^= Rules
	Q ^= Start
	'BLANK <- S_t3
	'BLANK <- S_t2
	'BLANK <- S_t1
	exit

stop:
	entry
	Q ^= End
	S_t3 <- 'BLANK
	S_t2 <- 'BLANK
	S_t1 <- 'BLANK
	Rules' ^= Rules
	if (Start = End)
		goto init
		else act4

act1:
	fi ((((Q = Q1) && (S_t1 = S1_t1)) && (S_t2 = S1_t2)) && (S_t3 = S1_t3))
		from write
		else act2
	Rules' <- ((Q1 . (S1_t1 . (S2_t1 . (S1_t2 . (S2_t2 . (S1_t3 . (S2_t3 . Q2))))))) . Rules')
	if (!(RulesRev) && (Q = Start))
		goto init
		else act4

write:
	from act2
	S_t3 ^= S2_t3
	S_t3 ^= S1_t3
	S_t2 ^= S2_t2
	S_t2 ^= S1_t2
	S_t1 ^= S2_t1
	S_t1 ^= S1_t1
	Q ^= Q2
	Q ^= Q1
	goto act1

act2:
	fi ((((Q = Q1) && (S1_t1 = 'SLASH)) && (S1_t2 = 'SLASH)) && (S1_t3 = 'SLASH))
		from move_t1
		else act3
	if ((((Q = Q2) && (S_t1 = S2_t1)) && (S_t2 = S2_t2)) && (S_t3 = S2_t3))
		goto write
		else act1

act3:
	fi Rules'
		from act4
		else reload
	((Q1 . (S1_t1 . (S2_t1 . (S1_t2 . (S2_t2 . (S1_t3 . (S2_t3 . Q2))))))) . RulesRev) <- RulesRev
	if ((((Q = Q2) && (S1_t1 = 'SLASH)) && (S1_t2 = 'SLASH)) && S1_t3)
		goto move1
		else act2

reload:
	fi RulesRev
		from reload
		else act4
	(Rule . Rules') <- Rules'
	RulesRev <- (Rule . RulesRev)
	if Rules'
		goto reload
		else act3

act4:
	fi (!(RulesRev) && (Q = End))
		from stop
		else act1
	if !(RulesRev)
		goto reload
		else act3

move_t1:
	fi (S2_t1 = 'LEFT)
		from left_t1
		else right_or_stay_t1
	Q ^= Q2
	Q ^= Q1
	goto act2

left_t1:
	fi ((S_right_t1 = 'nil) && (S_t1 = 'BLANK))
		from left_1b_t1
		else left_1p_t1
	goto move_t1

left_1b_t1:
	from left1_t1
	S_t1 ^= 'BLANK
	goto left_t1

left_1p_t1:
	from left1_t1
	(S_t1 . S_right_t1) <- S_right_t1
	goto left_t1

left1_t1:
	fi (S_left_t1 = 'nil)
		from left_2b_t1
		else left_2p_t1
	if (S_right_t1 = 'nil)
		goto left_1b_t1
		else left_1p_t1

left_2b_t1:
	from left2_t1
	S_t1 ^= 'BLANK
	goto left1_t1

left_2p_t1:
	from left2_t1
	S_left_t1 <- (S_t1 . S_left_t1)
	goto left1_t1

left2_t1:
	from move_t2
	if ((S_left_t1 = 'nil) && (S_t1 = 'BLANK))
		goto left_2b_t1
		else left_2p_t1

right_or_stay_t1:
	fi (S2_t1 = 'RIGHT)
		from right_t1
		else stay_t1
	goto move_t1

right_t1:
	fi ((S_left_t1 = 'nil) && (S_t1 = 'BLANK))
		from right_1b_t1
		else right_1p_t1
	goto right_or_stay_t1

right_1b_t1:
	from right1_t1
	S_t1 ^= 'BLANK
	goto right_t1

right_1p_t1:
	from right1_t1
	(S_t1 . S_left_t1) <- S_left_t1
	goto right_t1

right1_t1:
	fi (S_right_t1 = 'nil)
		from right_2b_t1
		else right_2p_t1
	if (S_left_t1 = 'nil)
		goto right_1b_t1
		else right_1p_t1

right_2b_t1:
	from right2_t1
	S_t1 ^= 'BLANK
	goto right1_t1

right_2p_t1:
	from right2_t1
	S_right_t1 <- (S_t1 . S_right_t1)
	goto right1_t1

right2_t1:
	from move_t1_right_or_stay
	if ((S_right_t1 = 'nil) && (S_t1 = 'BLANK))
		goto right_2b_t1
		else right_2p_t1

stay_t1:
	from move_t1_right_or_stay
	goto right_or_stay_t1

move_t1_right_or_stay:
	from move_t2
	if (S2_t1 = 'RIGHT)
		goto right2_t1
		else stay_t1

move_t2:
	fi (S2_t2 = 'LEFT)
		from left_t2
		else right_or_stay_t2
	if (S2_t1 = 'LEFT)
		goto left2_t1
		else move_t1_right_or_stay

left_t2:
	fi ((S_right_t2 = 'nil) && (S_t2 = 'BLANK))
		from left_1b_t2
		else left_1p_t2
	goto move_t2

left_1b_t2:
	from left1_t2
	S_t2 ^= 'BLANK
	goto left_t2

left_1p_t2:
	from left1_t2
	(S_t2 . S_right_t2) <- S_right_t2
	goto left_t2

left1_t2:
	fi (S_left_t2 = 'nil)
		from left_2b_t2
		else left_2p_t2
	if (S_right_t2 = 'nil)
		goto left_1b_t2
		else left_1p_t2

left_2b_t2:
	from left2_t2
	S_t2 ^= 'BLANK
	goto left1_t2

left_2p_t2:
	from left2_t2
	S_left_t2 <- (S_t2 . S_left_t2)
	goto left1_t2

left2_t2:
	from move_t3
	if ((S_left_t2 = 'nil) && (S_t2 = 'BLANK))
		goto left_2b_t2
		else left_2p_t2

right_or_stay_t2:
	fi (S2_t2 = 'RIGHT)
		from right_t2
		else stay_t2
	goto move_t2

right_t2:
	fi ((S_left_t2 = 'nil) && (S_t2 = 'BLANK))
		from right_1b_t2
		else right_1p_t2
	goto right_or_stay_t2

right_1b_t2:
	from right1_t2
	S_t2 ^= 'BLANK
	goto right_t2

right_1p_t2:
	from right1_t2
	(S_t2 . S_left_t2) <- S_left_t2
	goto right_t2

right1_t2:
	fi (S_right_t2 = 'nil)
		from right_2b_t2
		else right_2p_t2
	if (S_left_t2 = 'nil)
		goto right_1b_t2
		else right_1p_t2

right_2b_t2:
	from right2_t2
	S_t2 ^= 'BLANK
	goto right1_t2

right_2p_t2:
	from right2_t2
	S_right_t2 <- (S_t2 . S_right_t2)
	goto right1_t2

right2_t2:
	from move1_right_or_stay
	if ((S_right_t2 = 'nil) && (S_t2 = 'BLANK))
		goto right_2b_t2
		else right_2p_t2

stay_t2:
	from move1_right_or_stay
	goto right_or_stay_t2

move1_right_or_stay:
	from move_t3
	if (S2_t2 = 'RIGHT)
		goto right2_t2
		else stay_t2

move_t3:
	fi (S2_t3 = 'LEFT)
		from left_t3
		else right_or_stay_t3
	if (S2_t2 = 'LEFT)
		goto left2_t2
		else move1_right_or_stay

left_t3:
	fi ((S_right_t3 = 'nil) && (S_t3 = 'BLANK))
		from left_1b_t3
		else left_1p_t3
	goto move_t3

left_1b_t3:
	from left1_t3
	S_t3 ^= 'BLANK
	goto left_t3

left_1p_t3:
	from left1_t3
	(S_t3 . S_right_t3) <- S_right_t3
	goto left_t3

left1_t3:
	fi (S_left_t3 = 'nil)
		from left_2b_t3
		else left_2p_t3
	if (S_right_t3 = 'nil)
		goto left_1b_t3
		else left_1p_t3

left_2b_t3:
	from left2_t3
	S_t3 ^= 'BLANK
	goto left1_t3

left_2p_t3:
	from left2_t3
	S_left_t3 <- (S_t3 . S_left_t3)
	goto left1_t3

left2_t3:
	from move1
	if ((S_left_t3 = 'nil) && (S_t3 = 'BLANK))
		goto left_2b_t3
		else left_2p_t3

right_or_stay_t3:
	fi (S2_t3 = 'RIGHT)
		from right_t3
		else stay_t3
	goto move_t3

right_t3:
	fi ((S_left_t3 = 'nil) && (S_t3 = 'BLANK))
		from right_1b_t3
		else right_1p_t3
	goto right_or_stay_t3

right_1b_t3:
	from right1_t3
	S_t3 ^= 'BLANK
	goto right_t3

right_1p_t3:
	from right1_t3
	(S_t3 . S_left_t3) <- S_left_t3
	goto right_t3

right1_t3:
	fi (S_right_t3 = 'nil)
		from right_2b_t3
		else right_2p_t3
	if (S_left_t3 = 'nil)
		goto right_1b_t3
		else right_1p_t3

right_2b_t3:
	from right2_t3
	S_t3 ^= 'BLANK
	goto right1_t3

right_2p_t3:
	from right2_t3
	S_right_t3 <- (S_t3 . S_right_t3)
	goto right1_t3

right2_t3:
	from move1_right_or_stay_t3
	if ((S_right_t3 = 'nil) && (S_t3 = 'BLANK))
		goto right_2b_t3
		else right_2p_t3

stay_t3:
	from move1_right_or_stay_t3
	goto right_or_stay_t3

move1_right_or_stay_t3:
	from move1
	if (S2_t3 = 'RIGHT)
		goto right2_t3
		else stay_t3

move1:
	from act3
	if (S2_t3 = 'LEFT)
		goto left2_t3
		else move1_right_or_stay_t3
