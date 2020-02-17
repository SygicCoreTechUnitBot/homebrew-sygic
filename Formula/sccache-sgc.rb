class SccacheSgc < Formula
  desc "Used as a compiler wrapper and avoids compilation when possible"
  homepage "https://github.com/mozilla/sccache"
  url "https://repository.sygic.com/repository/maven-sygic-3rdparty/org/mozilla/sccache/sccache/0.2.7-sgc.1/sccache-0.2.7-sgc.1.tar.gz"
  sha256 "c9f3d100cf8073a68b761583a276b18be007939d1ae429119abec61b787c1401"

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

  plist_options :startup => true

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>KeepAlive</key>
          <dict>
            <key>SuccessfulExit</key>
              <false/>
            <key>Crashed</key>
              <true/>
          </dict>
        <key>Label</key>
          <string>>#{plist_name}</string>
        <key>ProgramArguments</key>
          <array>
            <string>sh</string>
            <string>-c</string>
            <string>launchctl setenv SCCACHE_START_SERVER 1; launchctl setenv SCCACHE_NO_DAEMON 1; launchctl setenv SCCACHE_SERVER_PORT 9000; launchctl setenv SCCACHE_IDLE_TIMEOUT 0; /usr/local/bin/sccache</string>
          </array>
        <key>RunAtLoad</key>
          <true/>
        <key>WorkingDirectory</key>
          <string>/usr/local/var</string>
        <key>StandardErrorPath</key>
          <string>/usr/local/var/log/sccache-error.log</string>
        <key>StandardOutPath</key>
          <string>/usr/local/var/log/sccache-out.log</string>
      </dict>
    </plist>
  EOS
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
