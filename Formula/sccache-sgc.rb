class SccacheSgc < Formula
  desc "Used as a compiler wrapper and avoids compilation when possible"
  homepage "https://github.com/mozilla/sccache"
  url "https://repository.sygic.com/repository/maven-sygic-3rdparty/org/mozilla/sccache/sccache/0.2.7_1-sgc/sccache-0.2.7_1-sgc.tar.gz"
  sha256 "496a0264896c6f059982ecac891f4af95b1e207c379b0ce0b926e5cea7c8da4c"

  bottle :unneeded

  depends_on "rust" => :build
  depends_on "openssl@1.1"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    # https://crates.io/crates/openssl#manual-configuration
    ENV["OPENSSL_DIR"] = Formula["openssl"].opt_prefix

    system "cargo", "install", "--root", prefix, "--path", ".",
                               "--features", "all"
  end

  test do
    (testpath/"hello.c").write <<~EOS
      #include <stdio.h>
      int main() {
        puts("Hello, world!");
        return 0;
      }
    EOS
    system "#{bin}/sccache", "cc", "hello.c", "-o", "hello-c"
    assert_equal "Hello, world!", shell_output("./hello-c").chomp
  end
end
