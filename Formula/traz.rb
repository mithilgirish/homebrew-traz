class Traz < Formula
  desc "A local-first engineering memory layer and MCP server for AI coding tools"
  homepage "https://traz.mithilgirish.dev"
  version "0.1.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/mithilgirish/traz/releases/download/v0.1.0/traz-aarch64-apple-darwin.tar.xz"
    sha256 "a8de60f9dce523634557c0875a6504019006269034196b3686e8971884d57813"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/mithilgirish/traz/releases/download/v0.1.0/traz-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f0b5b9f39e97df2d23dec1a5d4aef4ab0d7652f82296a26633d22a35fc5f8696"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mithilgirish/traz/releases/download/v0.1.0/traz-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "1d4e04e5c1f091b37d8bebc8afcdf0a0c14f02f21fc43dc5879526e6123d0da2"
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
