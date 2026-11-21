# Claude Code setup

My working setup for [Claude Code](https://claude.com/claude-code): global rules, a second-opinion agent, a status line, and the plugins and skills I run every day. Clone it, run one script, restart Claude Code.

## What's inside

| Path | Installs to | What it does |
|---|---|---|
| `CLAUDE.md` | `~/.claude/CLAUDE.md` | Global rules for every project: find the crux first, work from the real code, debug by elimination, verify before claiming done, spend tokens on thinking rather than context. |
| `rules/common/core.md` | `~/.claude/rules/common/core.md` | Short core rules: commit format, search for existing code before hand-rolling, tests first, immutable updates. |
| `agents/oracle.md` | `~/.claude/agents/oracle.md` | `oracle`, a read-only subagent for hard calls only: costly design decisions, bugs that survived two fixes, last audit of a risky diff. |
| `statusline/statusline.ps1` | `~/.claude/statusline.ps1` | Status line showing folder and model, plus the caveman badge when that plugin is on. Windows/PowerShell only. |
| `settings.example.json` | (reference) | The settings I use: model, effort, auto mode, status line, enabled plugins, extra marketplaces. |

## Install

Requires Claude Code with the `claude` CLI on your PATH.

**Windows (PowerShell)**

```powershell
git clone https://github.com/Bhavya007-17/claude-code-setup
cd claude-code-setup
powershell -ExecutionPolicy Bypass -File .\install.ps1
```

**macOS / Linux / WSL**

```bash
git clone https://github.com/Bhavya007-17/claude-code-setup
cd claude-code-setup
bash install.sh
```

The scripts copy the files above into `~/.claude`, back up anything they replace as `<file>.bak-<timestamp>`, add the plugin marketplaces and install the plugins at user scope. Pass `-SkipPlugins` (PowerShell) or `--skip-plugins` (bash) to copy only the files.

They never edit your `settings.json`. Copy the parts of `settings.example.json` you want by hand. For the status line on Windows, replace `YOUR_USER` with your user name (the PowerShell script prints the exact line for you).

## Plugins

| Plugin | Source | Why |
|---|---|---|
| `superpowers` | [obra/superpowers](https://github.com/obra/superpowers) | Process skills: brainstorming, writing plans, TDD, systematic debugging, subagent-driven development, verification before completion. |
| `fable-foreman` | [olsenbrands/fable-foreman](https://github.com/olsenbrands/fable-foreman) | Orchestrator mode: the lead model plans and verifies, cheaper workers execute, a blind verifier checks the result. |
| `caveman` | [JuliusBrussee/caveman](https://github.com/JuliusBrussee/caveman) | Terse output mode that cuts response tokens, plus compressed-output subagents and a status line badge. |
| `frontend-design` | [anthropics/claude-plugins-official](https://github.com/anthropics/claude-plugins-official) | Guidance for distinctive UI instead of template-looking defaults. |
| `commit-commands` | [anthropics/claude-plugins-official](https://github.com/anthropics/claude-plugins-official) | `/commit`, `/commit-push-pr`, `/clean_gone`. |
| `ralph-loop` | [anthropics/claude-plugins-official](https://github.com/anthropics/claude-plugins-official) | Runs Claude in a self-repeating loop on one task. |
| `security-guidance` | [anthropics/claude-plugins-official](https://github.com/anthropics/claude-plugins-official) | Warns about common security mistakes while editing. |
| `playwright` | [anthropics/claude-plugins-official](https://github.com/anthropics/claude-plugins-official) | Playwright MCP server for browser automation. |

Install one by hand:

```bash
claude plugin marketplace add JuliusBrussee/caveman
claude plugin install caveman@caveman --scope user
```

## Skills

These are third-party skills I upload to claude.ai (Settings > Capabilities > Skills). They are linked here rather than copied, so you get the current version and its license from the author.

| Skill | Source | Use |
|---|---|---|
| `ros2-engineering` | [dbwls99706/ros2-engineering-skills](https://github.com/dbwls99706/ros2-engineering-skills) | ROS 2 development, review and debugging. Also a Claude Code plugin: `/plugin marketplace add dbwls99706/ros2-engineering-skills`. |
| `skill-inspector` | [NVIDIA/SkillSpector](https://github.com/NVIDIA/SkillSpector) | Reviews a skill for safety before you install it. |
| `find-skills` | [vercel-labs/skills](https://github.com/vercel-labs/skills) | Finds and installs skills with `npx skills`. |
| `ruflo` | [ruvnet/ruflo](https://github.com/ruvnet/ruflo) | Multi-agent orchestration layer for Claude Code. |

Anthropic's own skills (docx, pdf, pptx, xlsx, skill-creator and others) ship with claude.ai and need no install.

## Notes

- `oracle` runs on the `fable` model. If your plan has no Fable access, change `model: fable` to `model: opus` in `agents/oracle.md`.
- `settings.example.json` sets `"defaultMode": "auto"`, which lets Claude act without asking for each permission. Leave it out if you want the default prompts.
- The commit rule in `rules/common/core.md` says no `Co-Authored-By` trailer. Edit it if you want attribution.

## Not included

Anything personal or machine-specific: memory files, history, credentials, project transcripts, local permission allowlists, and hooks that point at apps on my machine.

## License

MIT for the files in this repo. Each linked plugin and skill keeps its own license.
