require_relative '../daemon'

module Rspec
  class Daemon
    class Cli
      def start
        Rspec::Daemon.start
      end
    end
  end
end
