class AgentsTrace < Formula
  desc "Capture AI coding session transcripts as PR-linked gists"
  homepage "https://github.com/noamsiegel/agents-trace"
  url "https://github.com/noamsiegel/agents-trace/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "92881f6e5da60fb858de05ff40075653cf2e374632358d0870845aa48842b94a"
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
