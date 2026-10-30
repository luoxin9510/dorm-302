# 302

A horror adventure written in ink and played with the Inkwright Obsidian plugin's game mode. This folder is both the git repo and an Obsidian vault.

## Layout
- `game.md` — the game config (Inkwright `GameConfig` in the frontmatter). After editing it, regenerate `_engine.ink` (command "Generate game engine ink" or `api.generateEngine()`); `_engine.ink` is generated and committed.
- `main.ink` — the main story; chapters are INCLUDEd from it.
- `docs/设计.md` — design decisions, cast, writing rules, open questions. Design docs are in Chinese; commits, PRs and this file are in English.

## Play and check
- Obsidian: open this folder as a vault with Inkwright installed; the play panel shows the character picker, HUD, check odds and dice log. CLI: `obsidian vault=dorm-302 ...` (`command id=inkwright:open-play`, `eval code='app.plugins.plugins.inkwright.api.explore("main.ink").then(JSON.stringify)'`).
- Headless, from `~/Developer/inkwright`: `npm run check-ink -- "<this folder>" --all --lang zh` (and `--lang en`) plays every branch per character, walking both sides of every check; `npm run export-web -- "<this folder>/main.ink" out.html --lang zh` exports a playable page with the engine embedded.
- CI (`.github/workflows/check.yml`) runs the same `check-ink --all` in both languages.

## Rules
- Ids and ink identifiers are English (`#check:insight:normal`, `#voice:reason`); player-facing text is bilingual inline: `{t("中文", "English")}`.
- Everyone except the author (昕) appears under a pseudonym (烟波, 志勇, 怡); real names never enter this repo.
- Story text is the author's creative work: draft with them, don't invent chapters on your own.
- A failed check must change something (a variable or the available choices); `check-ink --all` warns otherwise.

## Git inside iCloud
The git dir is `.git.nosync` (iCloud does not sync `.nosync` items); `.git` is a file pointing to it. Keep it that way: never recreate a plain `.git` directory here.
