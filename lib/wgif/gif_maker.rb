require 'RMagick'

module WGif
  class GifMaker
    def make_gif(frames_dir, filename, dimensions)
      image = Magick::ImageList.new(*frames_dir)
      resize(image, dimensions)
      image.coalesce
      image.optimize_layers Magick::OptimizeLayer
      image.write(filename)
    end

    def resize(image, dimensions)
      image.each do |frame|
        frame.change_geometry(dimensions) do |cols, rows, img|
          img.resize!(cols, rows)
        end
      end
    end
  end
end
