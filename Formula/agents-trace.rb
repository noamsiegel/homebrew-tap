class AgentsTrace < Formula
  desc "Capture AI coding session transcripts as PR-linked gists"
  homepage "https://github.com/noamsiegel/agents-trace"
  url "https://github.com/noamsiegel/agents-trace/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "4368448869396bd92d2b6cb5d9fe7d4cc87d8987da42f590e4282a1b7e4bc11d"
  license "MIT"
  head "https://github.com/noamsiegel/agents-trace.git", branch: "main"

  depends_on "bun"
  depends_on "gh"
  depends_on "gitleaks"

  def install
    libexec.install "cli.ts", "package.json", "src"
    (bin / "agents-trace").write <<~SH
      #!/usr/bin/env bash
      exec #{Formula["bun"].opt_bin}/bun #{libexec}/cli.ts "$@"
    SH
    chmod 0755, bin / "agents-trace"
  end

  test do
    # --help check (binary wiring)
    assert_match(/agents-trace/, shell_output("#{bin}/agents-trace --help"))
    # scrub-rules loads src/core/scrubbers.ts via the cli wrapper; catches missing src/ in pkgshare/libexec
    assert_match(/github-pat/, shell_output("#{bin}/agents-trace scrub-rules"))
  end
end
