class AiGitGuardrails < Formula
  desc "Git-hook quality layer for AI-coding workflows"
  homepage "https://github.com/noamsiegel/ai-git-guardrails"
  url "https://github.com/noamsiegel/ai-git-guardrails/archive/refs/tags/v0.8.3.tar.gz"
  sha256 "500e8e73a4e078b2063ebabafd2d255b10ecf6721553f334069b4f2c5547fe1b"
  license "MIT"
  head "https://github.com/noamsiegel/ai-git-guardrails.git", branch: "main"

  depends_on "actionlint"
  depends_on "bash"
  depends_on "gitleaks"
  depends_on "lefthook"

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
    # doctor loads checks/registry.sh and runs registry-driven reachability checks.
    assert_match(/git reachable/, shell_output("#{bin}/ai-git-guardrails doctor 2>&1"))
    # branch-guard comes from checks/registry.sh; catches missing or incomplete registry packaging.
    assert_match(/branch-guard/, (pkgshare/"checks/registry.sh").read)
  end
end
