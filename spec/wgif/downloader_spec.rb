require 'rspec'
require 'spec_helper'
require 'wgif/downloader'
require 'wgif/video'

describe WGif::Downloader do

  it 'retrieves a YouTube download URL' do
    ViddlRb.should_receive(:get_urls).with('youtube url').and_return(['clip url'])
    described_class.video_url('youtube url').should eq('clip url')
  end

  it 'downloads a clip' do
    HTTParty.should_receive(:get).with('clip url').and_return('video data')
    WGif::Video.should_receive(:new).with('clip url', 'video data')
    video = described_class.get_video('clip url')
  end

end
