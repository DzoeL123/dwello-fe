#!/bin/bash

echo "🔍 Running local CI tasks using Nx Affected..."

echo "🔎 Linting..."
npm run ci:lint
if [ $? -ne 0 ]; then
  echo "❌ Linting failed. Aborting push."
  exit 1
fi

echo "🧪 Testing..."
npm run ci:test
if [ $? -ne 0 ]; then
  echo "❌ Tests failed. Aborting push."
  exit 1
fi

echo "🏗️ Building..."
npm run ci:build
if [ $? -ne 0 ]; then
  exit 1
fi

echo "✅ All CI checks passed successfully! 🚀"
exit 0
