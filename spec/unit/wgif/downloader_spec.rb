require 'spec_helper'
require 'wgif/downloader'
require 'wgif/video'

describe WGif::Downloader do
  let(:downloader) { described_class.new }
  let(:clip_url) { 'http://lol.wut/watch?v=roflcopter' }

  before do
    FileUtils.rm_rf('/tmp/wgif')
    download_bar = double(WGif::DownloadBar).as_null_object
    allow(WGif::DownloadBar).to receive(:new).and_return(download_bar)
  end

  it 'retrieves a YouTube download URL' do
    expect(ViddlRb).to receive(:get_urls).with(clip_url).and_return(['clip url'])
    expect(downloader.video_url clip_url).to eq('clip url')
  end

  it 'retrieves a YouTube video ID' do
    expect(downloader.video_id clip_url).to eq('roflcopter')
  end

  it 'throws an error if the video is not found' do
    expect(ViddlRb).to receive(:get_urls).with(clip_url)
      .and_return(['http://lol.wut'])
    expect { downloader.get_video(clip_url) }
      .to raise_error(WGif::VideoNotFoundException)
  end

  it 'extracts a YouTube ID from a URL' do
    expect(downloader.video_id 'http://lol.wut?v=id').to eq('id')
  end

  context 'downloading videos' do

    before do
      allow(ViddlRb).to receive(:get_urls).and_return([clip_url])
      fake_request = double('Typhoeus::Request')
      fake_response = double('Typhoeus::Response')
      expect(Typhoeus::Request).to receive(:new).once
        .with(clip_url).and_return(fake_request)
      expect(fake_request).to receive(:on_headers)
      expect(fake_request).to receive(:on_body)
      expect(fake_request).to receive(:run).and_return(fake_response)
      expect(fake_response).to receive(:response_code).and_return(200)
    end

    it 'downloads a clip' do
      video = double(name: 'video')
      expect(WGif::Video).to receive(:new)
        .with('roflcopter', '/tmp/wgif/roflcopter').and_return(video)
      downloader.get_video(clip_url)
    end

    it 'does not download the clip when already cached' do
      downloader.get_video(clip_url)
      downloader.get_video(clip_url)
    end
  end

  context 'errors' do

    it 'throws an exception when the download URL is not found' do
      allow(ViddlRb).to receive(:get_urls).and_raise(RuntimeError)
      expect { downloader.video_url('invalid url') }
        .to raise_error(WGif::VideoNotFoundException)
    end

    it 'throws an exception when the download URL is invalid' do
      expect { downloader.video_id(nil) }
        .to raise_error(WGif::InvalidUrlException)
    end

  end

end
