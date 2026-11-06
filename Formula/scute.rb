class Scute < Formula
  desc "Deterministic fitness checks for your codebase"
  homepage "https://github.com/scute-sh/scute"
  version "0.0.16"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/scute-sh/scute/releases/download/scute-v0.0.16/scute-aarch64-apple-darwin.tar.xz"
      sha256 "b47d523c6465e70f45043e8efca89e6245fcf1a258987de34895604cfc7730b9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/scute-sh/scute/releases/download/scute-v0.0.16/scute-x86_64-apple-darwin.tar.xz"
      sha256 "945fec446630791ce972c63d266f7e59fecb4748e1cdbaf578ed4f80fee5cb8d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/scute-sh/scute/releases/download/scute-v0.0.16/scute-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "585f0dbf2124fb47d136c4e7fa1749ea1ee178eb15f6b64bd2b65759868c635a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/scute-sh/scute/releases/download/scute-v0.0.16/scute-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "3d18cf190560144f72d6ad561ead63213ee80e7afbf24e7ad8932ceb22655679"
    end
  end
  license "Apache-2.0"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":               {},
    "aarch64-unknown-linux-gnu":          {},
    "aarch64-unknown-linux-musl-dynamic": {},
    "aarch64-unknown-linux-musl-static":  {},
    "x86_64-apple-darwin":                {},
    "x86_64-pc-windows-gnu":              {},
    "x86_64-unknown-linux-gnu":           {},
    "x86_64-unknown-linux-musl-dynamic":  {},
    "x86_64-unknown-linux-musl-static":   {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "scute"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "scute"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "scute"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "scute"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
