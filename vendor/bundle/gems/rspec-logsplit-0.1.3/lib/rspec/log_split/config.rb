module RSpec
  module LogSplit
    class Config
      def initialize(mod, dir)
        @mod = mod
        @path = Pathname.new(dir)
        @path.mkpath
        @logger = logger(@path.join("main"))
      end

      def run(example)
        example_path = @path.join(example.location)
        example_path.parent.mkpath
        example_logger = logger(example_path.to_path)
        Handler.new(@logger, @mod, example, example_logger).run
      end

      def logger(path)
        file = File.open(path, "a")
        file.sync = true
        Logger.new(file)
      end
    end
  end
end
