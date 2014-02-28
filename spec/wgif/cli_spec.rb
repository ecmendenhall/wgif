require 'spec_helper'
require 'wgif/cli'

describe WGif::CLI do
  let(:cli) { described_class.new }

  it 'parses a URL from command line args' do
    args = cli.parse_args ["http://example.com"]
    args[:url].should eq("http://example.com")
  end

  it 'starts at 0s by default' do
    args = cli.parse_args ["http://example.com"]
    args[:trim_from].should eq("00:00:00")
  end

  it 'trims clips to 1s by default' do
    args = cli.parse_args ["http://example.com"]
    args[:duration].should eq(1)
  end

  it 'parses the short frame count option' do
    options = cli.parse_options ["-f", "40"]
    options[:frames].should eq(40)
  end

  it 'parses the long frame count option' do
    options = cli.parse_options ["--frames", "40"]
    options[:frames].should eq(40)
  end

  it 'parses the short start time option' do
    options = cli.parse_options ["-s", "00:00:05"]
    options[:trim_from].should eq("00:00:05")
  end

  it 'parses the long start time option' do
    options = cli.parse_options ["--start", "00:00:05"]
    options[:trim_from].should eq("00:00:05")
  end

  it 'parses the short duration option' do
    options = cli.parse_options ["-d", "1.43"]
    options[:duration].should eq(1.43)
  end

  it 'parses the long duration option' do
    options = cli.parse_options ["--duration", "5.3"]
    options[:duration].should eq(5.3)
  end

  it 'parses the short dimensions option' do
    options = cli.parse_options ["-w", "400"]
    expect(options[:dimensions]).to eq("400")
  end

  it 'parses the long dimensions option' do
    options = cli.parse_options ["--width", "300"]
    expect(options[:dimensions]).to eq("300")
  end

  it 'handles args in wacky order' do
    args = cli.parse_args([
      "-d",
      "1.5",
      "http://example.com",
      "--frames",
      "60",
      "my-great-gif.gif",
      "-s",
      "00:00:05"])

    expect(args).to eq(url: "http://example.com",
                       trim_from: "00:00:05",
                       duration: 1.5,
                       frames: 60,
                       output: "my-great-gif.gif",
                       dimensions: "480")
  end

  context 'validating args' do

    it 'checks for a missing output file' do
      args = cli.parse_args([
        "http://example.com",
      ])
      expect{ cli.validate_args args }.to raise_error(WGif::MissingOutputFileException)
    end

    it 'checks for an invalid URL' do
      args = cli.parse_args([
        "crazy nonsense",
        "output.gif"
      ])
      expect{ cli.validate_args args }.to raise_error(WGif::InvalidUrlException)
    end

    it 'checks for an invalid timestamp' do
      args = cli.parse_args([
        "http://lol.wut",
        "output.gif",
        "-s",
        "rofl"
      ])
      expect{ cli.validate_args args }.to raise_error(WGif::InvalidTimestampException)
    end

    it 'returns true when args are OK' do
      args = cli.parse_args([
        "https://crazynonsense.info",
        "output.gif"
      ])
      expect{ cli.validate_args args }.not_to raise_error
    end
  end

  context 'error handling' do

    before do
      @mock_stdout = StringIO.new
      @real_stdout, $stdout = $stdout, @mock_stdout
    end

    after do
      $stdout = @real_stdout
    end

    def expect_help_with_message(out, message)
      expect(out).to include(message)
      expect(out).to include('Usage: wgif [YouTube URL] [output file] [options]')
      cli.parser.summarize.each do |help_info|
        expect(out).to include(help_info)
      end
      expect(out).to include('Example:')
    end

    it 'catches invalid URLs' do
      OptionParser.any_instance.stub(:parse!).and_raise(WGif::InvalidUrlException)
      expect{ cli.make_gif([]) }.to raise_error(SystemExit)
      expect_help_with_message(@mock_stdout.string, 'That looks like an invalid URL. Check the syntax.')
    end

    it 'catches invalid timestamps' do
      OptionParser.any_instance.stub(:parse!).and_raise(WGif::InvalidTimestampException)
      expect{ cli.make_gif([]) }.to raise_error(SystemExit)
      expect_help_with_message(@mock_stdout.string, 'That looks like an invalid timestamp. Check the syntax.')
    end

    it 'catches missing output args' do
      OptionParser.any_instance.stub(:parse!).and_raise(WGif::MissingOutputFileException)
      expect{ cli.make_gif([]) }.to raise_error(SystemExit)
      expect_help_with_message(@mock_stdout.string, 'Please specify an output file.')
    end

    it 'catches missing videos' do
      OptionParser.any_instance.stub(:parse!).and_raise(WGif::VideoNotFoundException)
      expect{ cli.make_gif([]) }.to raise_error(SystemExit)
      expect_help_with_message(@mock_stdout.string, "WGif can't find a valid YouTube video at that URL.")
    end

    it 'catches encoding exceptions' do
      OptionParser.any_instance.stub(:parse!).and_raise(WGif::ClipEncodingException)
      expect{ cli.make_gif([]) }.to raise_error(SystemExit)
      expect_help_with_message(@mock_stdout.string, "WGif encountered an error transcoding the video.")
    end

    it 'raises SystemExit when thrown' do
      OptionParser.any_instance.stub(:parse!).and_raise(SystemExit)
      expect{ cli.make_gif([]) }.to raise_error(SystemExit)
    end

    it 'Prints the backtrace for all other exceptions' do
      exception = Exception.new 'crazy error'
      OptionParser.any_instance.stub(:parse!).and_raise(exception)
      expect{ cli.make_gif([]) }.to raise_error(SystemExit)
      expect_help_with_message(@mock_stdout.string, 'Something went wrong creating your GIF. The details:')
      expect(@mock_stdout.string).to include('Please open an issue')
      expect(@mock_stdout.string).to include("#{exception}")
      expect(@mock_stdout.string).to include(exception.backtrace.join("\n"))
    end

    it 'prints help information' do
      expect{ cli.make_gif(['-h']) }.to raise_error(SystemExit)
      cli.parser.summarize.each do |help_info|
        expect(@mock_stdout.string).to include(help_info)
      end
    end

  end

end
