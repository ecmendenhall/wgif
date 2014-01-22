require 'rspec'
require 'wgif/cli'

describe WGif::CLI do

  it 'parses a URL from command line args' do
    args = described_class.parse_args ["http://example.com"]
    args[:url].should eq("http://example.com")
  end

  it 'trims clips to 5s by default' do
    args = described_class.parse_args ["http://example.com"]
    args[:trim_from].should eq("00:00:00")
    args[:trim_to].should eq("00:00:05")
  end

  it 'parses the short frame count option' do
    options = described_class.parse_options ["-f", "40"]
    options[:frames].should eq(40)
  end

  it 'parses the long frame count option' do
    options = described_class.parse_options ["--frames", "40"]
    options[:frames].should eq(40)
  end

  it 'parses the short start time option' do
    options = described_class.parse_options ["-s", "00:00:05"]
    options[:trim_from].should eq("00:00:05")
  end

  it 'parses the long start time option' do
    options = described_class.parse_options ["--start", "00:00:05"]
    options[:trim_from].should eq("00:00:05")
  end

  it 'parses the short end time option' do
    options = described_class.parse_options ["-e", "00:00:15"]
    options[:trim_to].should eq("00:00:15")
  end

  it 'parses the long end time option' do
    options = described_class.parse_options ["--end", "00:00:15"]
    expect(options[:trim_to]).to eq("00:00:15")
  end

  it 'parses the short dimensions option' do
    options = described_class.parse_options ["-d", "400"]
    expect(options[:dimensions]).to eq("400")
  end

  it 'parses the long dimensions option' do
    options = described_class.parse_options ["--dimensions", "300"]
    expect(options[:dimensions]).to eq("300")
  end

  it 'handles args in wacky order' do
    args = described_class.parse_args([
      "-e",
      "00:00:15",
      "http://example.com",
      "--frames",
      "60",
      "my-great-gif.gif",
      "-s",
      "00:00:05"])

    expect(args).to eq(url: "http://example.com",
                      trim_from: "00:00:05",
                      trim_to: "00:00:15",
                      frames: 60,
                      output: "my-great-gif.gif",
                      dimensions: "500")
  end

  context 'validating args' do

    it 'checks for a missing output file' do
      args = described_class.parse_args([
        "http://example.com",
      ])
      expect{ described_class.validate_args args }.to raise_error(WGif::MissingOutputFileException)
    end

    it 'checks for an invalid URL' do
      args = described_class.parse_args([
        "crazy nonsense",
        "output.gif"
      ])
      expect{ described_class.validate_args args }.to raise_error(WGif::InvalidUrlException)
    end

    it 'returns true when args are OK' do
      args = described_class.parse_args([
        "http://crazynonsense.info",
        "output.gif"
      ])
      expect{ described_class.validate_args args }.not_to raise_error
    end

  end

end
