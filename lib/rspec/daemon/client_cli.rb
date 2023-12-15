require_relative '../daemon'

module RSpec
  class Daemon
    class ClientCli
      DEFAULT_OPTIONS = {
        host: "localhost",
        port: 3002,
      }

      def self.start(...)
        new.start(...)
      end

      def start(argv)
        options = DEFAULT_OPTIONS.dup
        option_parser = OptionParser.new do |opts|
          opts.on('-v', '--version', 'Prints version') do
            puts RSpec::Daemon::VERSION
            exit
          end

          opts.on('-h', '--host HOST', 'rspec-daemon host (default: localhost)') do |host|
            options[:host] = host
          end

          opts.on('-p', '--port PORT', 'rspec-daemon port (default: 3002)') do |port|
            options[:port] = port
          end
        end
        option_parser.parse!(argv)
        # Send all other arguments to rspec via the daemon
        command = argv.join(' ') + "\n"

        begin
          # Open connection to rspec-daemon
          socket = TCPSocket.open(options[:host], options[:port])
          socket.write(command)
          while line = socket.gets # rubocop:disable Lint/AssignmentInCondition
            print line
          end
          socket.close
        rescue Errno::ECONNREFUSED => e
          STDERR.puts "Failed to connect to #{options[:host]}:#{options[:port]} (#{e})"
          return 1
        end

        0
      end
    end
  end
end
