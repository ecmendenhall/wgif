require 'optparse'
require 'wgif/validator'

module WGif
  class ArgumentParser

    DEFAULTS = {
      trim_from: '00:00:00',
      duration: 1.0,
      dimensions: '480'
    }

    def initialize
      @options = {}
      @parser = OptionParser.new do |opts|
        opts.on('-f N',
                '--frames N',
                'Number of frames in the final gif. (Default 20)') {
          |n|  @options[:frames] = n.to_i
        }
        opts.on('-s HH:MM:SS.SSSS',
                '--start HH:MM:SS.SSSS',
                'Start creating gif from input video at this timestamp. (Default 00:00:00)') {
          |ts| @options[:trim_from] = ts
        }
        opts.on('-d seconds',
                '--duration seconds',
                'Number of seconds of input video to capture. (Default 1.0)') {
          |d|  @options[:duration] = d.to_f
        }
        opts.on('-w pixels',
                '--width pixels',
                'Width of the gif in pixels. (Default 480px)') {
          |gs| @options[:dimensions] = gs
        }
        opts.on('-u',
                '--upload',
                'Upload finished gif to Imgur') {
          |u| @options[:upload] = u
        }
        opts.on('-i',
                '--info',
                'Displays info about finished gif (currently just file size)') {
          |i| @options[:info] = i
        }
        opts.on('-p',
                '--preview',
                'Preview finished gif with Quick Look') {
          |p| @options[:preview] = p
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
      validate(options)
      options
    end

    def validate(args)
      WGif::Validator.new(args).validate
    end

    def argument_summary
      @parser.summarize
    end

    def parse_args(args)
      options = DEFAULTS.merge(parse_options args)
      options.merge(url: args[0], output: args[1])
    end

    def parse_options(args)
      @parser.parse! args
      @options
    end

    def print_help
      puts 'Usage: wgif [YouTube URL] [output file] [options]', "\n"
      puts argument_summary, "\n"
      puts <<-example
Example:

    $ wgif https://www.youtube.com/watch?v=1A78yTvIY1k bjork.gif -s 00:03:30 -d 2.2 -w 400 --upload

      example
    end
  end
end
