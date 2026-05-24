class GitGuardrails < Formula
  desc "User-owned Git hook quality layer"
  homepage "https://github.com/noamsiegel/git-guardrails"
  url "https://github.com/noamsiegel/git-guardrails/archive/refs/tags/v0.9.2.tar.gz"
  sha256 "8db0d6643c84bc5d93fb1dda8559aec2c0fbb6fbaff5b75969d76e6bc13de8b1"
  license "MIT"
  head "https://github.com/noamsiegel/git-guardrails.git", branch: "main"

  depends_on "actionlint"
  depends_on "bash"
  depends_on "gitleaks"
  depends_on "lefthook"

  def install
    bin.install "git-guardrails"
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
