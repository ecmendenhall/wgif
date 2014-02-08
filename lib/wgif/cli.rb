require 'optparse'
require 'wgif/exceptions'
require 'wgif/downloader'
require 'wgif/gif_maker'

module WGif
  class CLI

    def initialize
      @options = {}
      @defaults = {
        trim_from: '00:00:00',
        duration: 5.0,
        dimensions: '500'
      }
      @parser = OptionParser.new do |opts|
        opts.on('-f N',
                '--frames N',
                'Number of frames in the final gif.') {
                  |n|  @options[:frames] = n.to_i
                }
        opts.on('-s HH:MM:SS',
                '--start HH:MM:SS',
                'Start creating gif from input video at this timestamp.') {
                  |ts| @options[:trim_from] = ts
                }
        opts.on('-d seconds',
                '--duration seconds',
                'Number of seconds of input video to capture.') {
                  |d|  @options[:duration] = d.to_f
                }
        opts.on('-w pixels',
                '--width pixels',
                'Width of the gif in pixels.') {
                  |gs| @options[:dimensions] = gs
                }
      end
    end

    def parse_args(args)
      options = @defaults.merge(parse_options args)
      options.merge(url: args[0], output: args[1])
    end

    def parse_options(args)
      @parser.parse! args
      @options
    end

    def validate_args(parsed_args)
      raise WGif::InvalidUrlException unless parsed_args[:url] =~ /https?\:\/\/.*/
      raise WGif::MissingOutputFileException unless parsed_args[:output]
    end

    def make_gif(cli_args)
      args = parse_args cli_args
      rescue_errors do
        validate_args(args)
        video = Downloader.new.get_video(args[:url])
        clip = video.trim(args[:trim_from], args[:duration])
        frames = clip.to_frames(frames: args[:frames])
        GifMaker.new.make_gif(frames, args[:output], args[:dimensions])
      end
    end

    private

    def rescue_errors
      begin
        yield
      rescue WGif::InvalidUrlException
        print_error "That looks like an invalid URL. Check the syntax."
      rescue WGif::MissingOutputFileException
        print_error 'Please specify an output file.'
      rescue WGif::VideoNotFoundException
        print_error "WGif can't find a valid YouTube video at that URL."
      rescue WGif::ClipEncodingException
        print_error "WGif encountered an error transcoding the video."
      end
    end

    def print_error(message)
      puts message, "\n"
      print_help
    end

    def print_help
      puts "Usage: wgif [YouTube URL] [output file] [options]", "\n"
      puts @parser.summarize, "\n"
      puts <<-example
Example:

    $ wgif https://www.youtube.com/watch?v=1A78yTvIY1k bjork.gif -s 00:03:30 -d 2 -w 400

      example
    end

  end
end
