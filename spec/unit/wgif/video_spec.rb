require 'spec_helper'
require 'wgif/video'

describe WGif::Video do
  let(:clip) { double(FFMPEG::Movie) }

  before do
    allow(FFMPEG::Movie).to receive(:new).and_return(clip)
  end

  it 'has a name and filepath' do
    expect(clip).to receive(:path).and_return('/tmp/wgif/bjork.mp4')
    video = described_class.new 'bjork', '/tmp/wgif/bjork.mp4'
    expect(video.name).to eq('bjork')
    expect(video.clip.path).to eq('/tmp/wgif/bjork.mp4')
  end

  it 'sets up a logger' do
    video = described_class.new 'bjork', '/tmp/wgif/bjork.mp4'
    expect(video.logger.instance_variable_get(:@logdev).filename)
      .to eq('/tmp/wgif/bjork.log')
  end

  it 'redirects FFMPEG log output to a file' do
    expect(FFMPEG).to receive(:logger=).with(an_instance_of(Logger))
    described_class.new 'penguin', 'spec/fixtures/penguin.mp4'
  end

  it 'is trimmable' do
    expect(clip).to receive(:duration).and_return(5.0)
    expect(clip).to receive(:transcode)
    video = described_class.new 'bjork', '/tmp/wgif/bjork.mp4'
    video = video.trim('00:00:00', 5.0)
    expect(video.clip.duration).to eq(5.0)
  end

  it 'returns its frames' do
    expect(clip).to receive(:transcode)
    allow(FileUtils).to receive(:rm)
    fake_frames = ['one', 'two', 'three']
    expect(Dir).to receive(:glob).with('/tmp/wgif/frames/*.png').twice
      .and_return(fake_frames)
    video = described_class.new 'bjork', '/tmp/wgif/bjork.mp4'
    frames = video.to_frames
    expect(frames.count).to eq(3)
  end

  it 'returns a specific number of frames' do
    frames = '/tmp/wgif/frames/%5d.png'
    options = '-vf fps=5'
    expect(clip).to receive(:transcode).with(frames, options)
    allow(FileUtils).to receive(:rm)
    expect(clip).to receive(:duration).and_return 2
    expect(Dir).to receive(:glob).with('/tmp/wgif/frames/*.png').twice
    video = described_class.new 'bjork', '/tmp/wgif/bjork.mp4'
    video.to_frames(frames: 10)
  end

  it 'catches transcode errors and raises an exception' do
    expect(clip).to receive(:transcode).and_raise(FFMPEG::Error)
    video = described_class.new 'bjork', '/tmp/wgif/bjork.mp4'
    expect { video.trim('00:00:00', 5.0) }
      .to raise_error(WGif::ClipEncodingException)
  end

  it 'silences transcode errors from ripping frames' do
    expect(clip).to receive(:transcode)
      .and_raise(FFMPEG::Error.new 'no output file created')
    video = described_class.new 'bjork', '/tmp/wgif/bjork.mp4'
    expect { video.trim('00:00:00', 5.0) }
      .not_to raise_error
  end

  it 'silences transcode errors from ripping frames when input is invalid' do
    message = 'no output file created. Invalid data found when processing input'
    expect(clip).to receive(:transcode).and_raise(FFMPEG::Error.new message)
    video = described_class.new 'bjork', '/tmp/wgif/bjork.mp4'
    expect { video.trim('00:00:00', 5.0) }
      .to raise_error(WGif::ClipEncodingException)
  end
end
