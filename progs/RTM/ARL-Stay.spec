// Test with STAY
Start = '1
End = '4
Rules =
 '((1 . (BLANK . (BLANK . 2))) .
  ((2 . (SLASH . (STAY  . 3))) .
  ((3 . (BLANK . (BLANK . 4))) .
    nil)))

// Tape for full specialization
S_right = '(K . (p . (1 . (1 . (0 . (1 . (K . (p . (K . (p . (K . nil)))))))))))
