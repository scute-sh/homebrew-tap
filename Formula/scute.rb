class Scute < Formula
  desc "Deterministic fitness checks for your codebase"
  homepage "https://github.com/scute-sh/scute"
  version "0.0.18"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/scute-sh/scute/releases/download/scute-v0.0.18/scute-aarch64-apple-darwin.tar.xz"
      sha256 "2cb14cc396d02f0d8c071b9026d7a471a420dcd9225a5fd27ad1535bdef5a9cc"
    end
    if Hardware::CPU.intel?
      url "https://github.com/scute-sh/scute/releases/download/scute-v0.0.18/scute-x86_64-apple-darwin.tar.xz"
      sha256 "8907f5bd4d4d313863a1268d765f3b03041ecc09e99ea1452adad3f81e0b7eac"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/scute-sh/scute/releases/download/scute-v0.0.18/scute-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "230d7b4f309f820fbda9c7cdcebc5ab4bfec5c6d753fbb6efbdbedc544bb8238"
    end
    if Hardware::CPU.intel?
      url "https://github.com/scute-sh/scute/releases/download/scute-v0.0.18/scute-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d65fc1611c994b34e2cff8b06adabf9dd861eb83976fa5da2f93c70a3e10254f"
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
