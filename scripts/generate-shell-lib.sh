#!/bin/bash

# Usage: ./generate-shell-lib.sh explore [--dry-run]

# --------------------------------------
# 🔧 Setup
# --------------------------------------

RAW_JOURNEY_NAME=$1
DRY_RUN=$2

if [ -z "$RAW_JOURNEY_NAME" ]; then
  echo "❌ Please provide a journey name (e.g., explore)"
  exit 1
fi

# Ensure this is run from Nx workspace root
if [ ! -f "nx.json" ] || [ ! -f "package.json" ]; then
  echo "❌ This script must be run from the root of an Nx workspace."
  exit 1
fi

# Lowercase journey name
JOURNEY_NAME=$(echo "$RAW_JOURNEY_NAME" | tr '[:upper:]' '[:lower:]')

# Paths & names
DEST_BASE="libs/${JOURNEY_NAME}"
DEST_FOLDER="${DEST_BASE}/shell"
SRC_LIB_PATH="${DEST_FOLDER}/src/lib"
MODULE_NAME="${JOURNEY_NAME}-shell"
CLASS_NAME="$(tr '[:lower:]' '[:upper:]' <<< ${JOURNEY_NAME:0:1})${JOURNEY_NAME:1}ShellModule"
PARENT_ROUTE_PATH="libs/${JOURNEY_NAME}/routes/src/lib/${JOURNEY_NAME}.routes.ts"

# --------------------------------------
# 🧪 Dry-run Mode
# --------------------------------------

if [ "$DRY_RUN" == "--dry-run" ]; then
  echo "🔍 DRY RUN MODE — No files will be created."
  echo "📦 Would generate shell lib at: $DEST_FOLDER"
  echo "📄 Would create module: $CLASS_NAME"
  echo "🔗 Would try inserting route in: $PARENT_ROUTE_PATH (if exists)"
  exit 0
fi

# --------------------------------------
# 📁 Setup Destination
# --------------------------------------

if [ ! -d "$DEST_BASE" ]; then
  echo "📁 Folder '$DEST_BASE' not found. Creating it..."
  mkdir -p "$DEST_BASE"
fi

# --------------------------------------
# 🛠️ Generate & Clean
# --------------------------------------

echo "🛠️ Generating shell library for: $JOURNEY_NAME"

nx g @nx/angular:library \
  --name=shell-temp \
  --style=scss \
  --routing \
  --lazy \
  --directory=${DEST_FOLDER} \
  --no-interactive

# Clean unwanted files
rm -rf "$SRC_LIB_PATH/shell-temp"
rm -f "$SRC_LIB_PATH/"*.component.*
rm -f "$SRC_LIB_PATH/"*.scss
rm -f "$SRC_LIB_PATH/"*.spec.ts
rm -f "$SRC_LIB_PATH/"*.ts

# --------------------------------------
# 🧱 Create Shell Module
# --------------------------------------

cat <<EOF > "$SRC_LIB_PATH/${MODULE_NAME}.module.ts"
import { NgModule } from '@angular/core';
import { RouterModule } from '@angular/router';
import { routes } from './lib.routes';

@NgModule({
  imports: [RouterModule.forChild(routes)],
})
export class ${CLASS_NAME} {}
EOF

cat <<EOF > "$SRC_LIB_PATH/lib.routes.ts"
import { Routes } from '@angular/router';

export const routes: Routes = [
  {
    path: '',
    // component: AddYourComponentHere
  },
];
EOF

# --------------------------------------
# 🔗 Insert into parent journey routes (if exists)
# --------------------------------------

if [ -f "$PARENT_ROUTE_PATH" ]; then
  INSERT_LINE="  {
    path: 'shell',
    loadChildren: () =>
      import('@${JOURNEY_NAME}/shell').then((m) => m.${CLASS_NAME}),
  },"

  echo "➕ Inserting shell route into: $PARENT_ROUTE_PATH"

  # Insert above export (non-destructively)
  sed -i '' "/export const routes/i\\
$INSERT_LINE\\
" "$PARENT_ROUTE_PATH"
fi

# --------------------------------------
# 🧹 Update index.ts file with journey module export
# --------------------------------------

echo "export * from './lib/${MODULE_NAME}.module';" > "${DEST_FOLDER}/src/index.ts"


# --------------------------------------
# 🧹 Fix path alias in tsconfig.base.json
# --------------------------------------

echo "🔁 Updating path alias in tsconfig.base.json..."

ALIAS="@dwello-fe/${JOURNEY_NAME}/shell"
RELATIVE_PATH="libs/${JOURNEY_NAME}/shell/src/index.ts"

# Remove old shell-temp mapping if exists
sed -i '' "/@dwello-fe\/shell-temp/d" tsconfig.base.json

# Insert new alias
if ! grep -q "\"$ALIAS\"" tsconfig.base.json; then
  sed -i '' "/\"paths\": {/a\\
    \"$ALIAS\": [\"$RELATIVE_PATH\"],
  " tsconfig.base.json
  echo "✅ Alias added: $ALIAS → $RELATIVE_PATH"
else
  echo "ℹ️  Alias already exists: $ALIAS"
fi



# --------------------------------------
# ✅ Output Summary
# --------------------------------------

echo "--------------------------------------------"
echo "✅ Shell library created at: $DEST_FOLDER"
echo "📄 Module: ${MODULE_NAME}.module.ts"
echo "📂 Clean structure with only module + routes"
echo "📥 Import it with:"
echo "   import { ${CLASS_NAME} } from '@${JOURNEY_NAME}/shell';"
echo "📦 Path: @${JOURNEY_NAME}/shell"
echo "--------------------------------------------"
