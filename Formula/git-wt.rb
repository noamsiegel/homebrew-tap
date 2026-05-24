class GitWt < Formula
  desc "Parallel-safe git worktree CLI for agentic coding sessions"
  homepage "https://github.com/noamsiegel/git-wt"
  url "https://github.com/noamsiegel/git-wt/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "1740b02ea445f694881e9369557d426ac13d2ec08fb90d356e31ce0f5f1e18bd"
  license "MIT"
  head "https://github.com/noamsiegel/git-wt.git", branch: "main"

  depends_on "bash"
  depends_on "yq"

  def install
    bin.install "git-wt"
    # Convenience alias: `wt` invokes the same binary.
    bin.install_symlink "git-wt" => "wt"
    pkgshare.install Dir["examples/*"]
  end

  test do
    assert_match(/^wt /, shell_output("#{bin}/git-wt --version"))
  end
end
