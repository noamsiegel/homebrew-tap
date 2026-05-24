class AiTrace < Formula
  desc "Capture AI coding session transcripts as PR-linked gists"
  homepage "https://github.com/noamsiegel/ai-trace"
  url "https://github.com/noamsiegel/ai-trace/archive/refs/tags/v0.8.2.tar.gz"
  sha256 "1c4926d68bd5281cf54845452f10ee737a1d46fa1a171e0985cb415c228f96db"
  license "MIT"
  head "https://github.com/noamsiegel/ai-trace.git", branch: "main"

  depends_on "bun"
  depends_on "gh"
  depends_on "gitleaks"

  def install
    libexec.install "cli.ts", "package.json", "src"
    (bin / "ai-trace").write <<~SH
      #!/usr/bin/env bash
      exec #{Formula["bun"].opt_bin}/bun #{libexec}/cli.ts "$@"
    SH
    chmod 0755, bin / "ai-trace"
  end

  test do
    # --help check (binary wiring)
    assert_match(/ai-trace/, shell_output("#{bin}/ai-trace --help"))
    # scrub-rules loads src/core/scrubbers.ts via the cli wrapper; catches missing src/ in pkgshare/libexec
    assert_match(/github-pat/, shell_output("#{bin}/ai-trace scrub-rules"))
  end
end
