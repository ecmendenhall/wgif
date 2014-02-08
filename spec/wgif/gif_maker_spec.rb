require 'spec_helper'
require 'wgif/gif_maker'
require 'wgif/video'

describe WGif::GifMaker do
  let(:gif_maker) { described_class.new }
  let(:image) { double(Magick::Image) }
  let(:images) { double(Magick::ImageList, each: nil) }

  before do
    Magick::ImageList.stub(:new).and_return(images)
  end

  it 'converts a directory of frames to a gif' do
    images.should_receive(:coalesce)
    images.should_receive(:optimize_layers)
    images.should_receive(:write).with('bjork.gif')
    gif_maker.make_gif([], 'bjork.gif', '500')
  end

end
