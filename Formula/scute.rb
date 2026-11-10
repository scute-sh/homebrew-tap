class Scute < Formula
  desc "Deterministic fitness checks for your codebase"
  homepage "https://github.com/scute-sh/scute"
  version "0.0.19"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/scute-sh/scute/releases/download/scute-v0.0.19/scute-aarch64-apple-darwin.tar.xz"
      sha256 "69f21420dab11bc73292ba69c5623f57e69b4f10599b272c712ed8afe489ffc1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/scute-sh/scute/releases/download/scute-v0.0.19/scute-x86_64-apple-darwin.tar.xz"
      sha256 "ce761c9fa7b2e7b5ab189fb062a9102f315d2693b8104d9920e3143bd11e13ad"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/scute-sh/scute/releases/download/scute-v0.0.19/scute-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "96958870043d12394757be2ede31ee889e8e41adea5c0d0b28c3d9597a0b19bd"
    end
    if Hardware::CPU.intel?
      url "https://github.com/scute-sh/scute/releases/download/scute-v0.0.19/scute-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6f552f22592a48e8c08d7765d492ff88d7b252bfb02811bfef260ff9daf3b6a5"
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
