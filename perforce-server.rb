class PerforceServer < Formula
  desc "Server for the Perforce revision control system"
  homepage "http://www.perforce.com/"
  version "2016.1.1374211"

  if MacOS.prefer_64_bit?
    url "http://filehost.perforce.com/perforce/r16.1/bin.darwin90x86_64/p4d"
    sha256 "c334f984f010e68b43cdbb2402efa4d7d0fd108580030269a0d46e07f0c10711"
  else
    url "http://filehost.perforce.com/perforce/r16.1/bin.darwin90x86/p4d"
    sha256 "210d0535eb68fa9a571302ea8ce171cb549f3cae3c358315defadf1a67e621f2"
  end

  bottle :unneeded

  def install
    bin.install "p4d"
    (var+"p4root").mkpath
  end

  plist_options :startup => true

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_bin}/p4d</string>
        <string>-p</string>
        <string>1666</string>
        <string>-r</string>
        <string>#{var}/p4root</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
      <key>KeepAlive</key>
      <true/>
      <key>WorkingDirectory</key>
      <string>#{var}/p4root</string>
      <key>StandardErrorPath</key>
      <string>#{var}/log/p4d.log</string>
      <key>StandardOutPath</key>
      <string>#{var}/log/p4d.log</string>
    </dict>
    </plist>
    EOS
  end

  test do
    os_tag = (MacOS.prefer_64_bit? ? "P4D/DARWIN90X86_64" : "P4D/DARWIN90X86")
    (version_year, version_minor, version_build) = version.to_s.split(".")
    assert_match(
      %r{#{os_tag}/#{version_year}\.#{version_minor}/#{version_build} },
      shell_output("#{bin}/p4d -V"))
  end
end
