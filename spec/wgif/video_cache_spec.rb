require 'rspec'
require 'wgif/video_cache'

describe WGif::VideoCache do

  let(:cache) { described_class.new }

  it 'checks for existing video files in /tmp' do
    pathname = double(Pathname)
    expect(Pathname).to receive(:new).and_return(pathname)
    expect(pathname).to receive(:exist?).and_return(true)
    expect(WGif::Video).to receive(:new).with('video', '/tmp/wgif/video')
    cache.get('video')
  end

end
