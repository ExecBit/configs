# pi — pi coding agent config

Snapshot of the global pi agent config from `~/.pi/agent` (Windows: `C:\Users\agdei\.pi\agent`).
One-way copy: edit here, deploy back with the steps below. The live directory is not modified by this repo.

## Layout

```
pi/
├── settings.json                              → ~/.pi/agent/settings.json
├── npm/
│   ├── package.json                           → ~/.pi/agent/npm/package.json
│   └── package-lock.json                      → ~/.pi/agent/npm/package-lock.json
└── extensions/
    ├── llama-local/index.ts                   → ~/.pi/agent/extensions/llama-local/index.ts
    └── pi-telegram-notify/
        └── config.example.json                → ~/.pi/agent/extensions/pi-telegram-notify/config.json
```

- `settings.json` — theme, installed npm packages, default provider/model.
- `npm/` — version pins for the pi extensions listed in `settings.json`.
- `extensions/llama-local/` — custom provider pointing at a local llama.cpp server (`127.0.0.1:7080`).
- `extensions/pi-telegram-notify/` — only a template; the real `config.json` contains the bot token and is gitignored.

## Excluded (machine-specific / runtime)

Not part of the snapshot; they live only in `~/.pi/agent`:

| File | Why excluded |
|---|---|
| `extensions/pi-telegram-notify/config.json` | contains the live Telegram bot token |
| `trust.json` | per-machine trusted workspaces |
| `auth.json`, `models-store.json` | auth/model state |
| `mcp-cache.json`, `mcp-npx-cache.json`, `mcp-onboarding.json` | MCP caches / onboarding state |
| `plans/`, `sessions/` | session data |
| `npm/node_modules/` | installed packages, managed by pi |

## Deploy into ~/.pi/agent

From the repo root (`<repo>` = `C:/Users/agdei/projects/configs`), `~` = `C:\Users\agdei\.pi\agent`:

```powershell
# 1. Core config
Copy-Item <repo>\pi\settings.json ~\agent\settings.json

# 2. Extension version pins
Copy-Item <repo>\pi\npm\package.json, <repo>\pi\npm\package-lock.json ~\agent\npm\

# 3. Local extensions
Copy-Item -Recurse -Force <repo>\pi\extensions\llama-local ~\agent\extensions\

# 4. Telegram notify config — create once from the template with your token
#    (do NOT overwrite an existing config.json)
if (-not (Test-Path ~\agent\extensions\pi-telegram-notify\config.json)) {
    New-Item -ItemType Directory -Force ~\agent\extensions\pi-telegram-notify | Out-Null
    (Get-Content <repo>\pi\extensions\pi-telegram-notify\config.example.json -Raw) `
        -replace '<YOUR_BOT_TOKEN>', 'YOUR_BOT_TOKEN_HERE' `
        -replace '<YOUR_CHAT_ID>', 'YOUR_CHAT_ID_HERE' `
        | Set-Content ~\agent\extensions\pi-telegram-notify\config.json
}

# 5. Optional: (re)install extension packages
Push-Location ~\agent\npm; npm install; Pop-Location
```

Then restart pi (or start a new session) to pick up changes.

## Keeping in sync

After changing anything in `~/.pi/agent` that belongs in this repo, copy it back over the
files listed in the Layout table (never `config.json`, runtime caches, or session data).
