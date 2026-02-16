#!/bin/bash
# Run all steps for the original normalizer experiment
set -e

cd "$(dirname "$0")"

# 1. Run BinInc and BinDec (if needed)
stack run -- interpret RTMinv.rl increment/BinInc.spec
stack run -- interpret RTM.rl increment/BinDec.spec
# (Assume BinInc.out and BinDec.out already exist)

# 2. Specialize BinInc and BinDec
stack run -- spec RTMinv.rl increment/BinInc.out increment/BinInc_comment.spec
stack run -- spec RTM.rl increment/BinDec.out increment/BinDec_comment.spec

# 3. Normalize with original normalizer
stack run -- normalize increment/BinInc.out increment/BinInc.norm
stack run -- normalize increment/BinDec.out increment/BinDec.norm

echo "Diff below:"
diff increment/BinInc.norm increment/BinDec.norm || true

