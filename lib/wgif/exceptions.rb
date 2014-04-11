module WGif

  class InvalidUrlException < Exception
  end

  class InvalidTimestampException < Exception
  end

  class InvalidDurationException < Exception
  end

  class InvalidFramesException < Exception
  end

  class MissingOutputFileException < Exception
  end

  class VideoNotFoundException < Exception
  end

  class ClipEncodingException < Exception
  end

  class ImgurException < Exception
  end

end
