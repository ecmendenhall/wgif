require 'optparse'
require 'wgif/exceptions'
require 'wgif/downloader'
require 'wgif/gif_maker'

module WGif
  class CLI

    def self.parse_args(args)
      defaults = {
        trim_from: "00:00:00",
        trim_to: "00:00:05",
        dimensions: "500"
      }

      options = defaults.merge(parse_options args)
      options.merge(url: args[0], output: args[1])
    end

    def self.parse_options(args)
      options = {}

      parser = OptionParser.new do |opts|
        opts.on("-f N",
                "--frames N", "") { |n| options[:frames] = n.to_i; }
        opts.on("-s HH:MM:SS",
                "--start HH:MM:SS", "") { |ts| options[:trim_from] = ts }
        opts.on("-e HH:MM:SS",
                "--end HH:MM:SS", "") { |ts| options[:trim_to] = ts }
        opts.on("-d geometry_string",
                "--dimensions geometry_string", "") { |gs| options[:dimensions] = gs }
      end

      parser.parse! args
      options
    end

    def self.validate_args(parsed_args)
      raise WGif::InvalidUrlException unless parsed_args[:url] =~ /http\:\/\/.*/
      raise WGif::MissingOutputFileException unless parsed_args[:output]
    end

    def self.make_gif(cli_args)
      args = parse_args cli_args
      video = Downloader.get_video(args[:url])
      clip = video.trim(args[:trim_from], args[:trim_to])
      frames = clip.to_frames(frames: args[:frames])
      GifMaker.make_gif(frames, args[:output], args[:dimensions])
    end
  end
end
