#!/usr/bin/env bash
set -euo pipefail

BIN="./usr/bin/main_word"
test -x "$BIN"

pass=0
fail=0

run_test() {
  local name="$1"
  local input="$2"
  local expected="$3"

  local out
  out="$(printf "%s\n" "$input" | "$BIN" | tr -d '\r')"

  if echo "$out" | grep -qE "$expected"; then
    echo "[test] PASS: $name"
    pass=$((pass+1))
  else
    echo "[test] FAIL: $name"
    echo "  input:    [$input]"
    echo "  expected: /$expected/"
    echo "  got:"
    echo "$out"
    fail=$((fail+1))
  fi
}

run_test "empty string" "" "Number of words in string = 0"
run_test "one word" "hello" "Number of words in string = 1"
run_test "two words" "hello world" "Number of words in string = 2"
run_test "multiple spaces" "  hello   world  " "Number of words in string = 2"
run_test "tabs and spaces" $'hello\tworld test' "Number of words in string = 3"

echo "[test] passed: $pass, failed: $fail"
test "$fail" -eq 0

