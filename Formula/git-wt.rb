class GitWt < Formula
  desc "Parallel-safe git worktree CLI for agentic coding sessions"
  homepage "https://github.com/noamsiegel/git-wt"
  url "https://github.com/noamsiegel/git-wt/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "c4010aa17adcfb71eab6ddd5321bcea52606156a2c44f88a8dae2c81f85244b6"
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
