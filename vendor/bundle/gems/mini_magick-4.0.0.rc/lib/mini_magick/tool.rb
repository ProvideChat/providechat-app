require "mini_magick/shell"

module MiniMagick
  ##
  # Abstract class that wraps command-line tools. It shouldn't be used directly,
  # but through one of its subclasses (e.g. {MiniMagick::Tool::Mogrify}). Use
  # this class if you want to be closer to the metal and execute ImageMagick
  # commands directly, but still with a nice Ruby interface.
  #
  # @example
  #   MiniMagick::Tool::Mogrify.new do |builder|
  #     builder.resize "500x500"
  #     builder << "path/to/image.jpg"
  #   end
  #
  class Tool

    autoload :Animate,   "mini_magick/tool/animate"
    autoload :Compare,   "mini_magick/tool/compare"
    autoload :Composite, "mini_magick/tool/composite"
    autoload :Conjure,   "mini_magick/tool/conjure"
    autoload :Convert,   "mini_magick/tool/convert"
    autoload :Display,   "mini_magick/tool/display"
    autoload :Identify,  "mini_magick/tool/identify"
    autoload :Import,    "mini_magick/tool/import"
    autoload :Mogrify,   "mini_magick/tool/mogrify"
    autoload :Montage,   "mini_magick/tool/montage"
    autoload :Stream,    "mini_magick/tool/stream"

    # @private
    def self.inherited(child)
      child_name = child.name.split("::").last.downcase
      child.send :include, MiniMagick::Tool::OptionMethods.new(child_name)
    end

    ##
    # Aside from classic instantiation, it also accepts a block, and then
    # executes the command in the end.
    #
    # @example
    #   version = MiniMagick::Tool::Identify.new { |b| b.version }
    #   puts version
    #
    # @return [MiniMagick::Tool, String] If no block is given, returns an
    #   instance of the tool, if block is given, returns the output of the
    #   command.
    #
    def self.new(*args)
      instance = super(*args)

      if block_given?
        yield instance
        instance.call
      else
        instance
      end
    end

    # @private
    attr_reader :name, :args

    def initialize(name)
      @name = name
      @args = []
    end

    ##
    # Executes the command that has been built up.
    #
    # @example
    #   mogrify = MiniMagick::Tool::Mogrify.new
    #   mogrify.resize("500x500")
    #   mogrify << "path/to/image.jpg"
    #   mogirfy.call # executes `mogrify -resize 500x500 path/to/image.jpg`
    #
    # @param whiny [Boolean] Whether you want an error to be raised when
    #   ImageMagick returns an exit code of 1. You may want this because
    #   some ImageMagick's commands (`identify -help`) return exit code 1,
    #   even though no error happened.
    #
    # @return [String] Output of the command
    #
    def call(whiny = true)
      shell = MiniMagick::Shell.new(whiny)
      shell.run(command).strip
    end

    ##
    # The currently built-up command.
    #
    # @return [Array<String>]
    #
    # @example
    #   mogrify = MiniMagick::Tool::Mogrify.new
    #   mogrify.resize "500x500"
    #   mogrify.contrast
    #   mogrify.command #=> ["mogrify", "-resize", "500x500", "-contrast"]
    #
    def command
      [*executable, *args]
    end

    ##
    # The executable used for this tool. Respects
    # {MiniMagick::Configuration#cli} and {MiniMagick::Configuration#cli_path}.
    #
    # @return [Array<String>]
    #
    # @example
    #   MiniMagick.configure { |config| config.cli = :graphicsmagick }
    #   identify = MiniMagick::Tool::Identify.new
    #   identify.executable #=> ["gm", "identify"]
    #
    def executable
      exe = [name]
      exe.unshift "gm" if MiniMagick.graphicsmagick?
      exe.unshift File.join(MiniMagick.cli_path, exe.shift) if MiniMagick.cli_path
      exe
    end

    ##
    # Appends raw options, useful for appending image paths.
    #
    # @return [self]
    #
    def <<(arg)
      args << arg.to_s
      self
    end

    ##
    # Changes the last operator to its "plus" form.
    #
    # @example
    #   mogrify = MiniMagick::Tool::Mogrify.new
    #   mogrify.antialias.+
    #   mogrify.distort.+("Perspective '0,0,4,5'")
    #   mogrify.command #=> ["mogrify", "+antialias", "+distort", "Perspective '0,0,4,5'"]
    #
    # @return [self]
    #
    def +(value = nil)
      args.last.sub!(/^-/, '+')
      args << value.to_s if value
      self
    end

    private

    ##
    # Dynamically generates modules with dynamically generated option methods
    # for each command-line tool. It uses the `-help` page of a command-line
    # tool and generates methods from it. It then includes the generated
    # module into the tool class.
    #
    # @private
    #
    class OptionMethods < Module

      def self.instances
        @instances ||= []
      end

      def self.new(*args, &block)
        super.tap do |instance|
          self.instances << instance
        end
      end

      def initialize(tool_name)
        super() do
          @tool_name = tool_name
          reload_methods
        end
      end

      ##
      # Dynamically generates operator methods from the "-help" page.
      #
      def reload_methods
        instance_methods(false).each { |method| undef_method(method) }

        self.creation_operator *%w[xc canvas logo rose gradient radial-gradient
                                   plasma tile pattern label caption text]

        help = (MiniMagick::Tool.new(@tool_name) << "-help").call(false)
        cli_options = help.scan(/^\s+-[a-z\-]+/).map(&:strip)
        self.option *cli_options
      end

      ##
      # Creates method based on command-line option's name.
      #
      #  mogrify = MiniMagick::Tool.new("mogrify")
      #  mogrify.antialias
      #  mogrify.depth(8)
      #  mogrify.resize("500x500")
      #  mogirfy.command.join(" ") #=> "mogrify -antialias -depth "8" -resize "500x500""
      #
      def option(*options)
        options.each do |option|
          define_method(option[1..-1].gsub('-', '_')) do |value = nil|
          self << option
          self << value.to_s if value
          self
          end
        end
      end

      ##
      # Creates method based on creation operator's name.
      #
      #   mogrify = MiniMagick::Tool.new("mogrify")
      #   mogrify.canvas("khaki")
      #   mogrify.command.join(" ") #=> "mogrify canvas:khaki"
      #
      def creation_operator(*operators)
        operators.each do |operator|
          define_method(operator.gsub('-', '_')) do |value = nil|
            self << "#{operator}:#{value}"
            self
          end
        end
      end

      def to_s
        "OptionMethods(#{@tool_name})"
      end

    end

  end
end
