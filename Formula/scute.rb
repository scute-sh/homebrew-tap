class Scute < Formula
  desc "Deterministic fitness checks for your codebase"
  homepage "https://github.com/scute-sh/scute"
  version "0.0.15"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/scute-sh/scute/releases/download/scute-v0.0.15/scute-aarch64-apple-darwin.tar.xz"
      sha256 "78486e423300767ef06bcbdc55eee110c2c4bf4a3cf2b3c21451e6b198068203"
    end
    if Hardware::CPU.intel?
      url "https://github.com/scute-sh/scute/releases/download/scute-v0.0.15/scute-x86_64-apple-darwin.tar.xz"
      sha256 "0ccba892aac54b2655cb559745988628823b7a186ba372d13b13022b32cf422d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/scute-sh/scute/releases/download/scute-v0.0.15/scute-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "b4460e4e7371e14f494d4c71cfa7ba7d8f434b7b85a6bb9e7ae30e66314692a8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/scute-sh/scute/releases/download/scute-v0.0.15/scute-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "3c0d3722e12cfab1423a121f66c2d147cbe317b733aec556330cc212ad6509e2"
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
