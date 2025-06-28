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
LIB_PATH="libs/${LOWER_NAME}/feature"
COMPONENT_NAME="${LOWER_NAME}-feature-wrapper"
CLASS_NAME="$(tr '[:lower:]' '[:upper:]' <<< ${LOWER_NAME:0:1})${LOWER_NAME:1}FeatureWrapperComponent"
MODULE_CLASS="${CLASS_NAME%WrapperComponent}Module"


echo "🛠️ Generating feature library at $LIB_PATH"


nx g @nx/angular:library \
  --name=feature \
  --style=scss \
  --directory=${LIB_PATH} \
  --no-interactive

rm -rf ${LIB_PATH}/src/lib/*
mkdir -p ${LIB_PATH}/src/lib/components

cat <<EOF > ${LIB_PATH}/src/lib/${COMPONENT_NAME}.component.ts
import { Component } from '@angular/core';
@Component({
  selector: 'app-${COMPONENT_NAME}',
  templateUrl: './${COMPONENT_NAME}.component.html',
})
export class ${CLASS_NAME} {}
EOF

echo "<p>${COMPONENT_NAME} works!</p>" > ${LIB_PATH}/src/lib/${COMPONENT_NAME}.component.html
echo "describe('${CLASS_NAME}', () => {});" > ${LIB_PATH}/src/lib/${COMPONENT_NAME}.component.spec.ts

cat <<EOF > ${LIB_PATH}/src/lib/${LOWER_NAME}-feature.module.ts
import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ${CLASS_NAME} } from './${COMPONENT_NAME}.component';

@NgModule({
  declarations: [${CLASS_NAME}],
  imports: [CommonModule],
  exports: [${CLASS_NAME}]
})
export class ${MODULE_CLASS} {}
EOF

cat <<EOF > ${LIB_PATH}/src/index.ts
export * from './lib/${LOWER_NAME}-feature.module';
export * from './lib/${COMPONENT_NAME}.component';
EOF


# --------------------------------------
# 🧹 Update index.ts file with journey module and wrapper component exports
# --------------------------------------

echo "export * from './lib/${LOWER_NAME}-feature.module';
export * from './lib/${LOWER_NAME}-feature-wrapper.component';" > "${LIB_PATH}/src/index.ts"


# --------------------------------------
# 🧹 Fix path alias in tsconfig.base.json
# --------------------------------------

echo "🔁 Updating path alias in tsconfig.base.json..."

ALIAS="@dwello-fe/${LOWER_NAME}/feature"
RELATIVE_PATH="libs/${LOWER_NAME}/feature/src/index.ts"

# Remove old feature mapping if exists
sed -i '' "/@dwello-fe\/feature/d" tsconfig.base.json

# Insert new alias
if ! grep -q "\"$ALIAS\"" tsconfig.base.json; then
  sed -i '' "/\"paths\": {/a\\
    \"$ALIAS\": [\"$RELATIVE_PATH\"],
  " tsconfig.base.json
  echo "✅ Alias added: $ALIAS → $RELATIVE_PATH"
else
  echo "ℹ️  Alias already exists: $ALIAS"
fi


echo "✅  Feature lib created at: $LIB_PATH"
