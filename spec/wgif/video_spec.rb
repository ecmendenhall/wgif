require 'rspec'
require 'wgif/video'

describe WGif::Video do
  let(:clip) { double(FFMPEG::Movie) }

  before do
    FFMPEG::Movie.stub(:new).and_return(clip)
  end

  it 'has a name and filepath' do
    clip.stub(:path).and_return('/tmp/wgif/bjork.mp4')
    video = described_class.new "bjork", "/tmp/wgif/bjork.mp4"
    video.name.should eq("bjork")
    video.clip.path.should eq("/tmp/wgif/bjork.mp4")
  end

  it 'sets up a logger' do
    video = described_class.new "bjork", "/tmp/wgif/bjork.mp4"
    video.logger.instance_variable_get(:@logdev).filename.should eq("/tmp/wgif/bjork.log")
  end

  it 'redirects FFMPEG log output to a file' do
    expect(FFMPEG).to receive(:logger=).with(an_instance_of(Logger))
    video = described_class.new "penguin", "spec/fixtures/penguin.mp4"
  end

  it 'is trimmable' do
    clip.stub(:duration).and_return(5.0)
    expect(clip).to receive(:transcode)
    video = described_class.new "bjork", "/tmp/wgif/bjork.mp4"
    video = video.trim("00:00:00", 5.0)
    video.clip.duration.should eq(5.0)
  end

  it 'returns its frames' do
    expect(clip).to receive(:transcode)
    FileUtils.stub(:rm)
    fake_frames = ["one", "two", "three"]
    expect(Dir).to receive(:glob).with('/tmp/wgif/frames/*.png').twice.
      and_return(fake_frames)
    video = described_class.new "bjork", "/tmp/wgif/bjork.mp4"
    frames = video.to_frames
    frames.count.should eq(3)
  end

  it 'returns a specific number of frames' do
    frames = '/tmp/wgif/frames/%2d.png'
    options = '-vf fps=5'
    expect(clip).to receive(:transcode).with(frames, options)
    FileUtils.stub(:rm)
    expect(clip).to receive(:duration).and_return 2
    expect(Dir).to receive(:glob).with('/tmp/wgif/frames/*.png').twice
    video = described_class.new "bjork", "/tmp/wgif/bjork.mp4"
    frames = video.to_frames(frames: 10)
  end
end
