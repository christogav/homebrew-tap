class Envy < Formula
  desc "Load Keychain secrets and variables into your current zsh shell, by namespace"
  homepage "https://github.com/christogav/envy"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/christogav/envy/releases/download/v0.1.0/envy-aarch64-apple-darwin.tar.xz"
      sha256 "f5bd44a0dbcc01bff7248e6c345adac0fd6c33bd26a37fe18a09745581e20bd5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/christogav/envy/releases/download/v0.1.0/envy-x86_64-apple-darwin.tar.xz"
      sha256 "b147bcbd27f099fb2530992c4d8f62406eb18a2790c979cc9dfac14b2a8b03a5"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin": {},
    "x86_64-apple-darwin":  {},
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
      bin.install "envy"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "envy"
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
