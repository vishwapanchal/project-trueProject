#!/bin/bash

echo "🔍 Scanning codebase for incorrect ClickSpark imports..."

# Find all .js and .jsx files and replace 'components/ClickSpark' with 'components/clickspark'
grep -rRl "components/ClickSpark" . --include=*.{js,jsx,ts,tsx} | xargs sed -i "s|components/ClickSpark|components/clickspark|g"

echo "✅ Replacement complete."

# Stage, Commit, and Push
echo "📦 Staging changes..."
git add .
git commit -m "Fix all ClickSpark import paths case sensitivity"
git push origin main

echo "🚀 Pushed to GitHub!"