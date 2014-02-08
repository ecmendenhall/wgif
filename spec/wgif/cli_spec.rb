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

  it 'trims clips to 5s by default' do
    args = cli.parse_args ["http://example.com"]
    args[:duration].should eq(5)
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
                       dimensions: "500")
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

    it 'returns true when args are OK' do
      args = cli.parse_args([
        "https://crazynonsense.info",
        "output.gif"
      ])
      expect{ cli.validate_args args }.not_to raise_error
    end
  end

end
