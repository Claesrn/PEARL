(Start End Rules S_right_t1 S_right_t2 S_right_t3) -> (Start End Rules S_right_t1 S_right_t2 S_right_t3) with (Q Q1 Q2 S1_t1 S2_t1 S1_t2 S2_t2 S1_t3 S2_t3 S_t1 S_t2 S_t3 S_left_t1 S_left_t2 S_left_t3 RulesRev Rule)

init:
	from act1
	Q ^= Start
	S_t3 ^= 'BLANK
	S_t2 ^= 'BLANK
	S_t1 ^= 'BLANK
	exit

act1:
	fi (((S1_t1 = 'SLASH) && (S1_t2 = 'SLASH)) && (S1_t3 = 'SLASH))
		from shft
		else symbol
	Rule <- (Q1 . (S1_t1 . (S2_t1 . (S1_t2 . (S2_t2 . (S1_t3 . (S2_t3 . Q2)))))))
	Rules <- (Rule . Rules)
	if (!(RulesRev) && (Q = Start))
		goto init
		else act3

symbol:
	fi ((((Q = Q1) && (S_t1 = S1_t1)) && (S_t2 = S1_t2)) && (S_t3 = S1_t3))
		from symbol1
		else symbol2
	goto act1

symbol1:
	from symbol2
	S_t1 ^= S2_t1
	S_t2 ^= S2_t2
	S_t3 ^= S2_t3
	S_t3 ^= S1_t3
	S_t2 ^= S1_t2
	S_t1 ^= S1_t1
	Q ^= Q2
	Q ^= Q1
	goto symbol

symbol2:
	from act2
	if ((((Q = Q2) && (S_t1 = S2_t1)) && (S_t2 = S2_t2)) && (S_t3 = S2_t3))
		goto symbol1
		else symbol

shft:
	fi (Q = Q1)
		from shft1
		else shft3
	goto act1

shft1:
	from move_t1
	Q ^= Q2
	Q ^= Q1
	goto shft

move_t1:
	fi (S2_t1 = 'LEFT)
		from left_t1
		else right_or_stay_t1
	goto shft1

right_or_stay_t1:
	fi (S2_t1 = 'RIGHT)
		from right_t1
		else stay_t1
	goto move_t1

stay_t1:
	from move_t1_done
	goto right_or_stay_t1

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
	from move_t1_left_done
	if ((S_left_t1 = 'nil) && (S_t1 = 'BLANK))
		goto left_2b_t1
		else left_2p_t1

move_t1_left_done:
	from move_t2
	goto left2_t1

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
	from move_t1_right_done
	if ((S_right_t1 = 'nil) && (S_t1 = 'BLANK))
		goto right_2b_t1
		else right_2p_t1

move_t1_right_done:
	from move_t1_done
	goto right2_t1

move_t1_done:
	from move_t2
	if (S2_t1 = 'RIGHT)
		goto move_t1_right_done
		else stay_t1

move_t2:
	fi (S2_t2 = 'LEFT)
		from left_t2
		else right_or_stay_t2
	if (S2_t1 = 'LEFT)
		goto move_t1_left_done
		else move_t1_done

right_or_stay_t2:
	fi (S2_t2 = 'RIGHT)
		from right_t2
		else stay_t2
	goto move_t2

stay_t2:
	from move_t2_done
	goto right_or_stay_t2

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
	from move_t2_left_done
	if ((S_left_t2 = 'nil) && (S_t2 = 'BLANK))
		goto left_2b_t2
		else left_2p_t2

move_t2_left_done:
	from move_t3
	goto left2_t2

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
	from move_t2_right_done
	if ((S_right_t2 = 'nil) && (S_t2 = 'BLANK))
		goto right_2b_t2
		else right_2p_t2

move_t2_right_done:
	from move_t2_done
	goto right2_t2

move_t2_done:
	from move_t3
	if (S2_t2 = 'RIGHT)
		goto move_t2_right_done
		else stay_t2

move_t3:
	fi (S2_t3 = 'LEFT)
		from left_t3
		else right_or_stay_t3
	if (S2_t2 = 'LEFT)
		goto move_t2_left_done
		else move_t2_done

right_or_stay_t3:
	fi (S2_t3 = 'RIGHT)
		from right_t3
		else stay_t3
	goto move_t3

stay_t3:
	from move_t3_done
	goto right_or_stay_t3

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
	from move_t3_left_done
	if ((S_left_t3 = 'nil) && (S_t3 = 'BLANK))
		goto left_2b_t3
		else left_2p_t3

move_t3_left_done:
	from shft2
	goto left2_t3

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
	from move_t3_right_done
	if ((S_right_t3 = 'nil) && (S_t3 = 'BLANK))
		goto right_2b_t3
		else right_2p_t3

move_t3_right_done:
	from move_t3_done
	goto right2_t3

move_t3_done:
	from shft2
	if (S2_t3 = 'RIGHT)
		goto move_t3_right_done
		else stay_t3

shft2:
	from shft3
	if (S2_t3 = 'LEFT)
		goto move_t3_left_done
		else move_t3_done

shft3:
	from act2
	if (Q = Q2)
		goto shft2
		else shft

act2:
	fi Rules
		from act3
		else reload
	(Rule . RulesRev) <- RulesRev
	(Q1 . (S1_t1 . (S2_t1 . (S1_t2 . (S2_t2 . (S1_t3 . (S2_t3 . Q2))))))) <- Rule
	if (((S1_t1 = 'SLASH) && (S1_t2 = 'SLASH)) && (S1_t3 = 'SLASH))
		goto shft3
		else symbol2

reload:
	fi RulesRev
		from reload
		else act3
	(Rule . Rules) <- Rules
	RulesRev <- (Rule . RulesRev)
	if Rules
		goto reload
		else act2

act3:
	fi (!(RulesRev) && (Q = End))
		from stop
		else act1
	if !(RulesRev)
		goto reload
		else act2

stop:
	entry
	S_t1 ^= 'BLANK
	S_t2 ^= 'BLANK
	S_t3 ^= 'BLANK
	Q ^= End
	goto act3
