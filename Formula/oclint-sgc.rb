class OclintSgc < Formula
  desc "OCLint static code analysis tool for C, C++, and Objective-C"
  homepage "http://oclint.org"
  version '0.15'
  sha256 '217fd7a9390b809f911c618a8efb73d49fc9ecb6ff0720fc548c8f9c353a9147'
  url "https://repository.sygic.com/repository/maven-sygic-3rdparty/org/oclint/oclint-sgc/#{version}/oclint-sgc-#{version}-x86_64-darwin18.7.0.tar.gz"
  head "https://github.com/oclint/oclint.git"

  def install
    clang_version = '9.0.1'

    include.install Dir['include/c++'] unless File.directory? "#{include}/c++"
    "#{include}/c++".install Dir['include/c++/v1'] unless File.directory? "#{include}/c++/v1"
    lib.install Dir['lib/clang'] unless File.directory? "#{lib}/clang"
    "#{lib}/clang".install Dir['lib/clang/#{clang_version}'] unless File.directory? "#{lib}/clang/#{clang_version}"
    lib.install Dir['lib/oclint']
    bin.install Dir['bin/*']
  end

  test do
    system "#{bin}/oclint", "-version"
  end
end
