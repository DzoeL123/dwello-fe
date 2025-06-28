#!/bin/bash

# Usage: ./generate-feature-lib.sh explore

# --------------------------------------
# 🔧 Setup
# --------------------------------------

JOURNEY_NAME=$1
if [ -z "$JOURNEY_NAME" ]; then
  echo "❌ Please provide a journey name"
  exit 1
fi


# --------------------------------------
# 🧹 Paths & names
# --------------------------------------

LOWER_NAME=$(echo "$JOURNEY_NAME" | tr '[:upper:]' '[:lower:]')
LIB_PATH="libs/${LOWER_NAME}/ui"
CLASS_NAME="$(tr '[:lower:]' '[:upper:]' <<< ${LOWER_NAME:0:1})${LOWER_NAME:1}"
MODULE_CLASS="${CLASS_NAME}UiModule"


echo "🎨 Generating UI library at $LIB_PATH"


nx g @nx/angular:library \
  --name=ui \
  --style=scss \
  --directory=${LIB_PATH} \
  --no-interactive

rm -rf ${LIB_PATH}/src/lib/*

cat <<EOF > ${LIB_PATH}/src/lib/${LOWER_NAME}-ui.module.ts
import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

@NgModule({
  declarations: [],
  imports: [CommonModule],
  exports: []
})
export class ${MODULE_CLASS} {}
EOF

cat <<EOF > ${LIB_PATH}/src/index.ts
export * from './lib/${LOWER_NAME}-ui.module';
EOF


# --------------------------------------
# 🧹 Update index.ts file with ui module export
# --------------------------------------

echo "export * from './lib/${LOWER_NAME}-ui.module';" > "${LIB_PATH}/src/index.ts"


# --------------------------------------
# 🧹 Fix path alias in tsconfig.base.json
# --------------------------------------

echo "🔁 Updating path alias in tsconfig.base.json..."

ALIAS="@dwello-fe/${LOWER_NAME}/ui"
RELATIVE_PATH="libs/${LOWER_NAME}/ui/src/index.ts"

# Remove old ui mapping if exists
sed -i '' "/@dwello-fe\/ui/d" tsconfig.base.json

# Insert new alias
if ! grep -q "\"$ALIAS\"" tsconfig.base.json; then
  sed -i '' "/\"paths\": {/a\\
    \"$ALIAS\": [\"$RELATIVE_PATH\"],
  " tsconfig.base.json
  echo "✅ Alias added: $ALIAS → $RELATIVE_PATH"
else
  echo "ℹ️  Alias already exists: $ALIAS"
fi


echo "✅  Ui library created at: $LIB_PATH"
