#!/bin/bash
# Run all steps for the original normalizer experiment
set -e

cd "$(dirname "$0")"

# 1. Run BinInc and BinDec (if needed)
stack run -- interpret RTMinv.rl orig-normalizer/BinInc.spec
stack run -- interpret RTM.rl orig-normalizer/BinDec.spec
# (Assume BinInc.out and BinDec.out already exist)

# 2. Specialize BinInc and BinDec
stack run -- spec RTMinv.rl orig-normalizer/BinInc.out orig-normalizer/BinInc_comment.spec
stack run -- spec RTM.rl orig-normalizer/BinDec.out orig-normalizer/BinDec_comment.spec

# 3. Normalize with original normalizer
stack run -- normalize orig-normalizer/BinInc.out orig-normalizer/BinInc_orig.norm
stack run -- normalize orig-normalizer/BinDec.out orig-normalizer/BinDec_orig.norm

echo "Diff (should show 3 cosmetic differences):"
diff orig-normalizer/BinInc_orig.norm orig-normalizer/BinDec_orig.norm || true

