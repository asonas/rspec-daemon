require_relative '../daemon'

module RSpec
  class Daemon
    class Cli
      def start
        Rspec::Daemon.start
      end
    end
  end
end
