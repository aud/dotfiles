require 'fileutils'

module Dotfiles
  class Setup
    class Symlinks < Dotfiles::Setup
      # Maybe this should be a struct, or anon class to avoid lookup conflicts.
      class Steps
        def vim
        end
      end
      # class << self
      #   def build(runner)
      #     runner.add_step('.vimrc') { vim }
      #     runner.add_step('.tmux.conf') { tmux }
      #     runner.add_step('.system') { system }
      #     runner.add_step('.bash_profile') { bash_profile }
      #     runner.add_step('.bashrc') { bashrc }
      #     runner.add_step('.bash/**/*') { bash }
      #     runner.add_step('.gitconfig') { gitconfig }
      #     runner.add_step('.git_functions/**/*') { git_functions }
      #   end

      #   private

      #   def vim
      #     soft_link('.vimrc', force: true)
      #   end

      #   def tmux
      #     soft_link('.tmux.conf', force: true)
      #   end

      #   def system
      #     soft_link('.system', force: true)
      #   end

      #   def bash_profile
      #     soft_link('.bash_profile', force: true)
      #   end

      #   def bashrc
      #     soft_link('.bashrc', force: true)
      #   end

      #   def gitconfig
      #     soft_link('.gitconfig', force: true)
      #   end

      #   def git_functions
      #     dir = "#{HOME_PATH}/.git_functions"
      #     FileUtils.mkdir(dir) unless Dir.exist?(dir)

      #     Dir.glob("#{ROOT_LIB_PATH}/.git_functions/**/*").each do |file|
      #       # TODO: make soft_link support relative file paths.
      #       file_name = file.split('/')[-2, 2].join('/')
      #       soft_link(file_name, force: true)
      #     end
      #   end

      #   def bash
      #     dir = "#{HOME_PATH}/.bash"
      #     FileUtils.mkdir(dir) unless Dir.exist?(dir)

      #     Dir.glob("#{ROOT_LIB_PATH}/.bash/**/*").each do |file|
      #       # TODO: make soft_link support relative file paths.
      #       file_name = file.split('/')[-2, 2].join('/')
      #       soft_link(file_name, force: true)
      #     end
      #   end

      #   def soft_link(file_name, **options)
      #     FileUtils.ln_s("#{ROOT_LIB_PATH}/#{file_name}", "#{HOME_PATH}/#{file_name}", options)
      #   end
      # end
    end
  end
end
