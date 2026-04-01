#!/usr/bin/env bash
# Probe each name in tests_to_skip (see meta.yaml) one at a time.
# Usage: from the extracted source tree, with the conda test env activated:
#   cd python
#   bash ../recipe/probe_skipped_tests.sh
#
# Adjust IGN and MARK to match meta.yaml for your Python version (see comments below).

set -euo pipefail

IGN="--ignore python/tests/test_table_provider.py --ignore python/tests/test_migration.py"
# Python 3.14+: add --ignore python/tests/torch_tests (torch.compile not supported).
IGN="${IGN} --ignore python/tests/torch_tests"

# Match meta.yaml markers_to_skip for your build.
MARK='not (cuda or slow or gpu or torch)'

TESTS=(
  test_all_permutations
  test_backward_compatibility_changed_index_protos
  test_fts_backward_v0_27_0
  test_torch_index_with_nans
  test_index_with_no_centroid_movement
  test_index_cast_centroids
  test_create_index_unsupported_accelerator
  test_ground_truth
  test_cosine_distance
  test_pairwise_cosine
  test_l2_distance
  test_l2_distance_f16_bf16_cpu
  test_lance_log_file_invalid_path
)

for name in "${TESTS[@]}"; do
  echo "========== ${name} =========="
  timeout 600 pytest -q --tb=short -p no:warnings ${IGN} -m "${MARK}" python/tests -k "${name}" || true
  echo
done
