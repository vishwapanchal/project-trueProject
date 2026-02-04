#!/usr/bin/env bash

set -e

PROJECT_ROOT="$(pwd)"
SRC_DIR="$PROJECT_ROOT/src"
COMPONENTS_DIR="$SRC_DIR/components"

echo "🔍 Checking component imports for case-sensitivity issues..."
echo "------------------------------------------------------------"

# Find all JS/TS files
FILES=$(find "$SRC_DIR" -type f \( -name "*.js" -o -name "*.jsx" -o -name "*.ts" -o -name "*.tsx" \))

ERRORS=0

for file in $FILES; do
  grep -E "from ['\"](.*/components/[^'\"]+)['\"]" "$file" | while read -r line; do
    IMPORT_PATH=$(echo "$line" | sed -E "s/.*from ['\"](.*)['\"].*/\1/")
    REL_PATH="${IMPORT_PATH#/}"

    FULL_PATH="$PROJECT_ROOT/$REL_PATH"

    # If file exists exactly → OK
    if [ -f "$FULL_PATH.js" ] || [ -f "$FULL_PATH.jsx" ] || \
       [ -f "$FULL_PATH.ts" ] || [ -f "$FULL_PATH.tsx" ]; then
      continue
    fi

    # Try to fix casing
    DIRNAME=$(dirname "$FULL_PATH")
    BASENAME=$(basename "$FULL_PATH")

    if [ -d "$DIRNAME" ]; then
      MATCH=$(ls "$DIRNAME" | grep -i "^$BASENAME\.\(js\|jsx\|ts\|tsx\)$" | head -n 1)
      if [ -n "$MATCH" ]; then
        EXT="${MATCH##*.}"
        echo "⚠️  Case mismatch fixed in $file → $MATCH"

        sed -i "s|$IMPORT_PATH|${IMPORT_PATH%/*}/$(basename "$MATCH" .$EXT)|" "$file"
        ERRORS=$((ERRORS + 1))
      else
        echo "❌ Missing component: $IMPORT_PATH (referenced in $file)"
        ERRORS=$((ERRORS + 1))
      fi
    fi
  done
done

echo "------------------------------------------------------------"
if [ "$ERRORS" -eq 0 ]; then
  echo "✅ No import issues found."
else
  echo "⚠️  Completed with $ERRORS issue(s). Review changes."
fi
