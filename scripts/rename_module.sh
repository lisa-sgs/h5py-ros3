#!/bin/sh
# Rename the importable module h5py -> h5py_s3 in an extracted h5py sdist.
# Usage: scripts/rename_module.sh <h5py-sdist-directory>
set -eu
cd "$1"
OLD=h5py
NEW=h5py_s3

# 1. Package directory
mv "$OLD" "$NEW"

# 2. Build files: package/extension names and paths ('h5py', "h5py.tests", 'h5py.' + module...)
sed -i -E "s/(['\"])${OLD}(['\"./])/\1${NEW}\2/g" \
    setup.py setup_build.py api_gen.py pyproject.toml

# 3. Absolute imports in the code and tests
find "$NEW" -type f \( -name '*.py' -o -name '*.pyx' -o -name '*.pxd' -o -name '*.pxi' \) \
  -exec sed -i -E \
    -e "s/^([[:space:]]*)import ${OLD}(\.[A-Za-z0-9_.]+)? as /\1import ${NEW}\2 as /" \
    -e "s/^([[:space:]]*)import ${OLD}(\.[A-Za-z0-9_.]+)?[[:space:]]*$/\1import ${NEW} as ${OLD}/" \
    -e "s/^([[:space:]]*)from ${OLD}([. ])/\1from ${NEW}\2/" \
    {} +

# 4. Safety check: no absolute import of the old name must remain
if grep -rnE "^[[:space:]]*(import|from) ${OLD}([. ]|$)" "$NEW" | grep -v "import ${NEW} as ${OLD}"; then
  echo "ERROR: remaining '${OLD}' imports" >&2
  exit 1
fi
echo "OK: module renamed to ${NEW}"