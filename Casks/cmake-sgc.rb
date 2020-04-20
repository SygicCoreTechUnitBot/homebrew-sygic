cask 'cmake-sgc' do
  version '3.16.6'
  sha256 '612b5cf7427966e28a9afc43996b587465a4dc88b8fa24a7515fd6896acb4e78'

  url "https://www.cmake.org/files/v#{version.major_minor}/cmake-#{version}-Darwin-x86_64.dmg"
  appcast 'https://cmake.org/files/v3.16/'
  name 'CMake'
  homepage 'https://cmake.org/'

  conflicts_with formula: 'cmake',
                 cask: 'cmake'

  app 'CMake.app'
  binary "#{appdir}/CMake.app/Contents/bin/cmake"
  binary "#{appdir}/CMake.app/Contents/bin/ccmake"
  binary "#{appdir}/CMake.app/Contents/bin/cpack"
  binary "#{appdir}/CMake.app/Contents/bin/ctest"
  binary "#{appdir}/CMake.app/Contents/bin/cmake-gui"
end
