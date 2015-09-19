require 'date'
require 'logger'
require 'pathname'

require 'rspec/log_split/handler'
require 'rspec/log_split/config'

module RSpec
  module LogSplit
    class << self

      def apply
        RSpec.configure do |config|
          config.add_setting :log_split_module
          config.add_setting :log_split_dir
          config.add_setting :log_split

          config.before(:suite) do
            RSpec.configuration.log_split= Config.new(
              RSpec.configuration.log_split_module,
              RSpec.configuration.log_split_dir,
            )
          end

          config.around(:each) do |example|
            RSpec.configuration.log_split.run(example)
          end

          config.after(:suite) do
            Handler.list_logs if $DEBUG
          end
        end
      end
    end
  end
end

RSpec::LogSplit.apply
