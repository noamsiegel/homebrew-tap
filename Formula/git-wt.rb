class GitWt < Formula
  desc "Parallel-safe git worktree CLI for agentic coding sessions"
  homepage "https://github.com/noamsiegel/git-wt"
  url "https://github.com/noamsiegel/git-wt/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "c5dbae7f83a987e63e939f8d2929f46e5eb6e1c1708a23ab013194aafd81c200"
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
