class Tmexclude < Formula
  desc "Exclude files from Time Machine backups"
  homepage "https://github.com/Coder-256/tmexclude"
  url "https://github.com/Coder-256/tmexclude/archive/refs/tags/1.0.0.tar.gz"
  sha256 "a29ddfd4ee73ff122ee58c7332c543d18165d2bfd028322a0180cde05b7a51f1"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/Coder-256/tmexclude.git", branch: "master"

  depends_on xcode: ["13", :build]
  depends_on macos: :catalina

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release"
    bin.install ".build/release/#{name}"
  end

  test do
    (testpath/"foo.txt").write "Hello, world!"
    system bin/"tmexclude", "-e", testpath/"foo.txt"
    output = shell_output("/usr/bin/xattr #{testpath}/foo.txt")
    asssert_match "com.apple.metadata:com_apple_backup_excludeItem", output
    system bin/"tmexclude", "-i", testpath/"foo.txt"
    output = shell_output("/usr/bin/xattr #{testpath}/foo.txt")
    asssert_not_match "com.apple.metadata:com_apple_backup_excludeItem", output
  end
end
