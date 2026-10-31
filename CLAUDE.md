# 302

A horror adventure written in ink and played with the Inkwright Obsidian plugin's game mode. This folder is both the git repo and an Obsidian vault.

## Layout
- `game.md` — the game config (Inkwright `GameConfig` in the frontmatter). After editing it, regenerate `_engine.ink` (command "Generate game engine ink" or `api.generateEngine()`); `_engine.ink` is generated and committed.
- `main.ink` — the main story; chapters are INCLUDEd from it.
- `docs/设计.md` — design decisions, cast, writing rules, open questions. Design docs are in Chinese; commits, PRs and this file are in English.

## Play and check
- Obsidian: open this folder as a vault with Inkwright installed; the play panel shows the character picker, HUD, check odds and dice log. CLI: `obsidian vault=dorm-302 ...` (`command id=inkwright:open-play`, `eval code='app.plugins.plugins.inkwright.api.explore("main.ink").then(JSON.stringify)'`).
- Headless, from `~/Developer/inkwright`: `npm run check-ink -- "<this folder>" --all --novelty --max-steps 100000 --random 300 --lang zh` (and `--lang en`) plays every branch per character, walking both sides of every check (`--novelty` keeps the walk finite over the whole night; it also reports places and choices never reached, resources out of range, and the odds of each ending over 300 random runs); `npm run export-web -- "<this folder>/main.ink" out.html --lang zh` exports a playable page with the engine embedded. `--novelty 2 --max-steps 200000` (about 13 minutes per language) also reaches the branches two things must agree on, such as writing Yi's name back into the register; run it locally now and then, not in CI.
- CI (`.github/workflows/check.yml`) runs the same `check-ink --all` in both languages.

## Rules
- Ids and ink identifiers are English (`#check:insight:normal`, `#voice:reason`); player-facing text is bilingual inline: `{t("中文", "English")}`.
- Everyone except the author (昕) appears under a pseudonym (烟波, 志勇, 怡); real names never enter this repo.
- Story text is the author's creative work: draft with them, don't invent chapters on your own.
- A failed check must change something (a variable or the available choices); `check-ink --all` warns otherwise.

## Two working copies
- `~/Developer/dorm-302` — the development copy (plain git clone). Edit, run the headless checks and push from here.
- `~/Library/Mobile Documents/iCloud~md~obsidian/Documents/dorm-302` — the play copy: the same repo inside iCloud, opened as an Obsidian vault on the phone and the Mac. Its git dir is `.git.nosync` (iCloud does not sync `.nosync` items) and `.git` is a file pointing to it; never recreate a plain `.git` directory there. Bring it up to date with `git pull`; edits made there (e.g. on the phone) are committed and pushed from there.
- Obsidian CLI (`obsidian vault=dorm-302 ...`) works only once the vault is open in Obsidian on the Mac; never open it from a script with `obsidian://open` (that froze the CLI once). Without it, verify with the headless commands above.
