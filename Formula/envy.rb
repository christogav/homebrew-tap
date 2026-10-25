class Envy < Formula
  desc "Load Keychain secrets and variables into your current zsh shell, by namespace"
  homepage "https://github.com/christogav/envy"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/christogav/envy/releases/download/v0.2.0/envy-aarch64-apple-darwin.tar.xz"
      sha256 "6243bdef2feee71b3bf26e3b6cdacd10dbf9d74349cf187f6d1b10a009cdf8cd"
    end
    if Hardware::CPU.intel?
      url "https://github.com/christogav/envy/releases/download/v0.2.0/envy-x86_64-apple-darwin.tar.xz"
      sha256 "354f77799157d471b9e9bb3866a522273f6a0bf8d3c00a22621097fc11bb0509"
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
