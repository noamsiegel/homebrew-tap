class AiTrace < Formula
  desc "Capture AI coding session transcripts (Claude Code / Codex) as secret gists linked from GitHub PRs"
  homepage "https://github.com/noamsiegel/ai-trace"
  url "https://github.com/noamsiegel/ai-trace/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "dd6f1965b726bdfa7737ef669330463391b0e9e826c01ee4bd53e93207adfddb"
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
    assert_match(/ai-trace/, shell_output("#{bin}/ai-trace --help"))
  end
end
