class GitWt < Formula
  desc "Parallel-safe git worktree CLI for agentic coding sessions"
  homepage "https://github.com/noamsiegel/git-wt"
  url "https://github.com/noamsiegel/git-wt/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "d10961ef645754594f5d58783e8081ce2ead4c4abe54ad89ae1afbf361984139"
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
