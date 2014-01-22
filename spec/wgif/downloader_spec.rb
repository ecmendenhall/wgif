require 'rspec'
require 'wgif/downloader'
require 'wgif/video'

describe WGif::Downloader do

  let(:clip_url) { 'http://lol.wut/watch?v=roflcopter' }

  before do
    FileUtils.rm_rf('/tmp/wgif')
  end

  it 'retrieves a YouTube download URL' do
    ViddlRb.should_receive(:get_urls).with(clip_url).and_return(['clip url'])
    described_class.video_url(clip_url).should eq('clip url')
  end

  it 'retrieves a YouTube video ID' do
    described_class.video_id(clip_url).should eq('roflcopter')
  end

  it 'throws an error if the video is not found' do
    ViddlRb.should_receive(:get_urls).with(clip_url).and_return([])
    expect{ described_class.get_video(clip_url) }.to raise_error(WGif::VideoNotFoundException)
  end

  it 'extracts a YouTube ID from a URL' do
    described_class.video_id("https://www.youtube.com/watch?v=tmNXKqeUtJM").should eq("tmNXKqeUtJM")
  end

  context 'downloading videos' do

    before do
      ViddlRb.stub(:get_urls).and_return([clip_url])
      fake_request = double('Typhoeus::Request')
      fake_response = double('Typhoeus::Response')
      Typhoeus::Request.should_receive(:new).once.with(clip_url).and_return(fake_request)
      fake_request.should_receive(:on_headers)
      fake_request.should_receive(:on_body)
      fake_request.should_receive(:run).and_return(fake_response)
      fake_response.should_receive(:response_code).and_return(200)
    end

    it 'downloads a clip' do
      WGif::Video.should_receive(:new).with('roflcopter', "/tmp/wgif/roflcopter")
      video = described_class.get_video(clip_url)
    end

    it 'does not download the clip when already cached' do
      described_class.get_video(clip_url)
      described_class.get_video(clip_url)
    end
  end

end
