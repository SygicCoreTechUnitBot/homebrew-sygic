class SccacheSgc < Formula
  desc "Used as a compiler wrapper and avoids compilation when possible"
  homepage "https://github.com/mozilla/sccache"
  url "https://repository.sygic.com/repository/maven-sygic-3rdparty/org/mozilla/sccache/sccache/0.2.7_1-sgc/sccache-0.2.7_1-sgc.tar.gz"
  sha256 "a90e420b60e7c44b8880ec62cb97d80ee667b097fa496cab6c814c47a4dd79f0"

  bottle do
    root_url "https://repository.sygic.com/repository/raw-sygic-3rdparty/homebrew/bottles/"
    sha256 cellar: :any_skip_relocation, mojave: "cb342857f4c1b620e4bc701265a8f51a211d832fcbae83ca11aa193cd4c3c849"
  end

  depends_on "rust" => :build
  depends_on "openssl@1.1"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    # https://crates.io/crates/openssl#manual-configuration
    ENV["OPENSSL_DIR"] = Formula["openssl"].opt_prefix

    system "cargo", "install", "--root", prefix, "--path", ".",
                               "--features", "all"
  end

  #plist_options :startup => true
  
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

  service do
    require_root true
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
