require 'rmagick'

module WGif
  class GifMaker
    def make_gif(frames_dir, filename, dimensions)
      image = Magick::ImageList.new(*frames_dir)
      image.each do |frame|
        frame.change_geometry(dimensions) { |cols, rows, img| img.resize!(cols, rows) }
      end
      image.coalesce
      image.optimize_layers Magick::OptimizeLayer
      image.write(filename)
    end
  end
end
