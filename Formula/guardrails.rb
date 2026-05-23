class Guardrails < Formula
  desc "Personal git-hook quality layer (gitleaks, actionlint, commitlint, branch-guard)"
  homepage "https://github.com/noamsiegel/guardrails"
  url "https://github.com/noamsiegel/guardrails/archive/refs/tags/v0.3.2.tar.gz"
  sha256 "83eb0661265c72af24bb8e6c454d1d13d2f4a2ec37172110f418bca598526d83"
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
