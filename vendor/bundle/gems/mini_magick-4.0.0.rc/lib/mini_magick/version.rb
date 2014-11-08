module MiniMagick
  ##
  # @return [Gem::Version]
  #
  def self.version
    Gem::Version.new VERSION::STRING
  end

  module VERSION
    MAJOR = 4
    MINOR = 0
    TINY  = 0
    PRE   = "rc"

    STRING = [MAJOR, MINOR, TINY, PRE].compact.join('.')
  end
end
