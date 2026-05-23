# noamsiegel/homebrew-tap

Homebrew tap for [@noamsiegel](https://github.com/noamsiegel)'s tools.

## Install

```bash
brew tap noamsiegel/tap
brew install git-wt        # parallel-safe git worktree CLI
brew install guardrails    # personal git-hook quality layer
brew install provenance    # capture Claude Code sessions as PR-linked gists
```

## Update

```bash
brew update
brew upgrade git-wt        # or guardrails / provenance
```

## Uninstall

```bash
brew uninstall <name>
brew untap noamsiegel/tap   # if you also want to remove the tap itself
```

## Tools in this tap

| Formula | Repo | Description |
|---|---|---|
| [`git-wt`](Formula/git-wt.rb) | [noamsiegel/git-wt](https://github.com/noamsiegel/git-wt) | Parallel-safe git worktree CLI for agentic coding |
| [`guardrails`](Formula/guardrails.rb) | [noamsiegel/guardrails](https://github.com/noamsiegel/guardrails) | Personal git-hook quality layer (gitleaks, actionlint, commitlint, branch-guard) |
| [`provenance`](Formula/provenance.rb) | [noamsiegel/provenance](https://github.com/noamsiegel/provenance) | Capture Claude Code session JSONL as secret gists linked from PRs |

## How formulae get updated

When a main repo cuts a new release (via its own release workflow), it opens a
PR against this tap repo to bump the formula's `url` and `sha256`. Merging the
PR makes the new version available via `brew upgrade`.

## License

MIT. See [LICENSE](./LICENSE).
