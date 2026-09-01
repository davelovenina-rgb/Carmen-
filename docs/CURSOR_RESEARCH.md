# CURSOR RESEARCH — September 2026

Research done before the harness was built. Every design choice in
[`ARCHITECTURE.md`](ARCHITECTURE.md) traces back to something here.

**Read this before changing anything under `.cursor/`.** Several of these behaviors are
counter-intuitive, and at least three of them fail *silently* — no error, no warning, the thing
simply never loads.

> **A standing warning about Cursor's documentation.** It lags the product badly. During this
> research, three features — `@Docs`, Notepads, and Memories — had live-looking documentation
> pages after they had been removed from the product. Verify against the changelog and staff forum
> posts, not the docs page alone.

---

## 1. Rules

### The file format

- Rules live in `.cursor/rules/`. **The extension must be `.mdc`.**
- **A `.md` file in `.cursor/rules/` is silently ignored.** No error, no warning — it never loads
  and never appears in the Rules panel. Cursor staff have confirmed this in a bug thread where a
  user's rules were invisible until renamed.
  → *`harness/verify.sh` check 2 exists for exactly this.*
- Frontmatter has **exactly three fields**: `description`, `globs`, `alwaysApply`. There is no
  fourth. Do not invent one.
- **`globs` is a comma-separated string, not a YAML list.** Every official example uses
  `globs: docs/**/*.md, docs/**/*.mdx`. Array syntax is unconfirmed.
- Every official example writes `alwaysApply` explicitly. No default for an omitted value is
  documented — so always write it.

### The four application modes

| Mode | Frontmatter | When it loads |
|---|---|---|
| Always Apply | `alwaysApply: true` alone | **every request**, in full |
| Apply to Specific Files | `globs: <patterns>` + `alwaysApply: false` | when a matching file is in context |
| Apply Intelligently | `description: <text>` + `alwaysApply: false` | when the agent judges it relevant |
| Apply Manually | `alwaysApply: false` alone | only when `@`-mentioned |

The UI labels were renamed — older material calls these "Always / Auto Attached / Agent Requested
/ Manual." Same mechanics, different words.

### Cost

Cursor's own guidance: keep a rule under 500 lines, split large rules, and **reference files with
`@path` rather than pasting content** — it keeps the rule short and stops it going stale.

Staff on limits: *"There is no fixed length limit but note that with too long or too many rules
you will confuse AI and consume unnecessary amount of tokens."* The constraint is soft and
qualitative, which is exactly why a hard local budget is useful.

→ *Three always-on rules, 57 lines total. `verify.sh` fails at a fourth.*

### Nested rules — do not rely on them

Per-subdirectory `.cursor/rules/` folders as a *scoping* mechanism were documented in 2025, were
confirmed buggy in monorepos by Cursor staff in October 2025, and no longer appear in the current
docs. Subfolders inside one `.cursor/rules/` tree are a filing convenience only — not scoping.

→ *One flat `.cursor/rules/` directory. Scoping via `globs`.*

### Precedence

Team Rules → Project Rules → User Rules. **All applicable rules are merged**; source order is a
tie-breaker on conflict, not an exclusion. Numeric filename prefixes (`000-`, `300-`) are a
**human** convention only — the parser does not read them as ordering.

### Rules do not reach everything

Rules apply to Agent/Chat only. **Not** to Tab completion, **not** to Inline Edit (Cmd/Ctrl+K),
and **not** to Bugbot PR reviews.

→ *That last one is why `.cursor/BUGBOT.md` exists as a separate channel.*

---

## 2. `AGENTS.md` — the big one

`AGENTS.md` is a first-class feature: plain Markdown, no frontmatter, read automatically from the
project root. `CLAUDE.md` is read the same way and is **unconditionally always-on**, with no
conditional option at all.

**The critical behavior:** since Cursor **3.6**, nested `AGENTS.md` files are discovered across
the *entire* repository and loaded in **full on every request**, because `AGENTS.md` is an
always-rule. Cursor staff, July 2026:

> *"AGENTS.md files are 'Always' rules, so their full contents load on every request. Since 3.6,
> Cursor discovers nested AGENTS.md files across the entire repo."*

The reporting team was loading ~600k tokens of rules against a 300k context window before the
first message. Staff mitigations: open a subfolder as the workspace root, **convert nested
`AGENTS.md` to `globs`-scoped `.mdc` rules**, or consolidate to a single root file.

→ *One root `AGENTS.md`, 62 lines. Everything directory-scoped is a globbed `.mdc`.
`verify.sh` check 3 fails if a second appears. Recorded as `state/DECISIONS.md` D-004.*

**Cross-harness note:** Claude Code lazy-loads nested context files by directory, so it prefers
the opposite layout. A repository serving both harnesses has to pick one. This one picks Cursor.

---

## 3. Skills

`.cursor/skills/<name>/SKILL.md`, with optional `scripts/`, `references/`, `assets/` subfolders.

Frontmatter: `name` (required, lowercase-hyphen, **must match the folder name**), `description`
(required — the agent uses it to judge relevance), and optional `paths`, `disable-model-invocation`,
`icon`, `color`, `metadata`.

Also read from: `.agents/skills/`, `~/.cursor/skills/`, `~/.agents/skills/`, and — for
compatibility — `.claude/skills/` and `.codex/skills/`.

**Why skills are the right home for heavy knowledge.** Cursor's dynamic context discovery keeps
only `name` + `description` in static context and loads the body on demand. Their published A/B
result for the equivalent change to MCP tool descriptions was a **46.9% reduction in total agent
tokens**.

Invoke with `/skill-name` or `@skill-name`. Explicit monorepo guidance: *"skills can be colocated
with the package they apply to."*

**Limitation:** user-level skill folders are **not** copied to Cloud Agents or remote SSH sessions.
Only project-level ones travel.

→ *Five skills carrying the depth: `carmen-soul`, `carmen-law`, `six-posture-audit`,
`react-lane`, `compose-lane`.*

---

## 4. Commands

`.cursor/commands/*.md` — plain Markdown, **no frontmatter documented**. The command name is the
filename: `boot.md` → `/boot`. Invoked by typing `/` in the agent input.

**Beta**, per Cursor's own docs, with syntax subject to change. No argument or placeholder syntax
is documented — treat commands as parameterless prompts.

→ *Nine commands. Each one is a procedure with a hard stop, not a request for output.*

---

## 5. Hooks

`.cursor/hooks.json` (project) or `~/.cursor/hooks.json` (user). `"version": 1`. Cursor watches the
file and reloads automatically — the presence of a valid file activates hooks; there is no toggle.

### Events used here

| Event | Input | Response |
|---|---|---|
| `sessionStart` | common payload | `{"additional_context": "..."}` |
| `beforeReadFile` | `file_path`, `content`, `attachments` | `{"permission": "allow"\|"deny", "user_message": "..."}` |
| `preToolUse` | `tool_name`, `tool_input`, `tool_use_id`, `cwd` | `{"permission": "allow"\|"deny", "agent_message": "...", "updated_input": {...}}` |
| `beforeShellExecution` | `command`, `cwd`, `sandbox` | `{"permission": "allow"\|"deny"\|"ask", "user_message": "...", "agent_message": "..."}` |
| `afterFileEdit` | `file_path`, `edits[]` | *(after the fact — cannot block)* |

Other events exist: `sessionEnd`, `postToolUse`, `postToolUseFailure`, `subagentStart`,
`subagentStop`, `afterShellExecution`, `beforeMCPExecution`, `afterMCPExecution`,
`beforeSubmitPrompt`, `preCompact`, `stop`, `afterAgentResponse`, `afterAgentThought`,
`beforeTabFileRead`, `afterTabFileEdit`, `workspaceOpen`.

### Entry fields

`command` (required), `type` (`"command"` default, or `"prompt"` for an LLM-evaluated check),
`timeout` (seconds), `matcher` (filter by tool name or command pattern), `loop_limit`,
and **`failClosed`** (default `false`).

### Exit codes

`0` = success, use JSON on stdout · `2` = block · anything else = the hook failed and
**the action proceeds anyway** unless `failClosed: true`.

### Caveats that matter

- **Fail-open by default.** A crashing guard script lets the action through silently.
  → *`failClosed: true` on all three guards here.*
- Cursor staff have described **project-level hooks as experimental**; the 1.7 changelog announcing
  them called the feature beta.
- `beforeShellExecution` in a *user* hooks file needs **Settings → Chat → "Run Everything"**
  enabled to fire.
- Hooks reportedly do **not** activate over Remote-SSH.
- Hooks are only available inside a **project** — opening a single file, not a folder, means they
  never load.
- A reported Windows bug: a **UTF-8 BOM** on the stdin payload breaks naive JSON parsing, silently
  degrading guards to allow.
  → *`_lib.sh` strips a BOM before parsing.*

→ *All of this is recorded as open risks `R-002` and `R-003`. The guards are a seatbelt, not a
vault.*

---

## 6. Review — Bugbot and local review

**`.cursor/rules/*.mdc` do NOT apply to Bugbot.** Cursor states this in two places. Review
guidance must live in `.cursor/BUGBOT.md`.

- The root `.cursor/BUGBOT.md` is always included; nested ones are picked up by walking upward
  from each changed file.
- Rule merge order for a review: Team Rules → project `BUGBOT.md` (including nested) → learned
  rules → manual rules.
- Limits: each rule truncated at 30,000 characters; combined rules capped at 100,000.

**Local review exists** — this is the "local bug bot":

- `/review-bugbot` and `/review` run the Bugbot engine locally, **before** pushing. By default they
  review the whole branch diff against the base branch, committed and uncommitted. Available in
  Cursor 3.7+; CLI support was still listed as coming.
- `/agent-review` is a separately documented local review of working-tree changes, with **Quick**
  and **Deep** depth levels. It also reads `BUGBOT.md`.
- Local runs store the diff's git patch-id, so cloud Bugbot skips a diff already reviewed locally.

Cloud Bugbot is **usage-based** as of 2026 (~$1.00–1.50 per run); the "14-day free trial" copy on
the marketing page was confirmed on the forum as stale.

→ *`.cursor/BUGBOT.md` is written. Review is a tool Carmen may run, never a gate
(`law/GOVERNANCE.md` §11, `state/DECISIONS.md` D-003).*

---

## 7. MCP

`.cursor/mcp.json` (project) or `~/.cursor/mcp.json` (global).

```json
{ "mcpServers": {
    "name": { "type": "stdio", "command": "npx", "args": ["-y", "pkg"],
              "env": { "KEY": "${env:VAR}" }, "envFile": ".env" },
    "remote": { "url": "https://example.com/mcp",
                "headers": { "Authorization": "Bearer ${env:KEY}" } } } }
```

- Interpolation: `${env:NAME}`, `${userHome}`, `${workspaceFolder}`,
  `${workspaceFolderBasename}`, `${pathSeparator}`.
- **There is no `disabled` field.** Cursor support confirmed it: *"We do not have a
  `disabledServers` config section."* Toggling is UI-only.
- OAuth: static credentials via an `auth` block, or automatic discovery + dynamic client
  registration + PKCE.
- Approval is requested before an MCP tool runs, by default. Leave that on.
- A widely reported 40-tool ceiling dates from 2024–2025 and could not be confirmed for 2026;
  dynamic tool loading may have changed it.

→ *`.cursor/mcp.json.example` is tracked; `.cursor/mcp.json` is gitignored. A live MCP config is
where a token ends up.*

---

## 8. Indexing and ignore files

**Cursor is retiring embeddings-based semantic indexing** in favour of "Instant Grep," a local
grep-based engine. Staff, July 2026: *"Semantic/embeddings indexing is being turned down in favor
of grep-based retrieval."* The codebase-indexing settings page was removed; the index lives
locally in `.git/cursor/`, respects `.gitignore` and `.cursorignore`, and updates incrementally.
There is no manual re-index step any more.

`.cursorignore`: `.gitignore` syntax, project root, and `.gitignore` is respected automatically
in addition. **It is not a security boundary** — Cursor's docs state that terminal and MCP tools
can still reach ignored files.

**Known regression (August 2026):** `.cursorignore` negation (`!`) patterns cannot override
`.gitignore` exclusions while Instant Grep is enabled.
→ *No negation patterns are used in this repository's `.cursorignore`.*

`.cursorindexingignore` is community-known but **absent from current official documentation**.
Not used here.

→ *Design implication: stay greppable. Small, well-named, single-concern files.*

---

## 9. Features that no longer exist

Do not build on these — and do not "restore" them after reading an out-of-date page:

| Feature | Status |
|---|---|
| `@Docs` | **Removed August 2026.** Staff: *"agents are good enough now at finding the docs themselves."* Its docs page was still live afterward. |
| Notepads | **Removed end of October 2025.** Replacement: rules, commands, plain Markdown. |
| Memories | **Removed in 2.1.x.** No UI to view or manage them. |
| `@Codebase` | Removed ~April 2025. The agent searches automatically. |
| `.cursorrules` | Legacy, deprecation announced. Equivalent to a rule with `alwaysApply: true`. |

---

## 10. Other current facts

- **Plan mode** produces an editable Markdown plan, saved by default **outside** the repository
  (in the user's home directory). It reaches the repo only if "Save to workspace" is clicked.
- The in-chat **todo list** is UI state; no documented repo file backs it.
  → *That is why `state/` is written by hand — Cursor persists neither plans nor todos into the
  repository on its own.*
- **CLI**: the binary is `agent` (community materials often call it `cursor-agent`). It reads the
  same `.cursor/rules`, `AGENTS.md`, `CLAUDE.md`, and `mcp.json`. Headless via `-p`, with
  `--output-format text|json|stream-json`. Usable in CI.
- **Worktrees**: `.cursor/worktrees.json` with `setup-worktree` commands run on creation.
- **Cloud agents**: `.cursor/environment.json` — `install`, `start`, `terminals`, `ports`,
  `snapshot`, `build.dockerfile`. Cloud agents do **not** support multi-root workspaces.

---

## Sources

Primary — `cursor.com/docs`: `/rules`, `/skills`, `/hooks`, `/bugbot`, `/mcp`,
`/agent/agent-review`, `/agent/plan-mode`, `/agent/tools/search`, `/cli/*`,
`/cloud-agent/setup`, `/configuration/worktrees`, `/reference/ignore-file`,
`/reference/third-party-hooks`; `cursor.com/help/customization/*`;
`cursor.com/blog/dynamic-context-discovery`; `cursor.com/changelog` (1.6, 1.7, 2.1, 2.2, 2.6,
3.0, 3.2, 04-08-26, 04-30-26).

Cursor staff replies on `forum.cursor.com` (cited inline above where they are the only source):
nested `AGENTS.md` context blowup (165337), nested `.cursor/rules` monorepo bug (135595), rules
hierarchy and length (108589), `.mdc` extension requirement (161731), Memories removal (148254),
`@Docs` removal (161651), Notepads deprecation (138305), MCP toggle (129256), indexing turn-down
(165899), hooks not loading (136920), Windows BOM in hook stdin (166794).

**Anything sourced only from the forum is marked as such above.** Cursor's docs and its product
disagree often enough that the distinction matters.
