class Provenance < Formula
  desc "Capture Claude Code session JSONL as secret gists linked from GitHub PRs"
  homepage "https://github.com/noamsiegel/provenance"
  url "https://github.com/noamsiegel/provenance/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "32f7a4d3bb3db130f9a84cfe6a6fb85f99f5727bf4a9ab81e75f954e06c64aab"
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
