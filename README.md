# My Pico-8 Game — VS Code Build & Run

This project builds a Pico-8 cart from multiple Lua files using **VS Code** + **PowerShell** + **p8tool**.  
The build script lives in **`.vscode/`** and concatenates your Lua files in order, merges them into a copy of `assets/base.p8`, then launches Pico-8.

---

## 📁 Project Layout

```
MyPicoGame/
├─ assets/
│  └─ base.p8              # base cart with gfx/map/sfx/music
├─ src/
│  ├─ systems/
│  │  └─ player.lua
│  ├─ scenes/
│  │  └─ game.lua
│  └─ main.lua
├─ build/                  # generated output (created by the build)
├─ .vscode/
│  ├─ build-p8.ps1         # PowerShell build script (kept here)
│  └─ tasks.json           # VS Code task to run the script
└─ README.md
```

> **Note:** Keep `assets/base.p8` free of Lua code. It should only contain your sprites/map/SFX/music.

---

## ✅ Requirements (Windows)

- **Pico-8** installed at one of:
  - `C:\Program Files (x86)\PICO-8\pico8.exe`
  - `C:\Program Files\PICO-8\pico8.exe`
- **Python 3** and **picotool** (`p8tool`) in PATH:
  ```powershell
  pip install picotool
  ```
- **Visual Studio Code** (PowerShell extension recommended)

---

## ▶️ How to Run (in VS Code)

Press **Ctrl+Shift+B** and choose **“Build & Run Pico-8”**.

The task will:
- Concatenate your Lua files (`src\systems\player.lua`, `src\scenes\game.lua`, `src\main.lua`) in that order
- Write `_concat.lua` **without a UTF‑8 BOM**
- Build `build\mygame.p8` with `p8tool` (art/music/etc. from `assetsase.p8`)
- Launch Pico‑8 with the built cart

Prefer the terminal? Run:
```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\.vscode\build-p8.ps1
```

## 🔁 Expanding Later

- Add more Lua files and **append them to the `$files` array** in `.vscode/build-p8.ps1` to control order.
- Keep `main.lua` **last** so its `_init/_update/_draw` see earlier definitions.
- Keep `assets/base.p8` for sprites/map/SFX/music only.

---

## 🧯 Troubleshooting

- **Weird characters at top of code** → Ensure `_concat.lua` is written **without BOM** (this script already does that).
- **`p8tool.exe not found`** → `pip install picotool`, then restart VS Code (PATH refresh).
- **Pico-8 not launching** → Update `$pico` path in `.vscode/build-p8.ps1`.
- **A Lua file isn’t included** → Check the path in the `$files` array and that the file exists.
