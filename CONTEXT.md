# CONTEXT.md

## Repository role

`noamsiegel/homebrew-tap` is the public Homebrew tap for installing the ecosystem CLIs. It should be understandable to someone arriving from `brew tap noamsiegel/tap` without seeing the private development context.

## Current formulas

| Formula | Upstream | Packaging style | Update owner |
|---|---|---|---|
| `agents-toc` | `noamsiegel/agents-toc` | GoReleaser-generated binary archives for macOS/Linux x86_64/arm64 | Upstream GoReleaser release |
| `git-guardrails` | `noamsiegel/git-guardrails` | Source tarball; installs shell script plus shared hook resources | Manual tap bump |
| `ai-git-guardrails` | `noamsiegel/ai-git-guardrails` | Deprecated compatibility formula for the old name | Manual tap bump |
| `ai-trace` | `noamsiegel/ai-trace` | Source tarball; installs TypeScript CLI under `libexec` with a Bun wrapper | Manual tap bump |
| `git-wt` | `noamsiegel/git-wt` | Source tarball; installs Bash CLI, `wt` symlink, plugin registry, examples, docs | Manual tap bump |

## Naming history

v0.8.0 renamed old formulas to `ai-*` names. `ai-git-guardrails` is now being renamed again to `git-guardrails` because the product boundary is universal Git hook checks, not AI-specific behavior.

Use `git-guardrails` in README install paths, formula paths, workflow names, and examples. Compatibility references to `ai-git-guardrails` or older `guardrails` names may remain only as explicit migration notes for installed users. The old `ai-git-guardrails` formula remains temporarily as a deprecated compatibility formula until migration safety is confirmed.

As of 2026-05-24, `noamsiegel/git-guardrails` is the canonical upstream. `Formula/git-guardrails.rb` points at the canonical repo and installs both `git-guardrails` plus the temporary `ai-git-guardrails` compatibility wrapper shipped by upstream.

## Formula consistency policy

Manual formulas should use one Ruby pattern:

1. `class <Name> < Formula`
2. `desc`
3. `homepage`
4. `url`
5. `sha256`
6. `license`
7. `head`
8. `depends_on` lines
9. `def install`
10. optional `def caveats`
11. `test do`

`agents-toc.rb` is the exception because GoReleaser emits per-platform `on_macos`/`on_linux` URL blocks and an explicit `version`. Treat that as generated style, not drift to normalize manually.

## Release-risk reminders

- Formula URL tag, sha256, and upstream release tag must point at the same artifact.
- Never create a GitHub release for a product until the product push and tag push have succeeded.
- If an upstream tag was created at the wrong commit, delete/recreate the remote tag before touching this tap.
- Smoke tests must cover shipped runtime data. `git-wt` specifically needs `plugins-registry.json` in `pkgshare`.
- Hook rename migrations can leave stale shims in consuming repos; fix installed hooks with current CLI commands instead of editing this tap around stale local state.

## Tap automation assessment

Manual formula updates are acceptable at current scale, but repeat enough boilerplate that automation deserves a trial. Prefer PR-generating automation over direct commits to `main`.
