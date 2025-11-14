// Describe the TM
Start = '1
End = '6
Rules =
 '((1 . (BLANK . (BLANK . (BLANK . (BLANK . (BLANK . (BLANK . 2))))))) .
  ((2 . (SLASH . (RIGHT . (SLASH . (RIGHT . (SLASH . (RIGHT . 3))))))) .
  ((3 . (1 . (0 . (1 . (0 . (1 . (0 . 4))))))) .
  ((4 . (SLASH . (LEFT . (SLASH . (LEFT . (SLASH . (LEFT . 5))))))) .
  ((5 . (BLANK . (BLANK . (BLANK . (BLANK . (BLANK . (BLANK . 6))))))) .
   nil)))))

// Tape for full specialization
S_right_t1 = '(1 . nil)
S_right_t2 = '(1 . nil)
S_right_t3 = '(1 . nil)
