require 'wgif/argument_parser'
require 'wgif/exceptions'
require 'wgif/installer'

module WGif
  class CLI

    attr_accessor :argument_parser

    def initialize
      @argument_parser = WGif::ArgumentParser.new
    end

    def make_gif(cli_args)
      WGif::Installer.new.run if cli_args[0] == 'install'
      require 'wgif/downloader'
      require 'wgif/gif_maker'
      require 'wgif/uploader'
      rescue_errors do
        args = @argument_parser.parse(cli_args)
        video = Downloader.new.get_video(args[:url])
        clip = video.trim(args[:trim_from], args[:duration])
        frames = clip.to_frames(frames: args[:frames])
        GifMaker.new.make_gif(frames, args[:output], args[:dimensions])
        if args[:upload]
          url = Uploader.new('d2321b02db7ba15').upload(args[:output])
          puts "Finished. GIF uploaded to Imgur at #{url}"
        end
      end
    end

    private

    def rescue_errors
      yield
      rescue WGif::InvalidUrlException
        print_error 'That looks like an invalid URL. Check the syntax.'
      rescue WGif::InvalidTimestampException
        print_error 'That looks like an invalid timestamp. Check the syntax.'
      rescue WGif::MissingOutputFileException
        print_error 'Please specify an output file.'
      rescue WGif::VideoNotFoundException
        print_error "WGif can't find a valid YouTube video at that URL."
      rescue WGif::ClipEncodingException
        print_error 'WGif encountered an error transcoding the video.'
      rescue WGif::ImgurException => e
        print_error <<-error
WGif couldn't upload your GIF to Imgur. The Imgur error was:

#{e}
error
      rescue StandardError => e
        print_error <<-error
Something went wrong creating your GIF. The details:

#{e}
#{e.backtrace.join("\n")}

Please open an issue at: https://github.com/ecmendenhall/wgif/issues/new
error
    end

    def print_error(message)
      puts message, "\n"
      print_help
      exit 1
    end

    def print_help
      puts 'Usage: wgif [YouTube URL] [output file] [options]', "\n"
      puts @argument_parser.argument_summary, "\n"
      puts <<-example
Example:

    $ wgif https://www.youtube.com/watch?v=1A78yTvIY1k bjork.gif -s 00:03:30 -d 2 -w 400

      example
    end
  end
end
