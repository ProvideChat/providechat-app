module RSpec
  module LogSplit
    class Handler
      def initialize(logger, mod, example, example_logger)
        @logger = logger
        @mod = mod
        @example = example
        @example_logger = example_logger
      end

      def run
        @mod.logger = @example_logger
        begin
          error "starting #{description}"
          @example.run
        rescue Exception => e
          error "error with #{description}: #{e.inspect}"
          raise e
        ensure
          error "finishing #{description}"
          @mod.logger = nil
        end
      end

      def description
        @example.full_description
      end

      def error(message)
        @logger.error message
        @mod.logger.error message
      end
    end
  end
end
