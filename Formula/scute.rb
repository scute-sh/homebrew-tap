class Scute < Formula
  desc "Deterministic fitness checks for your codebase"
  homepage "https://github.com/scute-sh/scute"
  version "0.0.14"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/scute-sh/scute/releases/download/scute-v0.0.14/scute-aarch64-apple-darwin.tar.xz"
      sha256 "fffc2c1e6bce526e81ac8dce57c8c6db027123c797367f330965cf5d2bd4dc35"
    end
    if Hardware::CPU.intel?
      url "https://github.com/scute-sh/scute/releases/download/scute-v0.0.14/scute-x86_64-apple-darwin.tar.xz"
      sha256 "d747d1af3b28e0223a229bdf06930e61b45b0fc7ac32a49ddcc359c2819d84d2"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/scute-sh/scute/releases/download/scute-v0.0.14/scute-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "0f6691b95b99b86359d57f307f514c00b40fcd443386326702aeeafcaeb37176"
    end
    if Hardware::CPU.intel?
      url "https://github.com/scute-sh/scute/releases/download/scute-v0.0.14/scute-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "37b8f3fa0ff3a25cca4bf619e08fadc7d3e43ae587fb0c73a81b2983c512c82f"
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
    bin.install "scute" if OS.mac? && Hardware::CPU.arm?
    bin.install "scute" if OS.mac? && Hardware::CPU.intel?
    bin.install "scute" if OS.linux? && Hardware::CPU.arm?
    bin.install "scute" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
