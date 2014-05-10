require 'streamio-ffmpeg'
require 'fileutils'

module WGif
  class Video
    attr_accessor :name, :clip, :logger

    def initialize(name, filepath)
      @name = name
      @clip = FFMPEG::Movie.new(filepath)
      FileUtils.mkdir_p '/tmp/wgif/'
      @logger = Logger.new("/tmp/wgif/#{name}.log")
      FFMPEG.logger = @logger
    end

    def trim(start_timestamp, duration)
      options = {
        audio_codec: 'copy',
        video_codec: 'copy',
        custom: "-ss #{start_timestamp} -t 00:00:#{'%06.3f' % duration}"
      }
      transcode(@clip, "/tmp/wgif/#{@name}-clip.mov", options)
      WGif::Video.new "#{@name}-clip", "/tmp/wgif/#{@name}-clip.mov"
    end

    def to_frames(options = {})
      make_frame_dir
      if options[:frames]
        framerate = options[:frames] / @clip.duration
      else
        framerate = 24
      end
      transcode(@clip, "/tmp/wgif/frames/\%5d.png", "-vf fps=#{framerate}")
      open_frame_dir
    end

    private

    def make_frame_dir
      FileUtils.rm Dir.glob('/tmp/wgif/frames/*.png')
      FileUtils.mkdir_p '/tmp/wgif/frames'
    end

    def open_frame_dir
      Dir.glob('/tmp/wgif/frames/*.png')
    end

    def transcode(clip, file, options)
      clip.transcode(file, options)
    rescue FFMPEG::Error => error
      unless error.message.include? 'no output file created'
        raise WGif::ClipEncodingException
      end
      if error.message.include? 'Invalid data found when processing input'
        raise WGif::ClipEncodingException
      end
    end
  end
end
