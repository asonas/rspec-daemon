require_relative '../daemon'

module RSpec
  class Daemon
    class Cli
      def self.start
        RSpec::Daemon.start
      end
    end
  end
end
