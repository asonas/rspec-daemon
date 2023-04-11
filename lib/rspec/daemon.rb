# frozen_string_literal: true

require_relative "daemon/version"

require 'socket'
require 'stringio'

module Rspec
  module Daemon
    SCRIPT_NAME = File.basename(__FILE__).freeze

    class Error < StandardError; end

    def start
      entry_point
    end

    def entry_point
      RSpec::Core::Runner.disable_autorun!
      server = TCPServer.open('0.0.0.0', 3002)

      loop do
        handle_request(server.accept)
      rescue Interrupt
        puts 'quit'
        server.close
        break
      end
    end

    def handle_request(socket)
      status, out = run(socket.read)

      socket.puts(status)
      socket.puts(out)
      socket.puts(__FILE__)
    rescue StandardError => e
      socket.puts e.full_message
    ensure
      socket.close
    end

    def run(msg, options = [])
      options += ['--force-color']
      argv = msg.split(' ')

      RSpec.reset
      out = StringIO.new
      status = RSpec::Core::Runner.run(options + argv, out, out)

      [status, out.string]
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

