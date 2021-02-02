# frozen_string_literal: true

require_relative './utils'

module Brew
  # Comprehensive list of commonly used and useful packages
  PACKAGES = %w(
    bash
    bash-completion2
    tmux
    vim
    neovim
    git
    reattach-to-user-namespace
    ripgrep
    python3
    ruby
    go
    openssl
    pkg-config
    htop
    ffmpeg
    coreutils
    fzf
    mosh
  )

  # Packages I can't live without. Note, this install is made for spin, which
  # already has the basics like tmux and git installed.
  LIGHT_PACKAGES = %w(
    neovim
    ripgrep
    htop
  )

  # Casks to be installed on Mac
  CASKS = %w(
    slack-beta
    iterm2-beta
    google-chrome-beta
  )
  private_constant(:PACKAGES, :LIGHT_PACKAGES, :CASKS)

  class << self
    def setup(light_install:)
      if Utils.cmd_exists?("brew")
        puts "Skipping brew"
      else
        Utils.run_cmd('/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"')

        if Utils.darwin?
          # non-darwin setups assumed to be headless
          CASKS.each do |cask|
            Utils.run_cmd("brew install #{cask} --cask")
          end
        end

        # Run on both darwin and linux
        if light_install
          LIGHT_PACKAGES.each do |package|
            Utils.run_cmd("brew install #{package}")
          end
        else
          PACKAGES.each do |package|
            Utils.run_cmd("brew install #{package}")
          end
        end
      end
    end
  end
end

Brew.setup(light_install: true)
