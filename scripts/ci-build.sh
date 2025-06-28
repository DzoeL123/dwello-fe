#!/bin/bash

echo "🏗️ Running build check with fallback..."

# Run affected build if base exists, else run all
if git rev-parse --verify main >/dev/null 2>&1; then
  npx nx affected -t build --base=all --head=HEAD
else
  npx nx run-many -t build --all
fi

if [ $? -ne 0 ]; then
  echo "❌ Build failed. Aborting push."
  exit 1
fi

echo "✅ Build passed!"
