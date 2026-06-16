class Traz < Formula
  desc "A local-first engineering memory layer and MCP server for AI coding tools"
  homepage "https://traz.mithilgirish.dev"
  version "0.1.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/mithilgirish/traz/releases/download/v0.1.0/traz-aarch64-apple-darwin.tar.xz"
    sha256 "19e0fe2e7f0731a791f1b8ad68fb6d773a580d7396e9ca432a066fdc45c0eef2"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/mithilgirish/traz/releases/download/v0.1.0/traz-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "3fc05e9d544298b946dbc90dc3a5b2efd30f29610a4c811f1e23c2196c366b1c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mithilgirish/traz/releases/download/v0.1.0/traz-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d2cac4b3380be8e86181147562374ed82a3c0907e5da5f5b92dd5ca1585b587e"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
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
    bin.install "traz" if OS.mac? && Hardware::CPU.arm?
    bin.install "traz" if OS.linux? && Hardware::CPU.arm?
    bin.install "traz" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
