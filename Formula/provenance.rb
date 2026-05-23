class Provenance < Formula
  desc "Capture Claude Code session JSONL as secret gists linked from GitHub PRs"
  homepage "https://github.com/noamsiegel/provenance"
  url "https://github.com/noamsiegel/provenance/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "079ae69f292644266090fdde5bb211dcc9574d2cd0c3174e7adb2beda7f4da99"
  license "MIT"
  head "https://github.com/noamsiegel/provenance.git", branch: "main"

  depends_on "bun"
  depends_on "gh"
  depends_on "gitleaks"

  def install
    libexec.install "cli.ts", "package.json"
    (bin / "provenance").write <<~SH
      #!/usr/bin/env bash
      exec #{Formula["bun"].opt_bin}/bun #{libexec}/cli.ts "$@"
    SH
    chmod 0755, bin / "provenance"
  end

  test do
    assert_match(/provenance/, shell_output("#{bin}/provenance --help"))
  end
end
