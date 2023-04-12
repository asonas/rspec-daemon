module RSpec
  class Daemon
    class Configuration
      attr_accessor :config_proxy, :root_shared_examples

      class RecordingProxy < Struct.new(:target, :recorded_messages)
        [:include, :extend].each do |method|
          define_method(method) do |*args|
            method_missing(method, *args)
          end
        end

        def method_missing(method, *args, &block)
          self.recorded_messages << [method, args, block]
          self.target.send(method, *args, &block)
        end
      end

      def record_configuration(&configuration_block)
        ensure_configuration_setter!

        original_config = ::RSpec.configuration
        RSpec.configuration = RecordingProxy.new(original_config, [])

        configuration_block.call # spec helper is called during this yield, see #reset

        self.config_proxy = ::RSpec.configuration
        RSpec.configuration = original_config

        forward_rspec_config_singleton_to(self.config_proxy)
      end

      def replay_configuration
        RSpec.configure do |config|
          self.config_proxy.recorded_messages.each do |method, args, block|
            # reporter caches config.output_stream which is not good as it
            # prevents the runner to use a custom stdout.
            next if method == :reporter

            config.send(method, *args, &block)
          end
        end

        forward_rspec_config_singleton_to(self.config_proxy)
      end

      def has_recorded_config?
        !!self.config_proxy
      end

      def forward_rspec_config_singleton_to(config_proxy)
        # an old version of rspec-rails/lib/rspec/rails/view_rendering.rb adds
        # methods on the configuration singleton. This takes care of that.
        RSpec.configuration.singleton_class
          .send(:define_method, :method_missing, &config_proxy.method(:send))
      end

      def ensure_configuration_setter!
        return if RSpec.respond_to?(:configuration=)

        RSpec.instance_eval do
          def self.configuration=(value)
            @configuration = value
          end
        end
      end
    end
  end
end
