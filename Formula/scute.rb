class Scute < Formula
  desc "Deterministic fitness checks for your codebase"
  homepage "https://github.com/scute-sh/scute"
  version "0.0.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/scute-sh/scute/releases/download/scute-v0.0.3/scute-aarch64-apple-darwin.tar.xz"
      sha256 "c677ce61cd225ffa326e67d2e34b6965669e7f8cafce84a65c4be3596da024d4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/scute-sh/scute/releases/download/scute-v0.0.3/scute-x86_64-apple-darwin.tar.xz"
      sha256 "44022ce049ffdd0adb17787623dce55e5e5199ce269559d5f156ce133ec81192"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/scute-sh/scute/releases/download/scute-v0.0.3/scute-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "39181a7c4cedadce3d873af70e73a9f813f47488452a36aac148349e14371e1c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/scute-sh/scute/releases/download/scute-v0.0.3/scute-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "5fe19839c6e976e23736ed3573ce93d724d6ce41bfd392cbc6ebea1f2dd0a6dd"
    end
  end
  license "Apache-2.0"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
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
