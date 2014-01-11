require 'rspec'
require 'spec_helper'
require 'wgif/gif_maker'
require 'wgif/video'

describe WGif::GifMaker do

  it 'converts a directory of frames to a gif' do
    video = WGif::Video.new "penguin", "spec/fixtures/penguin.mp4"
    frames = video.to_frames(frames: 5)
    described_class.make_gif(frames, "penguin.gif")
  end

end
