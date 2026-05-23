class GitWt < Formula
  desc "Parallel-safe git worktree CLI for agentic coding sessions"
  homepage "https://github.com/noamsiegel/git-wt"
  url "https://github.com/noamsiegel/git-wt/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "6eda89902a818eccaae0b4f3c564c4f7e74b0d1b045cdd2942e4e1522542167c"
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
