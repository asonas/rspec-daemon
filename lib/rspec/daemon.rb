# frozen_string_literal: true

require_relative "daemon/version"
require_relative "daemon/configuration"

require "socket"
require "stringio"
require "rspec"

module RSpec
  class Daemon
    SCRIPT_NAME = File.basename(__FILE__).freeze
    RSPEC_DAEMON_DEFAULT_PORT = 3002

    class Error < StandardError; end

    def self.start
      self.new.start
    end

    def start
      entry_point
    end

    def entry_point
      $LOAD_PATH << "./spec"

      RSpec::Core::Runner.disable_autorun!
      server = TCPServer.open("0.0.0.0", ENV.fetch("RSPEC_DAEMON_PORT", RSPEC_DAEMON_DEFAULT_PORT))
      puts "Listening on port #{server.addr[1]}"

      loop do
        handle_request(server.accept)
      rescue Interrupt
        puts "quit"
        server.close
        break
      end
    end

    def handle_request(socket)
      status, out = run(socket.read)

      socket.puts(status)
      socket.puts(out)
      puts out
      socket.puts(__FILE__)
    rescue StandardError => e
      socket.puts e.full_message
    ensure
      socket.close
    end

    def run(msg, options = [])
      options += ["--force-color", "--format", "documentation"]
      argv = msg.split(" ")

      reset
      out = StringIO.new
      status = RSpec::Core::Runner.run(options + argv, out, out)

      [status, out.string]
    end

    def reset
      RSpec::Core::Configuration.class_eval { define_method(:command) { "rspec" } }
      RSpec::Core::Runner.disable_autorun!
      RSpec.reset

      if cached_config.has_recorded_config?
        cached_config.replay_configuration
      else
        cached_config.record_configuration(&rspec_configuration)
      end
    end

    def rspec_configuration
      proc do
        if File.exist? "spec/rails_helper.rb"
          require "rails_helper"
        end
      end
    end

    def cached_config
      @cached_config ||= RSpec::Daemon::Configuration.new
    end

    RSpec::Core::BacktraceFormatter.class_eval do
      def format_backtrace(backtrace, options = {})
        return [] unless backtrace
        return backtrace if options[:full_backtrace] || backtrace.empty?

        backtrace.map { |l| backtrace_line(l) }.compact.inject([]) do |result, line|
          break result if line.include?(SCRIPT_NAME)

          result << line
        end
      end
    end
  end
end
