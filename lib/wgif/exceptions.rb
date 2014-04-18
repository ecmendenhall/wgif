module WGif
  InvalidUrlException        = Class.new(Exception)
  InvalidTimestampException  = Class.new(Exception)
  InvalidDurationException   = Class.new(Exception)
  InvalidFramesException     = Class.new(Exception)
  MissingOutputFileException = Class.new(Exception)
  VideoNotFoundException     = Class.new(Exception)
  ClipEncodingException      = Class.new(Exception)
  ImgurException             = Class.new(Exception)
end
