class AgentsTrace < Formula
  desc "Capture AI coding session transcripts as PR-linked gists"
  homepage "https://github.com/noamsiegel/agents-trace"
  url "https://github.com/noamsiegel/agents-trace/archive/refs/tags/v0.12.1.tar.gz"
  sha256 "7ce45fb7311d3be03be0b561ea922d611b50542da47e79496819bcb46d56b434"
  license "MIT"
  head "https://github.com/noamsiegel/agents-trace.git", branch: "main"

  depends_on "gh"
  depends_on "gitleaks"
  depends_on "oven-sh/bun/bun"

  def install
    system formula_opt_bin("bun")/"bun", "install", "--production", "--frozen-lockfile"
    system formula_opt_bin("bun")/"bun", "run", "build"
    libexec.install "dist/cli.js"
    libexec.install "node_modules/acorn/LICENSE" => "acorn-LICENSE"
    (bin / "agents-trace").write <<~SH
      #!/usr/bin/env bash
      exec #{formula_opt_bin("bun")}/bun --no-install #{libexec}/cli.js "$@"
    SH
    chmod 0755, bin / "agents-trace"
  end

  test do
    # --help check (binary wiring)
    assert_match(/agents-trace/, shell_output("#{bin}/agents-trace --help"))
    # The bundled scrubber command exercises the installed wrapper beyond startup.
    assert_match(/github-pat/, shell_output("#{bin}/agents-trace scrub-rules"))
  end
end
