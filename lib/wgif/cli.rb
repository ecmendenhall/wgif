require 'optparse'

module WGif
  class CLI

    def self.parse_args args
      defaults = {
        url: args.first,
        trim_from: "00:00:00",
        trim_to: "00:00:05",
      }
    end

    def self.parse_options args
      options = {}

      parser = OptionParser.new do |opts|
        opts.on("-f N", "--frames N", "") { |n| options[:frames] = n.to_i; }
        opts.on("-s HH:MM:SS", "--start HH:MM:SS", "") { |ts| options[:trim_from] = ts }
        opts.on("-e HH:MM:SS", "--end HH:MM:SS", "") { |ts| options[:trim_to] = ts }
      end

      parser.parse! args
      options
    end

  end
end
