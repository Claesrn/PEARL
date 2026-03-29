#!/bin/bash
# Run all steps for the original normalizer experiment
set -e

cd "$(dirname "$0")"

#0 
stack run -- invert RTM.rl RTMinv.rl

# 1. Run BinInc and BinDec (if needed)
stack run -- interpret RTMinv.rl increment_all_tapes/BinInc.spec
stack run -- interpret RTM.rl increment_all_tapes/BinDec.spec

# 2. Specialize BinInc and BinDec
stack run -- spec RTMinv.rl increment_all_tapes/BinInc.out increment_all_tapes/BinInc_comment.spec
stack run -- spec RTM.rl increment_all_tapes/BinDec.out increment_all_tapes/BinDec_comment.spec

# 3. Normalize with original normalizer
stack run -- normalize increment_all_tapes/BinInc.out increment_all_tapes/BinInc.norm
stack run -- normalize increment_all_tapes/BinDec.out increment_all_tapes/BinDec.norm

echo "Diff below:"
diff increment_all_tapes/BinInc.norm increment_all_tapes/BinDec.norm || true

