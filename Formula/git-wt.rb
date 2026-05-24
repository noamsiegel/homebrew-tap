class GitWt < Formula
  desc "Parallel-safe git worktree CLI for agentic coding sessions"
  homepage "https://github.com/noamsiegel/git-wt"
  url "https://github.com/noamsiegel/git-wt/archive/refs/tags/v0.9.4.tar.gz"
  sha256 "50ac62f72519b8f5630483a874db5c0c1b42e66cba0c1d2a3f9fdc3acecee975"
  license "MIT"
  head "https://github.com/noamsiegel/git-wt.git", branch: "main"

  depends_on "bash"
  depends_on "yq"

  def install
    bin.install "git-wt"
    # Convenience alias: `wt` invokes the same binary.
    bin.install_symlink "git-wt" => "wt"
    pkgshare.install Dir["examples/*"] if File.directory?("examples")
    pkgshare.install "plugins-registry.json"
    pkgshare.install "docs" if File.directory?("docs")

    # Point WT_PLUGIN_REGISTRY at the brew-installed registry file so
    # `wt plugin install <name>` resolves bare names without env tinkering.
    inreplace bin / "git-wt", /^WT_PLUGIN_REGISTRY=.*$/,
              "WT_PLUGIN_REGISTRY=\"${WT_PLUGIN_REGISTRY:-#{pkgshare}/plugins-registry.json}\""
  end

  test do
    assert_match(/^wt /, shell_output("#{bin}/git-wt --version"))
    # Verify the registry resolves correctly post-install.
    # `plugin install <unknown>` exits 20 (guardrail) and lists known plugins.
    assert_match(/herdr/, shell_output("#{bin}/git-wt plugin install nonexistent 2>&1", 20))
  end
end
