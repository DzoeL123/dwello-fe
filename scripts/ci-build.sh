#!/bin/bash

echo "🏗️ Running build check with fallback..."

# Load environment variables from .env if it exists
if [ -f .env ]; then
  export "$(cat .env | xargs)"
fi

# Determine if base branch exists and use correct affected command
if git rev-parse --verify development >/dev/null 2>&1; then
  echo "📍 Running affected build between development and HEAD..."
  npx nx affected -t build --base=development --head=HEAD
else
  echo "📍 'development' branch not found. Running full build with run-many..."
  npx nx run-many -t build --all
fi

# Check result
if [ $? -ne 0 ]; then
  echo "❌ Build failed. Aborting push."
  exit 1
fi

echo "✅ Build passed!"
