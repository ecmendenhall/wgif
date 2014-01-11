require 'optparse'
require 'wgif/downloader'
require 'wgif/gif_maker'

module WGif
  class CLI

    def self.parse_args args
      defaults = {
        url: args.first,
        trim_from: "00:00:00",
        trim_to: "00:00:05",
      }

      options = defaults.merge(parse_options args)
      options.merge(url: args.first)
    end

    def self.parse_options args
      options = {}

      parser = OptionParser.new do |opts|
        opts.on("-f N",
                "--frames N", "") { |n| options[:frames] = n.to_i; }
        opts.on("-s HH:MM:SS",
                "--start HH:MM:SS", "") { |ts| options[:trim_from] = ts }
        opts.on("-e HH:MM:SS",
                "--end HH:MM:SS", "") { |ts| options[:trim_to] = ts }
      end

      parser.parse! args
      options
    end

    def self.make_gif(cli_args)
      require 'pry'
      binding.pry
      args = parse_args cli_args
      video_url = Downloader.video_url(args[:url])
      video = Downloader.get_video(video_url)
      video = Video.new "video", args[:url]
      clip = video.trim(args[:trim_from], args[:trim_to])
      frames = clip.to_frames(frames: args[:frames])
      GifMaker.make_gif(frames, "yourgif.gif")
    end
  end
end
