
### 📘 `README.md` — Journey Library Generator Tool

```markdown
# 🧰 Journey Library Generator CLI

This tool helps you scaffold Angular library modules (`shell`, `feature`, `ui`, `state`) for a specific journey in an Nx monorepo.

It automates:
- Clean Nx library generation per type
- Folder structure enforcement
- Routing module setup for `shell`
- Wrapper component for `feature`
- Shared module scaffolding for `ui` and `state`
- Automatic path alias updates in `tsconfig.base.json`

---

## 📦 Folder Structure

```

libs/
└── explore/
├── shell/
│   └── src/lib/
│       ├── explore-shell.module.ts
│       └── lib.routes.ts
├── feature/
│   └── src/lib/
│       ├── explore-feature.module.ts
│       ├── explore-feature-wrapper.component.ts
│       └── components/
├── ui/
│   └── src/lib/explore-ui.module.ts
└── state/
└── src/lib/explore-state.module.ts

````

---

## 🚀 Usage

From your Nx root, run:

```bash
./generate-journey-libs.sh <journey-name> [options]
````

Example:

```bash
./generate-journey-libs.sh explore
```

---

## 🧩 Flags

### ✅ Generator options

| Flag             | Description                           |
| ---------------- | ------------------------------------- |
| `--skip-shell`   | Skip generating the `shell` library   |
| `--skip-feature` | Skip generating the `feature` library |
| `--skip-ui`      | Skip generating the `ui` library      |
| `--skip-state`   | Skip generating the `state` library   |

### 🎯 Focused generation

| Flag             | Description                         |
| ---------------- | ----------------------------------- |
| `--only-shell`   | Generate only the `shell` library   |
| `--only-feature` | Generate only the `feature` library |
| `--only-ui`      | Generate only the `ui` library      |
| `--only-state`   | Generate only the `state` library   |

> 📝 If any `--only-*` flag is used, all other libraries will be skipped automatically.

### 🔍 Dry Run

| Flag        | Description                                    |
| ----------- | ---------------------------------------------- |
| `--dry-run` | Simulate the output without creating any files |

---

## 🧪 Example Commands

```bash
# Create all 4 libraries under `explore`
./generate-journey-libs.sh explore

# Only generate UI library for `explore`
./generate-journey-libs.sh explore --only-ui

# Generate everything but skip state
./generate-journey-libs.sh explore --skip-state

# Simulate without writing anything
./generate-journey-libs.sh explore --dry-run
```

---

## 🔗 Aliases

Each generated library automatically gets a path alias like:

```ts
'@dwello-fe/explore/shell'
'@dwello-fe/explore/feature'
'@dwello-fe/explore/ui'
'@dwello-fe/explore/state'
```

---

## 📁 Requirements

* Nx Workspace
* Angular CLI support
* These scripts placed in your Nx root

---

## 👨‍🔧 Scripts Used

| Script                     | Description                 |
| -------------------------- | --------------------------- |
| `generate-shell-lib.sh`    | Creates `shell` library     |
| `generate-feature-lib.sh`  | Creates `feature` library   |
| `generate-ui-lib.sh`       | Creates `ui` library        |
| `generate-state-lib.sh`    | Creates `state` library     |
| `generate-journey-libs.sh` | Master script combining all |

---

## 🤝 Contributions

Feel free to improve or extend support to other frontend frameworks (React/Vue microfrontends) or add testing module templates.

---

## 🧠 Pro Tips

* Use `--dry-run` in CI pipelines to validate output.
* Version-control your script changes!
* Document new journeys in your internal onboarding doc.

---

© 2025 — **Dwello Angular Team**
