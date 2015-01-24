require 'spec_helper'
require 'wgif/gif_maker'
require 'wgif/video'

describe WGif::GifMaker do
  let(:gif_maker) { described_class.new }
  let(:image) { double(Magick::Image) }
  let(:images) { double(Magick::ImageList, each: nil) }

  before do
    allow(Magick::ImageList).to receive(:new).and_return(images)
  end

  it 'converts a directory of frames to a gif' do
    expect(images).to receive(:coalesce)
    expect(images).to receive(:optimize_layers)
    expect(images).to receive(:write).with('bjork.gif')
    gif_maker.make_gif([], 'bjork.gif', '500')
  end

  it 'resizes the image' do
    expect(image).to receive(:change_geometry).with('500')
    gif_maker.resize([image], '500')
  end

end
