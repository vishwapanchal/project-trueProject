#!/bin/bash

echo "Ì∫Ä Starting automatic fix..."

# 1. Fix the Root Copy (This is likely the one Vercel is building)
if [ -f "src/pages/Home.jsx" ]; then
    echo "Ì¥ß Fixing root src/pages/Home.jsx..."
    # Replace ClickSpark with clickspark (case-sensitive)
    sed -i "s|from '/src/components/ClickSpark'|from '/src/components/clickspark'|g" src/pages/Home.jsx
else
    echo "‚ö†Ô∏è  Root Home.jsx not found! Checking next location..."
fi

# 2. Fix the Nested Copy (Just in case you switch roots later)
if [ -f "frontend_folder/EL_Frontend/src/pages/Home.jsx" ]; then
    echo "Ì¥ß Fixing nested frontend_folder/.../Home.jsx..."
    sed -i "s|from '/src/components/ClickSpark'|from '/src/components/clickspark'|g" frontend_folder/EL_Frontend/src/pages/Home.jsx
fi

# 3. Git Operations
echo "Ì≥¶ Staging changes..."
git add .

echo "Ì≤æ Committing changes..."
git commit -m "Fix case sensitivity import error for ClickSpark"

echo "Ì∫Ä Pushing to origin master..."
git push origin master

echo "‚úÖ Done! Go check your Vercel Dashboard."
