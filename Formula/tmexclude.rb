class Tmexclude < Formula
  desc "Exclude files from Time Machine backups"
  homepage "https://github.com/Coder-256/tmexclude"
  url "https://github.com/Coder-256/tmexclude/archive/refs/tags/1.0.0.tar.gz"
  sha256 "a29ddfd4ee73ff122ee58c7332c543d18165d2bfd028322a0180cde05b7a51f1"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/Coder-256/tmexclude.git", branch: "master"

  bottle do
    root_url "https://github.com/Coder-256/homebrew-tmexclude/releases/download/tmexclude-1.0.0"
    rebuild 1
    sha256 cellar: :any_skip_relocation, big_sur: "8fbc1a2e7085592816f472c12661670b7362a1c86947c299521a618fc9934c85"
  end

  depends_on xcode: ["13", :build]
  depends_on macos: :catalina

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release"
    bin.install ".build/release/#{name}"
  end

  test do
    (testpath/"foo.txt").write "Hello world!"
    system bin/"tmexclude", "-e", testpath/"foo.txt"
    output = shell_output("/usr/bin/xattr #{testpath}/foo.txt")
    assert_match "com.apple.metadata:com_apple_backup_excludeItem", output
    system bin/"tmexclude", "-i", testpath/"foo.txt"
    output = shell_output("/usr/bin/xattr #{testpath}/foo.txt")
    refute_match "com.apple.metadata:com_apple_backup_excludeItem", output
  end
end
