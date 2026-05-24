class GitGuardrails < Formula
  desc "User-owned Git hook quality layer"
  homepage "https://github.com/noamsiegel/git-guardrails"
  url "https://github.com/noamsiegel/git-guardrails/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "42bc56c0ac93006e24285c2a0fc59d630043101c876b52ec16786290c0194e79"
  license "MIT"
  head "https://github.com/noamsiegel/git-guardrails.git", branch: "main"

  depends_on "actionlint"
  depends_on "bash"
  depends_on "gitleaks"
  depends_on "lefthook"

  conflicts_with "ai-git-guardrails", because: "git-guardrails installs an ai-git-guardrails compatibility wrapper"

  def install
    bin.install "git-guardrails"
    bin.install "ai-git-guardrails"
    pkgshare.install "lefthook.yml", "gitleaks.toml", "commitlint.config.cjs"
    (pkgshare / "checks").install Dir["checks/*"]
    (pkgshare / "tests").install Dir["tests/*"]

    # The binary uses GIT_GUARDRAILS_TEMPLATES env var to locate shipped resources.
    # Inject the brew install path so `git-guardrails run <hook>` finds lefthook.yml.
    inreplace bin / "git-guardrails", /^GIT_GUARDRAILS_TEMPLATES=.*$/,
              "GIT_GUARDRAILS_TEMPLATES=\"${GIT_GUARDRAILS_TEMPLATES:-#{pkgshare}}\""
  end

  def caveats
    <<~EOS
      To install git-guardrails hooks into the current repo:
        git-guardrails install

      To configure new clones to auto-install git-guardrails:
        git-guardrails --global-template

      Migration notes:
        - If ai-git-guardrails is installed, run `brew uninstall ai-git-guardrails`
          before installing git-guardrails.
        - Existing ai-git-guardrails hook markers, AI_GIT_GUARDRAILS_* env vars,
          and ~/.config/ai-git-guardrails/ config remain supported temporarily.
        - Old guardrails markers/env/config are still handled by the upstream CLI.
        - When ready, run `git-guardrails install` in enrolled repos to refresh
          hooks to the command name provided by this formula.

      See `git-guardrails --help` and the README for details.
    EOS
  end

  test do
    assert_match(/guardrails/, shell_output("#{bin}/git-guardrails --version"))
    # doctor loads checks/registry.sh and runs registry-driven reachability checks.
    assert_match(/git reachable/, shell_output("#{bin}/git-guardrails doctor 2>&1"))
    # branch-guard comes from checks/registry.sh; catches missing or incomplete registry packaging.
    assert_match(/branch-guard/, (pkgshare/"checks/registry.sh").read)
  end
end
