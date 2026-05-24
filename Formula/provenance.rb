class Provenance < Formula
  desc "Capture Claude Code session JSONL as secret gists linked from GitHub PRs"
  homepage "https://github.com/noamsiegel/provenance"
  url "https://github.com/noamsiegel/provenance/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "07485849d92a7ffce7ca57955d7032848bbf1697cb3b3c7d492773247ba98647"
  license "MIT"
  head "https://github.com/noamsiegel/provenance.git", branch: "main"

  depends_on "bun"
  depends_on "gh"
  depends_on "gitleaks"

  def install
    libexec.install "cli.ts", "package.json", "src"
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
