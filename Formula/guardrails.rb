class Guardrails < Formula
  desc "Personal git-hook quality layer (gitleaks, actionlint, commitlint, branch-guard)"
  homepage "https://github.com/noamsiegel/guardrails"
  url "https://github.com/noamsiegel/guardrails/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "1b0e5f8c73af7a755819af6a633174d45a40893171dae2c19bcba0ff04bde16a"
  license "MIT"
  head "https://github.com/noamsiegel/guardrails.git", branch: "main"

  depends_on "bash"
  depends_on "lefthook"
  depends_on "gitleaks"
  depends_on "actionlint"

  def install
    bin.install "guardrails"
    pkgshare.install "lefthook.yml", "gitleaks.toml", "commitlint.config.cjs"
    (pkgshare / "checks").install Dir["checks/*"]
    (pkgshare / "tests").install Dir["tests/*"]

    # The binary uses GUARDRAILS_TEMPLATES env var to locate shipped resources.
    # Inject the brew install path so `guardrails run <hook>` finds lefthook.yml.
    inreplace bin / "guardrails", /^GUARDRAILS_TEMPLATES=.*$/,
              "GUARDRAILS_TEMPLATES=\"${GUARDRAILS_TEMPLATES:-#{pkgshare}}\""
  end

  def caveats
    <<~EOS
      To install guardrails hooks into the current repo:
        guardrails install

      To configure new clones to auto-install guardrails:
        guardrails --global-template

      Migrate from the legacy ~/.git-hooks-personal/ setup:
        guardrails migrate           # dry-run
        guardrails migrate --apply   # perform the migration

      See `guardrails --help` and the README for details.
    EOS
  end

  test do
    assert_match(/guardrails/, shell_output("#{bin}/guardrails --version"))
    system "#{bin}/guardrails", "doctor"
  end
end
