class Scute < Formula
  desc "Deterministic fitness checks for your codebase"
  homepage "https://github.com/scute-sh/scute"
  version "0.0.17"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/scute-sh/scute/releases/download/scute-v0.0.17/scute-aarch64-apple-darwin.tar.xz"
      sha256 "eaa84f630ca1feae6f6cb6c6749e00fdb1ac0d5df17af46eb8c1e7fa0fee2547"
    end
    if Hardware::CPU.intel?
      url "https://github.com/scute-sh/scute/releases/download/scute-v0.0.17/scute-x86_64-apple-darwin.tar.xz"
      sha256 "58dec19d38ac4d369e541f5d302911a634b9dd0fe98b297527dc22c0679440b4"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/scute-sh/scute/releases/download/scute-v0.0.17/scute-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "7ac8e2b81808766c0ed8b291d5da4ad36f3c4c1a8f2b45b30b011082923ca9db"
    end
    if Hardware::CPU.intel?
      url "https://github.com/scute-sh/scute/releases/download/scute-v0.0.17/scute-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "51789b6ac8756c9e208ce0555deb12d32ea47ae88c1b32312bfa79af13209a41"
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
