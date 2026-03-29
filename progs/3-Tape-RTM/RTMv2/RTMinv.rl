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
	S_t3 ^= S2_t3
	S_t2 ^= S2_t2
	S_t1 ^= S2_t1
	S_t1 ^= S1_t1
	S_t2 ^= S1_t2
	S_t3 ^= S1_t3
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
	from save_t1
	Q ^= Q2
	Q ^= Q1
	goto shft

save_t1:
	fi (S2_t1 = 'LEFT)
		from save_left_t1
		else save_right_or_stay_t1
	goto shft1

save_right_or_stay_t1:
	fi (S2_t1 = 'RIGHT)
		from save_right_t1
		else save_stay_t1
	goto save_t1

save_stay_t1:
	from save_t1_done
	goto save_right_or_stay_t1

save_left_t1:
	fi ((S_right_t1 = 'nil) && (S_t1 = 'BLANK))
		from save_left_1b_t1
		else save_left_1p_t1
	goto save_t1

save_left_1b_t1:
	from save_left_d_t1
	S_t1 ^= 'BLANK
	goto save_left_t1

save_left_1p_t1:
	from save_left_d_t1
	(S_t1 . S_right_t1) <- S_right_t1
	goto save_left_t1

save_left_d_t1:
	from save_t1_left_done
	if (S_right_t1 = 'nil)
		goto save_left_1b_t1
		else save_left_1p_t1

save_t1_left_done:
	from save_t2
	goto save_left_d_t1

save_right_t1:
	fi ((S_left_t1 = 'nil) && (S_t1 = 'BLANK))
		from save_right_1b_t1
		else save_right_1p_t1
	goto save_right_or_stay_t1

save_right_1b_t1:
	from save_right_d_t1
	S_t1 ^= 'BLANK
	goto save_right_t1

save_right_1p_t1:
	from save_right_d_t1
	(S_t1 . S_left_t1) <- S_left_t1
	goto save_right_t1

save_right_d_t1:
	from save_t1_right_done
	if (S_left_t1 = 'nil)
		goto save_right_1b_t1
		else save_right_1p_t1

save_t1_right_done:
	from save_t1_done
	goto save_right_d_t1

save_t1_done:
	from save_t2
	if (S2_t1 = 'RIGHT)
		goto save_t1_right_done
		else save_stay_t1

save_t2:
	fi (S2_t2 = 'LEFT)
		from save_left_t2
		else save_right_or_stay_t2
	if (S2_t1 = 'LEFT)
		goto save_t1_left_done
		else save_t1_done

save_right_or_stay_t2:
	fi (S2_t2 = 'RIGHT)
		from save_right_t2
		else save_stay_t2
	goto save_t2

save_stay_t2:
	from save_t2_done
	goto save_right_or_stay_t2

save_left_t2:
	fi ((S_right_t2 = 'nil) && (S_t2 = 'BLANK))
		from save_left_1b_t2
		else save_left_1p_t2
	goto save_t2

save_left_1b_t2:
	from save_left_d_t2
	S_t2 ^= 'BLANK
	goto save_left_t2

save_left_1p_t2:
	from save_left_d_t2
	(S_t2 . S_right_t2) <- S_right_t2
	goto save_left_t2

save_left_d_t2:
	from save_t2_left_done
	if (S_right_t2 = 'nil)
		goto save_left_1b_t2
		else save_left_1p_t2

save_t2_left_done:
	from save_t3
	goto save_left_d_t2

save_right_t2:
	fi ((S_left_t2 = 'nil) && (S_t2 = 'BLANK))
		from save_right_1b_t2
		else save_right_1p_t2
	goto save_right_or_stay_t2

save_right_1b_t2:
	from save_right_d_t2
	S_t2 ^= 'BLANK
	goto save_right_t2

save_right_1p_t2:
	from save_right_d_t2
	(S_t2 . S_left_t2) <- S_left_t2
	goto save_right_t2

save_right_d_t2:
	from save_t2_right_done
	if (S_left_t2 = 'nil)
		goto save_right_1b_t2
		else save_right_1p_t2

save_t2_right_done:
	from save_t2_done
	goto save_right_d_t2

save_t2_done:
	from save_t3
	if (S2_t2 = 'RIGHT)
		goto save_t2_right_done
		else save_stay_t2

save_t3:
	fi (S2_t3 = 'LEFT)
		from save_left_t3
		else save_right_or_stay_t3
	if (S2_t2 = 'LEFT)
		goto save_t2_left_done
		else save_t2_done

save_right_or_stay_t3:
	fi (S2_t3 = 'RIGHT)
		from save_right_t3
		else save_stay_t3
	goto save_t3

save_stay_t3:
	from save_t3_done
	goto save_right_or_stay_t3

save_left_t3:
	fi ((S_right_t3 = 'nil) && (S_t3 = 'BLANK))
		from save_left_1b_t3
		else save_left_1p_t3
	goto save_t3

save_left_1b_t3:
	from save_left_d_t3
	S_t3 ^= 'BLANK
	goto save_left_t3

save_left_1p_t3:
	from save_left_d_t3
	(S_t3 . S_right_t3) <- S_right_t3
	goto save_left_t3

save_left_d_t3:
	from save_t3_left_done
	if (S_right_t3 = 'nil)
		goto save_left_1b_t3
		else save_left_1p_t3

save_t3_left_done:
	from save_t3_final
	goto save_left_d_t3

save_right_t3:
	fi ((S_left_t3 = 'nil) && (S_t3 = 'BLANK))
		from save_right_1b_t3
		else save_right_1p_t3
	goto save_right_or_stay_t3

save_right_1b_t3:
	from save_right_d_t3
	S_t3 ^= 'BLANK
	goto save_right_t3

save_right_1p_t3:
	from save_right_d_t3
	(S_t3 . S_left_t3) <- S_left_t3
	goto save_right_t3

save_right_d_t3:
	from save_t3_right_done
	if (S_left_t3 = 'nil)
		goto save_right_1b_t3
		else save_right_1p_t3

save_t3_right_done:
	from save_t3_done
	goto save_right_d_t3

save_t3_done:
	from save_t3_final
	if (S2_t3 = 'RIGHT)
		goto save_t3_right_done
		else save_stay_t3

save_t3_final:
	from load_t3
	if (S2_t3 = 'LEFT)
		goto save_t3_left_done
		else save_t3_done

load_t3:
	fi (S2_t3 = 'LEFT)
		from load_left_t3
		else load_right_or_stay_t3
	goto save_t3_final

load_right_or_stay_t3:
	fi (S2_t3 = 'RIGHT)
		from load_right_t3
		else load_stay_t3
	goto load_t3

load_stay_t3:
	from load_t3_done
	goto load_right_or_stay_t3

load_left_t3:
	fi (S_left_t3 = 'nil)
		from load_left_2b_t3
		else load_left_2p_t3
	goto load_t3

load_left_2b_t3:
	from load_left_d_t3
	S_t3 ^= 'BLANK
	goto load_left_t3

load_left_2p_t3:
	from load_left_d_t3
	S_left_t3 <- (S_t3 . S_left_t3)
	goto load_left_t3

load_left_d_t3:
	from load_t3_left_done
	if ((S_left_t3 = 'nil) && (S_t3 = 'BLANK))
		goto load_left_2b_t3
		else load_left_2p_t3

load_t3_left_done:
	from load_t2
	goto load_left_d_t3

load_right_t3:
	fi (S_right_t3 = 'nil)
		from load_right_2b_t3
		else load_right_2p_t3
	goto load_right_or_stay_t3

load_right_2b_t3:
	from load_right_d_t3
	S_t3 ^= 'BLANK
	goto load_right_t3

load_right_2p_t3:
	from load_right_d_t3
	S_right_t3 <- (S_t3 . S_right_t3)
	goto load_right_t3

load_right_d_t3:
	from load_t3_right_done
	if ((S_right_t3 = 'nil) && (S_t3 = 'BLANK))
		goto load_right_2b_t3
		else load_right_2p_t3

load_t3_right_done:
	from load_t3_done
	goto load_right_d_t3

load_t3_done:
	from load_t2
	if (S2_t3 = 'RIGHT)
		goto load_t3_right_done
		else load_stay_t3

load_t2:
	fi (S2_t2 = 'LEFT)
		from load_left_t2
		else load_right_or_stay_t2
	if (S2_t3 = 'LEFT)
		goto load_t3_left_done
		else load_t3_done

load_right_or_stay_t2:
	fi (S2_t2 = 'RIGHT)
		from load_right_t2
		else load_stay_t2
	goto load_t2

load_stay_t2:
	from load_t2_done
	goto load_right_or_stay_t2

load_left_t2:
	fi (S_left_t2 = 'nil)
		from load_left_2b_t2
		else load_left_2p_t2
	goto load_t2

load_left_2b_t2:
	from load_left_d_t2
	S_t2 ^= 'BLANK
	goto load_left_t2

load_left_2p_t2:
	from load_left_d_t2
	S_left_t2 <- (S_t2 . S_left_t2)
	goto load_left_t2

load_left_d_t2:
	from load_t2_left_done
	if ((S_left_t2 = 'nil) && (S_t2 = 'BLANK))
		goto load_left_2b_t2
		else load_left_2p_t2

load_t2_left_done:
	from load_t1
	goto load_left_d_t2

load_right_t2:
	fi (S_right_t2 = 'nil)
		from load_right_2b_t2
		else load_right_2p_t2
	goto load_right_or_stay_t2

load_right_2b_t2:
	from load_right_d_t2
	S_t2 ^= 'BLANK
	goto load_right_t2

load_right_2p_t2:
	from load_right_d_t2
	S_right_t2 <- (S_t2 . S_right_t2)
	goto load_right_t2

load_right_d_t2:
	from load_t2_right_done
	if ((S_right_t2 = 'nil) && (S_t2 = 'BLANK))
		goto load_right_2b_t2
		else load_right_2p_t2

load_t2_right_done:
	from load_t2_done
	goto load_right_d_t2

load_t2_done:
	from load_t1
	if (S2_t2 = 'RIGHT)
		goto load_t2_right_done
		else load_stay_t2

load_t1:
	fi (S2_t1 = 'LEFT)
		from load_left_t1
		else load_right_or_stay_t1
	if (S2_t2 = 'LEFT)
		goto load_t2_left_done
		else load_t2_done

load_right_or_stay_t1:
	fi (S2_t1 = 'RIGHT)
		from load_right_t1
		else load_stay_t1
	goto load_t1

load_stay_t1:
	from load_t1_done
	goto load_right_or_stay_t1

load_left_t1:
	fi (S_left_t1 = 'nil)
		from load_left_2b_t1
		else load_left_2p_t1
	goto load_t1

load_left_2b_t1:
	from load_left_d_t1
	S_t1 ^= 'BLANK
	goto load_left_t1

load_left_2p_t1:
	from load_left_d_t1
	S_left_t1 <- (S_t1 . S_left_t1)
	goto load_left_t1

load_left_d_t1:
	from load_t1_left_done
	if ((S_left_t1 = 'nil) && (S_t1 = 'BLANK))
		goto load_left_2b_t1
		else load_left_2p_t1

load_t1_left_done:
	from shft2
	goto load_left_d_t1

load_right_t1:
	fi (S_right_t1 = 'nil)
		from load_right_2b_t1
		else load_right_2p_t1
	goto load_right_or_stay_t1

load_right_2b_t1:
	from load_right_d_t1
	S_t1 ^= 'BLANK
	goto load_right_t1

load_right_2p_t1:
	from load_right_d_t1
	S_right_t1 <- (S_t1 . S_right_t1)
	goto load_right_t1

load_right_d_t1:
	from load_t1_right_done
	if ((S_right_t1 = 'nil) && (S_t1 = 'BLANK))
		goto load_right_2b_t1
		else load_right_2p_t1

load_t1_right_done:
	from load_t1_done
	goto load_right_d_t1

load_t1_done:
	from shft2
	if (S2_t1 = 'RIGHT)
		goto load_t1_right_done
		else load_stay_t1

shft2:
	from shft3
	if (S2_t1 = 'LEFT)
		goto load_t1_left_done
		else load_t1_done

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
