#!/bin/sh

# $1 - The slug of the exercise (e.g. two-fer).
# $2 - A path to an input directory containing the submitted solution file(s) and the necessary test file(s) (with a trailing slash).
# $3 - A path to an output directory (with a trailing slash).

cwd=$(pwd)
test_file=$(echo "$1" | sed 's/-/_/')_test.c
cd "$2" || exit
awk -F'[()]' '/RUN_TEST/ {print $2}' "${test_file}" > "$3"test_names.txt
sed -i 's#TEST_IGNORE();#// &#' "${test_file}"
make clean
stdbuf -oL make > "$3"results.txt 2>&1
cd "${cwd}" || exit
python3 process_results.py "$3"test_names.txt "$3"results.txt
