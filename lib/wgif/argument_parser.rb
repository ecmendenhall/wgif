require 'optparse'
require 'wgif/exceptions'

module WGif
  class ArgumentParser

    URL = %r{\Ahttps?://.*\z}
    TIMESTAMP = /\A\d{1,2}(?::\d{2})+(?:\.\d*)?\z/

    def initialize
      @options = {}
      @defaults = {
        trim_from: '00:00:00',
        duration: 1.0,
        dimensions: '480'
      }
      @parser = OptionParser.new do |opts|
        opts.on('-f N',
                '--frames N',
                'Number of frames in the final gif. (Default 20)') {
          |n|  @options[:frames] = n.to_i
        }
        opts.on('-s HH:MM:SS',
                '--start HH:MM:SS',
                'Start creating gif from input video at this timestamp. (Default 00:00:00)') {
          |ts| @options[:trim_from] = ts
        }
        opts.on('-d seconds',
                '--duration seconds',
                'Number of seconds of input video to capture. (Default 5)') {
          |d|  @options[:duration] = d.to_f
        }
        opts.on('-w pixels',
                '--width pixels',
                'Width of the gif in pixels. (Default 500px)') {
          |gs| @options[:dimensions] = gs
        }
        opts.on('-u',
                '--upload',
                'Upload finished GIF to Imgur') {
          |u| @options[:upload] = u
        }
        opts.on_tail('-h',
                     '--help',
                     'Print help information.') {
          print_help
          exit
        }
      end
    end

    def parse(args)
      options = parse_args(args)
      validate_args(options)
      options
    end

    def argument_summary
      @parser.summarize
    end

    def parse_args(args)
      options = @defaults.merge(parse_options args)
      options.merge(url: args[0], output: args[1])
    end

    def parse_options(args)
      @parser.parse! args
      @options
    end

    def validate_args(args)
      fail WGif::InvalidUrlException unless args[:url] =~ URL
      fail WGif::InvalidTimestampException unless args[:trim_from] =~ TIMESTAMP
      fail WGif::MissingOutputFileException unless args[:output]
    end
  end
end
