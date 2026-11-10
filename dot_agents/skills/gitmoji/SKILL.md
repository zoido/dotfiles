---
name: gitmoji
description: Use when picking the emoji for a commit message, a PR title, or a squash-merge title, or when checking that an emoji in a commit or PR title is right. Covers the full gitmoji list (https://gitmoji.dev) and the default gitmoji for each conventional commit type. Use it whenever you write a commit or PR title, even if the user does not mention emoji, because their commit format requires one.
---

# Gitmoji

Gitmoji gives each kind of change one emoji, so readers can scan a history and see what kind of change each commit is. The `pr-guidelines` skill defines where the emoji goes in the message. This skill defines which emoji to use.

## Rules

- Use exactly one gitmoji per commit or PR title.
- Pick the gitmoji that describes the change most precisely. Start from the default for the conventional commit type, then use a more specific one from the full list if it fits better. For example, a `fix` that only corrects typos uses ✏️ `:pencil2:`.
- Write the emoji character, not the `:code:`. `git log` and many other tools do not render codes.
- Copy the emoji from the tables below. Some emoji include an invisible variation selector (U+FE0F), and a retyped emoji can differ from the official one.
- If the change is breaking, use 💥 `:boom:` instead of the type default. It is the strongest signal for a reader.
- Do not use joke gitmoji (💩 `:poop:`, 🍻 `:beers:`) unless the user asks.

## Default per conventional commit type

The first gitmoji is the default. The others fit special cases of the same type.

| Type | Gitmoji | Use for |
|---|---|---|
| `feat` | ✨ `:sparkles:` | New feature |
| `fix` | 🐛 `:bug:`, 🚑️ `:ambulance:`, 🩹 `:adhesive_bandage:`, 🔒️ `:lock:` | Bug fix, critical hotfix, small fix, security fix |
| `docs` | 📝 `:memo:` | Documentation |
| `style` | 🎨 `:art:` | Formatting and code structure |
| `refactor` | ♻️ `:recycle:`, 🚚 `:truck:`, ⚰️ `:coffin:`, 🔥 `:fire:` | Refactor, move or rename, remove dead code, remove code or files |
| `perf` | ⚡️ `:zap:` | Performance |
| `test` | ✅ `:white_check_mark:`, 🧪 `:test_tube:` | Tests, a failing test |
| `build` | 📦️ `:package:`, ➕ `:heavy_plus_sign:`, ➖ `:heavy_minus_sign:`, ⬆️ `:arrow_up:`, ⬇️ `:arrow_down:`, 📌 `:pushpin:` | Build output and dependencies |
| `ci` | 👷 `:construction_worker:`, 💚 `:green_heart:` | CI configuration, fixing a broken CI build |
| `chore` | 🔧 `:wrench:`, 🔨 `:hammer:`, 🙈 `:see_no_evil:`, 🔖 `:bookmark:` | Configuration, dev scripts, .gitignore, releases |
| `revert` | ⏪️ `:rewind:` | Revert |

## Full list

Source: [carloscuesta/gitmoji](https://github.com/carloscuesta/gitmoji) `packages/gitmojis/src/gitmojis.json`, commit `f9bcbf79874890c46bcbe53c615d0bf213c2f595`.

| Emoji | Code | Use for |
|---|---|---|
| 🎨 | `:art:` | Improve structure / format of the code. |
| ⚡️ | `:zap:` | Improve performance. |
| 🔥 | `:fire:` | Remove code or files. |
| 🐛 | `:bug:` | Fix a bug. |
| 🚑️ | `:ambulance:` | Critical hotfix. |
| ✨ | `:sparkles:` | Introduce new features. |
| 📝 | `:memo:` | Add or update documentation. |
| 🚀 | `:rocket:` | Deploy stuff. |
| 💄 | `:lipstick:` | Add or update the UI and style files. |
| 🎉 | `:tada:` | Begin a project. |
| ✅ | `:white_check_mark:` | Add, update, or pass tests. |
| 🔒️ | `:lock:` | Fix security or privacy issues. |
| 🔐 | `:closed_lock_with_key:` | Add or update secrets. |
| 🔖 | `:bookmark:` | Release / Version tags. |
| 🚨 | `:rotating_light:` | Fix compiler / linter warnings. |
| 🚧 | `:construction:` | Work in progress. |
| 💚 | `:green_heart:` | Fix CI Build. |
| ⬇️ | `:arrow_down:` | Downgrade dependencies. |
| ⬆️ | `:arrow_up:` | Upgrade dependencies. |
| 📌 | `:pushpin:` | Pin dependencies to specific versions. |
| 👷 | `:construction_worker:` | Add or update CI build system. |
| 📈 | `:chart_with_upwards_trend:` | Add or update analytics or track code. |
| ♻️ | `:recycle:` | Refactor code. |
| ➕ | `:heavy_plus_sign:` | Add a dependency. |
| ➖ | `:heavy_minus_sign:` | Remove a dependency. |
| 🔧 | `:wrench:` | Add or update configuration files. |
| 🔨 | `:hammer:` | Add or update development scripts. |
| 🌐 | `:globe_with_meridians:` | Internationalization and localization. |
| ✏️ | `:pencil2:` | Fix typos. |
| 💩 | `:poop:` | Write bad code that needs to be improved. |
| ⏪️ | `:rewind:` | Revert changes. |
| 🔀 | `:twisted_rightwards_arrows:` | Merge branches. |
| 📦️ | `:package:` | Add or update compiled files or packages. |
| 👽️ | `:alien:` | Update code due to external API changes. |
| 🚚 | `:truck:` | Move or rename resources (e.g.: files, paths, routes). |
| 📄 | `:page_facing_up:` | Add or update license. |
| 💥 | `:boom:` | Introduce breaking changes. |
| 🍱 | `:bento:` | Add or update assets. |
| ♿️ | `:wheelchair:` | Improve accessibility. |
| 💡 | `:bulb:` | Add or update comments in source code. |
| 🍻 | `:beers:` | Write code drunkenly. |
| 💬 | `:speech_balloon:` | Add or update text and literals. |
| 🗃️ | `:card_file_box:` | Perform database related changes. |
| 🔊 | `:loud_sound:` | Add or update logs. |
| 🔇 | `:mute:` | Remove logs. |
| 👥 | `:busts_in_silhouette:` | Add or update contributor(s). |
| 🚸 | `:children_crossing:` | Improve user experience / usability. |
| 🏗️ | `:building_construction:` | Make architectural changes. |
| 📱 | `:iphone:` | Work on responsive design. |
| 🤡 | `:clown_face:` | Mock things. |
| 🥚 | `:egg:` | Add or update an easter egg. |
| 🙈 | `:see_no_evil:` | Add or update a .gitignore file. |
| 📸 | `:camera_flash:` | Add or update snapshots. |
| ⚗️ | `:alembic:` | Perform experiments. |
| 🔍️ | `:mag:` | Improve SEO. |
| 🏷️ | `:label:` | Add or update types. |
| 🌱 | `:seedling:` | Add or update seed files. |
| 🚩 | `:triangular_flag_on_post:` | Add, update, or remove feature flags. |
| 🥅 | `:goal_net:` | Catch errors. |
| 💫 | `:dizzy:` | Add or update animations and transitions. |
| 🗑️ | `:wastebasket:` | Deprecate code that needs to be cleaned up. |
| 🛂 | `:passport_control:` | Work on code related to authorization, roles and permissions. |
| 🩹 | `:adhesive_bandage:` | Simple fix for a non-critical issue. |
| 🧐 | `:monocle_face:` | Data exploration/inspection. |
| ⚰️ | `:coffin:` | Remove dead code. |
| 🧪 | `:test_tube:` | Add a failing test. |
| 👔 | `:necktie:` | Add or update business logic. |
| 🩺 | `:stethoscope:` | Add or update healthcheck. |
| 🧱 | `:bricks:` | Infrastructure related changes. |
| 🧑‍💻 | `:technologist:` | Improve developer experience. |
| 💸 | `:money_with_wings:` | Add sponsorships or money related infrastructure. |
| 🧵 | `:thread:` | Add or update code related to multithreading or concurrency. |
| 🦺 | `:safety_vest:` | Add or update code related to validation. |
| ✈️ | `:airplane:` | Improve offline support. |
| 🦖 | `:t-rex:` | Code that adds backwards compatibility. |
