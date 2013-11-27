require 'rmagick'

module WGif
  class GifMaker
    def self.make_gif(frames_dir, filename)
      image = Magick::ImageList.new(*frames_dir)
      image.coalesce
      image.optimize_layers Magick::OptimizeLayer
      image.write(filename)
    end
  end
end
