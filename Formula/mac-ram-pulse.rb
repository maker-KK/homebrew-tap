class MacRamPulse < Formula
  desc "Menu bar memory & swap monitor with idle-aware build-daemon autopilot"
  homepage "https://github.com/maker-KK/Mac-Ram-Pulse"
  url "https://github.com/maker-KK/Mac-Ram-Pulse/archive/refs/tags/v5.5.0.tar.gz"
  sha256 "d8297e539ce8c3ae2d4fec5cf0ca1aeabba02df46767d4b0e242729df3f47f21"
  license "MIT"
  head "https://github.com/maker-KK/Mac-Ram-Pulse.git", branch: "main"

  depends_on xcode: ["16.0", :build]
  depends_on arch: :arm64
  depends_on macos: :ventura

  def install
    args = %w[--disable-sandbox --configuration release]
    system "swift", "build", *args, "--product", "MacRamPulse"
    bin_path = Utils.safe_popen_read("swift", "build", *args, "--show-bin-path").chomp

    app = prefix/"MacRamPulse.app"
    (app/"Contents/MacOS").install "#{bin_path}/MacRamPulse"
    (app/"Contents").install "Support/Info.plist"

    (bin/"mac-ram-pulse").write <<~SH
      #!/bin/sh
      exec /usr/bin/open "#{opt_prefix}/MacRamPulse.app"
    SH
  end

  service do
    run opt_prefix/"MacRamPulse.app/Contents/MacOS/MacRamPulse"
    run_at_load true
    process_type :interactive
  end

  def caveats
    <<~EOS
      Start now:              mac-ram-pulse
      Start at every login:   brew services start mac-ram-pulse
      Show in /Applications:  ln -sf #{opt_prefix}/MacRamPulse.app /Applications/MacRamPulse.app
    EOS
  end

  test do
    app = prefix/"MacRamPulse.app"
    assert_predicate app/"Contents/MacOS/MacRamPulse", :executable?

    plist = app/"Contents/Info.plist"
    read = ->(key) { shell_output("/usr/libexec/PlistBuddy -c 'Print :#{key}' #{plist}").chomp }
    assert_equal "com.antigravity.MacRamPulse", read.call("CFBundleIdentifier")
    assert_equal version.major_minor.to_s, read.call("CFBundleShortVersionString")
  end
end
