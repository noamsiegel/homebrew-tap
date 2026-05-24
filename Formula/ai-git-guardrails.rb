class AiGitGuardrails < Formula
  desc "Personal git-hook quality layer for AI-coding workflows (gitleaks, actionlint, commitlint, branch-guard)"
  homepage "https://github.com/noamsiegel/ai-git-guardrails"
  url "https://github.com/noamsiegel/ai-git-guardrails/archive/refs/tags/v0.8.1.tar.gz"
  sha256 "7a12f7dd9cbec56e991bbf44221fc0148f244e437f6e3ba2023fae250642a37e"
  license "MIT"
  head "https://github.com/noamsiegel/ai-git-guardrails.git", branch: "main"

  depends_on "bash"
  depends_on "lefthook"
  depends_on "gitleaks"
  depends_on "actionlint"

  def install
    bin.install "ai-git-guardrails"
    pkgshare.install "lefthook.yml", "gitleaks.toml", "commitlint.config.cjs"
    (pkgshare / "checks").install Dir["checks/*"]
    (pkgshare / "tests").install Dir["tests/*"]

    # The binary uses AI_GIT_GUARDRAILS_TEMPLATES env var to locate shipped resources.
    # Inject the brew install path so `ai-git-guardrails run <hook>` finds lefthook.yml.
    inreplace bin / "ai-git-guardrails", /^AI_GIT_GUARDRAILS_TEMPLATES=.*$/,
              "AI_GIT_GUARDRAILS_TEMPLATES=\"${AI_GIT_GUARDRAILS_TEMPLATES:-#{pkgshare}}\""
  end

  def caveats
    <<~EOS
      To install ai-git-guardrails hooks into the current repo:
        ai-git-guardrails install

      To configure new clones to auto-install ai-git-guardrails:
        ai-git-guardrails --global-template

      Migrating from the legacy `guardrails` install:
        - Old marker `# guardrails-managed:` is still recognized as ours.
        - Old `GUARDRAILS_*` env vars still work (one-time migration warning).
        - Old `~/.config/guardrails/` config dir is read as fallback.
        - When ready, run `ai-git-guardrails install` to refresh hooks to the
          new marker shape.

      See `ai-git-guardrails --help` and the README for details.
    EOS
  end

  test do
    assert_match(/ai-git-guardrails/, shell_output("#{bin}/ai-git-guardrails --version"))
    system "#{bin}/ai-git-guardrails", "doctor"
  end
end
