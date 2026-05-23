class Guardrails < Formula
  desc "Personal git-hook quality layer (gitleaks, actionlint, commitlint, branch-guard)"
  homepage "https://github.com/noamsiegel/guardrails"
  url "https://github.com/noamsiegel/guardrails/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "1d73e39abaef1fcf8e2c2f5e57d09e80089ab92eca4fae20aa6a3b06b46ecf0a"
  license "MIT"
  head "https://github.com/noamsiegel/guardrails.git", branch: "main"

  depends_on "bash"
  depends_on "lefthook"
  depends_on "gitleaks"
  depends_on "actionlint"

  def install
    # Install the hook entry shims as the "binaries" of this package.
    # NOTE: in the post-day-2 refactor (Phase 5), this becomes a single `guardrails` binary.
    # For now, ship the existing files into pkgshare so users can install via
    # `guardrails install` or set core.hooksPath to the install dir.
    pkgshare.install "pre-commit", "pre-push", "commit-msg"
    pkgshare.install "lefthook.yml", "gitleaks.toml", "commitlint.config.cjs"
    (pkgshare / "checks").install Dir["checks/*"]
    (pkgshare / "tests").install Dir["tests/*"]
  end

  def caveats
    <<~EOS
      guardrails v0.2.0 is config-shaped, not yet a real CLI binary.

      To use:
        git config --global core.hooksPath #{pkgshare}

      Or per-repo:
        ln -s #{pkgshare}/pre-commit  .git/hooks/pre-commit
        ln -s #{pkgshare}/pre-push    .git/hooks/pre-push
        ln -s #{pkgshare}/commit-msg  .git/hooks/commit-msg

      A real `guardrails` CLI with safe `install` / `uninstall` is planned for v0.3.0.
    EOS
  end

  test do
    # Smoke test: lefthook can read the shipped config.
    system "#{HOMEBREW_PREFIX}/bin/lefthook", "validate",
           "--config", "#{pkgshare}/lefthook.yml"
  end
end
