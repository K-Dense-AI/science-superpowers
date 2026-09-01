#!/bin/sh
# test-prereg.sh — regression tests for skills/preregistering-analysis/prereg.sh
#
# Builds throwaway git repositories and checks that `freeze` + `audit`
# behave as documented. Zero dependencies beyond git and a POSIX shell.
#
# Usage: scripts/test-prereg.sh [path/to/prereg.sh]
# Exit 0 when every case passes, 1 otherwise.

set -u

HERE=$(cd "$(dirname "$0")" && pwd)
PREREG=${1:-"$HERE/../skills/preregistering-analysis/prereg.sh"}
PREREG=$(cd "$(dirname "$PREREG")" && pwd)/$(basename "$PREREG")
[ -f "$PREREG" ] || { echo "no such script: $PREREG" >&2; exit 2; }

FAILED=0
report() {  # report <name> <ok:0|1> [detail]
    if [ "$2" -eq 0 ]; then echo "PASS  $1"; else echo "FAIL  $1${3:+ — $3}"; FAILED=1; fi
}

fresh_repo() {  # fresh_repo -> prints path of a new repo with one commit
    d=$(mktemp -d 2>/dev/null || mktemp -d -t prereg)
    d=$(cd "$d" && pwd -P)   # physical path: git reports the repo root resolved
    (
        cd "$d" || exit 1
        git init -q
        git config user.name "prereg test"
        git config user.email "prereg@example.invalid"
        git config commit.gpgsign false
        mkdir -p docs/science-superpowers/preregistrations data/raw
        printf 'id,x\n1,0.5\n2,0.7\n' > data/raw/data.csv
        printf '# baseline\n' > README.md
        git add -A && git commit -q -m "baseline"
    ) || exit 1
    echo "$d"
}

write_reg() {  # write_reg <repo> <with-placeholder:0|1>
    f="$1/docs/science-superpowers/preregistrations/2026-01-01-test.md"
    if [ "$2" -eq 1 ]; then
        printf '%s\n' "# Pre-registration: test" "" \
            "**Frozen at commit:** <stamped by prereg.sh freeze>" "" \
            "## Hypotheses" "" "- H1: x > 0" > "$f"
    else
        printf '%s\n' "# Pre-registration: test" "" \
            "## Hypotheses" "" "- H1: x > 0" > "$f"
    fi
    echo "$f"
}

# Case 1 — no placeholder: freeze inserts the stamp; audit must PASS.
R=$(fresh_repo); F=$(write_reg "$R" 0)
( cd "$R" && sh "$PREREG" freeze "$F" data/raw/data.csv >/dev/null 2>&1 )
OUT=$(cd "$R" && sh "$PREREG" audit 2>&1); RC=$?
case "$OUT" in *"PASS  INTEGRITY"*) ok=0 ;; *) ok=1 ;; esac
[ "$RC" -eq 0 ] || ok=1
report "audit passes after freeze without a stamp placeholder" $ok "$(printf '%s' "$OUT" | grep -E 'FAIL|RESULT' | head -3 | tr '\n' ' ')"
rm -rf "$R"

# Case 2 — with placeholder: audit must PASS.
R=$(fresh_repo); F=$(write_reg "$R" 1)
( cd "$R" && sh "$PREREG" freeze "$F" data/raw/data.csv >/dev/null 2>&1 )
OUT=$(cd "$R" && sh "$PREREG" audit 2>&1); RC=$?
case "$OUT" in *"PASS  INTEGRITY"*) ok=0 ;; *) ok=1 ;; esac
[ "$RC" -eq 0 ] || ok=1
report "audit passes after freeze with a stamp placeholder" $ok "$(printf '%s' "$OUT" | grep -E 'FAIL|RESULT' | head -3 | tr '\n' ' ')"
rm -rf "$R"

# Case 3 — a genuine post-freeze edit must FAIL INTEGRITY.
R=$(fresh_repo); F=$(write_reg "$R" 0)
( cd "$R" && sh "$PREREG" freeze "$F" >/dev/null 2>&1 )
printf -- '- H2: added after the freeze\n' >> "$F"
( cd "$R" && git add -A && git commit -q -m "edit registration" )
OUT=$(cd "$R" && sh "$PREREG" audit 2>&1); RC=$?
case "$OUT" in *"FAIL  INTEGRITY"*) ok=0 ;; *) ok=1 ;; esac
[ "$RC" -ne 0 ] || ok=1
report "audit fails INTEGRITY after a real post-freeze edit" $ok
rm -rf "$R"

# Case 4 — an output committed before the freeze must FAIL CHRONOLOGY.
R=$(fresh_repo)
( cd "$R" && mkdir -p results && echo "p=0.03" > results/primary.txt \
    && git add -A && git commit -q -m "early output" )
F=$(write_reg "$R" 1)
( cd "$R" && sh "$PREREG" freeze "$F" >/dev/null 2>&1 )
OUT=$(cd "$R" && sh "$PREREG" audit 2>&1); RC=$?
case "$OUT" in *"FAIL  CHRONOLOGY"*) ok=0 ;; *) ok=1 ;; esac
[ "$RC" -ne 0 ] || ok=1
report "audit fails CHRONOLOGY when an output predates the freeze" $ok
rm -rf "$R"

# Case 5 — raw data changed after the freeze must FAIL DATA.
R=$(fresh_repo); F=$(write_reg "$R" 1)
( cd "$R" && sh "$PREREG" freeze "$F" data/raw/data.csv >/dev/null 2>&1 )
printf '3,0.9\n' >> "$R/data/raw/data.csv"
OUT=$(cd "$R" && sh "$PREREG" audit 2>&1); RC=$?
case "$OUT" in *"FAIL  DATA"*) ok=0 ;; *) ok=1 ;; esac
[ "$RC" -ne 0 ] || ok=1
report "audit fails DATA when frozen raw data change" $ok
rm -rf "$R"

[ "$FAILED" -eq 0 ] && echo "all prereg.sh cases passed"
exit $FAILED
