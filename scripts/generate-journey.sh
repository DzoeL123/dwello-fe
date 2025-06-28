#!/bin/bash

# Usage:
# ./generate-journey-libs.sh explore [--skip-shell] [--only-feature] [--dry-run]

JOURNEY_NAME=$1
shift

if [ -z "$JOURNEY_NAME" ]; then
  echo "❌ Please provide a journey name"
  exit 1
fi

# Lowercase
JOURNEY_NAME=$(echo "$JOURNEY_NAME" | tr '[:upper:]' '[:lower:]')

# Flags
SKIP_SHELL=false
SKIP_FEATURE=false
SKIP_UI=false
SKIP_STATE=false
ONLY_SHELL=false
ONLY_FEATURE=false
ONLY_UI=false
ONLY_STATE=false
DRY_RUN=false

# Parse CLI args
for arg in "$@"; do
  case $arg in
    --skip-shell) SKIP_SHELL=true ;;
    --skip-feature) SKIP_FEATURE=true ;;
    --skip-ui) SKIP_UI=true ;;
    --skip-state) SKIP_STATE=true ;;
    --only-shell) ONLY_SHELL=true ;;
    --only-feature) ONLY_FEATURE=true ;;
    --only-ui) ONLY_UI=true ;;
    --only-state) ONLY_STATE=true ;;
    --dry-run) DRY_RUN=true ;;
    *) echo "⚠️ Unknown flag: $arg";;
  esac
done

# Priority handling for "only" flags
if $ONLY_SHELL; then
  SKIP_FEATURE=true
  SKIP_UI=true
  SKIP_STATE=true
  SKIP_SHELL=false
fi

if $ONLY_FEATURE; then
  SKIP_SHELL=true
  SKIP_UI=true
  SKIP_STATE=true
  SKIP_FEATURE=false
fi

if $ONLY_UI; then
  SKIP_SHELL=true
  SKIP_FEATURE=true
  SKIP_STATE=true
  SKIP_UI=false
fi

if $ONLY_STATE; then
  SKIP_SHELL=true
  SKIP_FEATURE=true
  SKIP_UI=true
  SKIP_STATE=false
fi

# Master generation
echo "🚀 Starting generation for journey: $JOURNEY_NAME"
echo "--------------------------------------------"

if ! $SKIP_SHELL; then
  echo "📦 Generating Shell"
  ./scripts/generate-shell-lib.sh $JOURNEY_NAME $([ "$DRY_RUN" == true ] && echo "--dry-run")
fi

if ! $SKIP_FEATURE; then
  echo "📦 Generating Feature"
  ./scripts/generate-feature-lib.sh $JOURNEY_NAME
fi

if ! $SKIP_UI; then
  echo "📦 Generating UI"
  ./scripts/generate-ui-lib.sh $JOURNEY_NAME
fi

if ! $SKIP_STATE; then
  echo "📦 Generating State"
  ./scripts/generate-state-lib.sh $JOURNEY_NAME
fi

echo "✅ Journey library generation complete for '$JOURNEY_NAME'"
