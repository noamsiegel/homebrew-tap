class AiGitGuardrails < Formula
  desc "Deprecated compatibility wrapper for git-guardrails"
  homepage "https://github.com/noamsiegel/git-guardrails"
  url "https://github.com/noamsiegel/git-guardrails/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "42bc56c0ac93006e24285c2a0fc59d630043101c876b52ec16786290c0194e79"
  license "MIT"
  deprecate! date: "2026-05-24", because: "renamed to git-guardrails"
  head "https://github.com/noamsiegel/git-guardrails.git", branch: "main"

  depends_on "actionlint"
  depends_on "bash"
  depends_on "gitleaks"
  depends_on "lefthook"

  conflicts_with "git-guardrails", because: "both install git-guardrails and ai-git-guardrails commands"

  def install
    bin.install "git-guardrails"
    bin.install "ai-git-guardrails"
    pkgshare.install "lefthook.yml", "gitleaks.toml", "commitlint.config.cjs"
    (pkgshare / "checks").install Dir["checks/*"]
    (pkgshare / "tests").install Dir["tests/*"]

    inreplace bin / "git-guardrails", /^GIT_GUARDRAILS_TEMPLATES=.*$/,
              "GIT_GUARDRAILS_TEMPLATES=\"${GIT_GUARDRAILS_TEMPLATES:-#{pkgshare}}\""
  end

  def caveats
    <<~EOS
      ai-git-guardrails is deprecated. Install the renamed formula instead:
        brew uninstall ai-git-guardrails
        brew install git-guardrails

      This compatibility formula installs both `git-guardrails` and the legacy
      `ai-git-guardrails` forwarding wrapper so old hook shims keep working.
    EOS
  end

  test do
    assert_match(/git-guardrails/, shell_output("#{bin}/ai-git-guardrails --version"))
    assert_match(/git-guardrails/, shell_output("#{bin}/git-guardrails --version"))
    assert_match(/git reachable/, shell_output("#{bin}/git-guardrails doctor 2>&1"))
    assert_match(/branch-guard/, (pkgshare/"checks/registry.sh").read)
  end
end
