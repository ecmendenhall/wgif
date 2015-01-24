require 'wgif/exceptions'

module WGif
  class Validator
    URL = %r{\Ahttps?://.*\z}
    TIMESTAMP = /\A\d{1,2}(?::\d{2})+(?:\.\d*)?\z/

    def initialize(args)
      @args = args
    end

    def validate
      fail WGif::InvalidUrlException unless args[:url] =~ URL
      fail WGif::InvalidTimestampException unless args[:trim_from] =~ TIMESTAMP
      fail WGif::MissingOutputFileException unless args[:output]
    end

    private

    attr_reader :args
  end
end
