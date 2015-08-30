require 'wgif/exceptions'

module WGif
  class Validator
    TIMESTAMP = /\A\d{1,2}(?::\d{2})+(?:\.\d*)?\z/

    def initialize(args)
      @args = args
    end

    def validate
      fail InvalidUrlException unless valid_url?
      fail InvalidTimestampException unless args[:trim_from] =~ TIMESTAMP
      fail MissingOutputFileException unless args[:output]
    end

    private

    attr_reader :args

    def valid_url?
      URI(args[:url])
      true
    rescue
      false
    end
  end
end
