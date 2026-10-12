class AgentsTrace < Formula
  desc "Capture AI coding session transcripts as PR-linked gists"
  homepage "https://github.com/noamsiegel/agents-trace"
  url "https://github.com/noamsiegel/agents-trace/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "3c38f4ed6113370244cb94c14fb15b874502396aaf0c7eeb1780738a17b7c508"
  license "MIT"
  head "https://github.com/noamsiegel/agents-trace.git", branch: "main"

  depends_on "oven-sh/bun/bun"
  depends_on "gh"
  depends_on "gitleaks"

  def install
    libexec.install "cli.ts", "package.json", "src"
    (bin / "agents-trace").write <<~SH
      #!/usr/bin/env bash
      exec #{formula_opt_bin("bun")}/bun #{libexec}/cli.ts "$@"
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
