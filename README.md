# 🏠 Dwello Frontend (dwello-fe)

---

✨ Modular, Scalable Angular Frontend with Journey-Driven Architecture – Powered by Nx

dwello-fe is a modular, client-themable, full-featured frontend application, designed to serve **multi-tenant real estate and property management platforms**. 

It follows a journey-based modular architecture, integrates theming, feature toggles, state management, and automated CLI tooling to scaffold consistent and maintainable libraries for each journey.

---

## 🎯 Overview

**dwello-fe** is a full-featured frontend application developed using [Angular](https://angular.io/) and [Nx](https://nx.dev/), designed for scalable enterprise-grade applications, structured using **journey-based modular design**. Each journey represents a business domain or vertical slice (e.g., `explore`, `manage-tenants`), and encapsulates its own:

- 🔷 Shell (routing + layout)
- 🧩 Feature (feature modules + wrapper components)
- 🎨 UI (reusable presentational components)
- 📦 State (NgRx/store or other state logic)

## 📦 Features

- ✅ Nx monorepo structure
- 🌐 Lazy-loaded Angular libraries per journey
- 🎨 Dynamic theming support
- 🚀 Shell scripts to scaffold journey libraries consistently
- 💡 Fully typed theming and config system
- 🌙 Light/Dark mode support
- 🧪 Built-in **Jest** + **Playwright** testing support
- 🧰 CI/CD ready
- 🔌 Extendable for **React**, **Vue**, etc., in the future
- 📦 Clean imports via `@dwello-fe/<journey>/<lib>`

---

## 📂 Directory Structure

```

dwello-fe/
├── apps/
│   └── dwello-frontend/       # Angular App
├── libs/
│   └── explore/               # Example journey
│       ├── shell/
│       ├── feature/
│       ├── ui/
│       └── state/
├── scripts/                   # CLI scaffolding tools
│   ├── generate-shell-lib.sh
│   ├── generate-feature-lib.sh
│   ├── generate-ui-lib.sh
│   ├── generate-state-lib.sh
│   ├── generate-journey-libs.sh
│   └── README.md              # Script usage guide
├── tsconfig.base.json
├── nx.json
├── angular.json
├── package.json
└── README.md                  # You're here

````

---

## 🚀 Getting Started

### 🧱 Prerequisites

- [Node.js](https://nodejs.org/) ≥ 18.x
- Nx CLI: `npm install -g nx`

### 🔧 Install dependencies

```bash
npm install
```


### 🔧 Install dependencies

```bash
npm install
```

### ▶️ Serve the frontend

```bash
nx serve dwello-frontend
```

---

## 🧰 Using the CLI Scripts

All generation scripts live in `/scripts`. Make them executable first:

```bash
chmod +x scripts/*.sh
```

Then run them via `npm run` or directly:

### 🧱 Generate All Journey Libraries

```bash
npm run generate:all -- explore
```

Will create:

```
libs/explore/
├── shell/
├── feature/
├── ui/
└── state/
```

### 📦 Generate Individual Libraries

```bash
npm run generate:shell -- explore
npm run generate:feature -- explore
npm run generate:ui -- explore
npm run generate:state -- explore
```

#### Optional Flags:

* `--dry-run`: Simulates the command without changing files
* `--skip-state`: Skips state generation
* `--only-ui`: Creates only the UI library

---

## 🔗 Path Aliases

Libraries are auto-linked in `tsconfig.base.json` for clean imports:

```ts
import { ExploreShellModule } from '@dwello-fe/explore/shell';
import { ExploreFeatureWrapperComponent } from '@dwello-fe/explore/feature';
import { ExploreUiModule } from '@dwello-fe/explore/ui';
import { ExploreStateModule } from '@dwello-fe/explore/state';
```

---

## ⚙️ Running Scripts from Root (via `package.json`)

To make script usage easier, add to your `package.json`:

```json
"scripts": {
  "generate:shell": "bash scripts/generate-shell-lib.sh",
  "generate:feature": "bash scripts/generate-feature-lib.sh",
  "generate:ui": "bash scripts/generate-ui-lib.sh",
  "generate:state": "bash scripts/generate-state-lib.sh",
  "generate:all": "bash scripts/generate-journey-libs.sh"
}
```

Now run them like:

```bash
npm run generate:all -- manage-tenants
```

---

## 🧩 Architecture Philosophy

Each journey is treated as an encapsulated domain:

* `shell/`: entrypoint with routing
* `feature/`: smart components & containers
* `ui/`: reusable UI blocks
* `state/`: domain state handling

You can scale with new journeys and plug them into the main app using lazy-loaded routing modules.

---

## 🔒 License

MIT © 2025 Joel P Thomas & Contributors

---

## 🙌 Contributing

Contributions are welcome! Fork, improve and open a PR.

```

---

Let me know if you want:
- A `CONTRIBUTING.md` or `CODEOWNERS` file
- Auto CI/CD GitHub workflows
- Version tagging or changelog support

We can make this production-ready.
```
