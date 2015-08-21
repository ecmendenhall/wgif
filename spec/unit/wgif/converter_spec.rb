require "spec_helper"
require "wgif/converter"

describe WGif::Converter do
  describe "#video_to_frames" do
    it "downloads videos from youtube if the url is from www.youtube.com" do
      args = {
        url: "https://www.youtube.com/watvideo",
        trim_from: 0,
        duration: 10,
        frames: 200
      }
      fake_clip, fake_video, fake_frames = double, double, double

      expect_any_instance_of(WGif::Downloader).to receive(:get_video).with(args[:url]).and_return(fake_video)
      expect(fake_video).to receive(:trim).with(args[:trim_from], args[:duration]).and_return(fake_clip)
      expect(fake_clip).to receive(:to_frames).with(frames: args[:frames]).and_return(fake_frames)

      frames = described_class.new(args).video_to_frames

      expect(frames).to eq(fake_frames)
    end

    it "downloads videos from youtube if the url is from youtube.com" do
      args = {
        url: "https://youtube.com/watvideo",
        trim_from: 0,
        duration: 10,
        frames: 200
      }
      fake_clip, fake_video, fake_frames = double, double, double

      expect_any_instance_of(WGif::Downloader).to receive(:get_video).with(args[:url]).and_return(fake_video)
      expect(fake_video).to receive(:trim).with(args[:trim_from], args[:duration]).and_return(fake_clip)
      expect(fake_clip).to receive(:to_frames).with(frames: args[:frames]).and_return(fake_frames)

      frames = described_class.new(args).video_to_frames

      expect(frames).to eq(fake_frames)
    end

    it "uses a local file if the url is not from youtube" do
      args = {
        url: "~/test/video.mov",
        trim_from: 0,
        duration: 10,
        frames: 200
      }
      fake_clip, fake_video, fake_frames = double, double, double

      expect(WGif::Video).to receive(:new).with(kind_of(String), args[:url]).and_return(fake_video)
      expect(fake_video).to receive(:trim).with(args[:trim_from], args[:duration]).and_return(fake_clip)
      expect(fake_clip).to receive(:to_frames).with(frames: args[:frames]).and_return(fake_frames)

      frames = described_class.new(args).video_to_frames

      expect(frames).to eq(fake_frames)
    end
  end
end
