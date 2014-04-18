require 'spec_helper'
require 'wgif/argument_parser'

describe WGif::ArgumentParser do
  let(:parser) { described_class.new }

  it 'parses a URL from command line args' do
    args = parser.parse_args ["http://example.com"]
    args[:url].should eq("http://example.com")
  end

  it 'starts at 0s by default' do
    args = parser.parse_args ["http://example.com"]
    args[:trim_from].should eq("00:00:00")
  end

  it 'trims parserps to 1s by default' do
    args = parser.parse_args ["http://example.com"]
    args[:duration].should eq(1)
  end

  it 'parses the short frame count option' do
    options = parser.parse_options ["-f", "40"]
    options[:frames].should eq(40)
  end

  it 'parses the long frame count option' do
    options = parser.parse_options ["--frames", "40"]
    options[:frames].should eq(40)
  end

  it 'parses the short start time option' do
    options = parser.parse_options ["-s", "00:00:05"]
    options[:trim_from].should eq("00:00:05")
  end

  it 'parses the long start time option' do
    options = parser.parse_options ["--start", "00:00:05"]
    options[:trim_from].should eq("00:00:05")
  end

  it 'parses the short duration option' do
    options = parser.parse_options ["-d", "1.43"]
    options[:duration].should eq(1.43)
  end

  it 'parses the long duration option' do
    options = parser.parse_options ["--duration", "5.3"]
    options[:duration].should eq(5.3)
  end

  it 'parses the short dimensions option' do
    options = parser.parse_options ["-w", "400"]
    expect(options[:dimensions]).to eq("400")
  end

  it 'parses the long dimensions option' do
    options = parser.parse_options ["--width", "300"]
    expect(options[:dimensions]).to eq("300")
  end

  it 'parses the short upload option' do
    options = parser.parse_options ["-u"]
    expect(options[:upload]).to eq(true)
  end

  it 'parses the long upload option' do
    options = parser.parse_options ['--upload']
    expect(options[:upload]).to eq(true)
  end

  it 'handles args in wacky order' do
    args = parser.parse_args([
      '-d',
      '1.5',
      'http://example.com',
      '--frames',
      '60',
      'my-great-gif.gif',
      '-s',
      '00:00:05'
    ])

    expect(args).to eq(url: "http://example.com",
                       trim_from: "00:00:05",
                       duration: 1.5,
                       frames: 60,
                       output: "my-great-gif.gif",
                       dimensions: "480")
  end

  context 'validating args' do

    it 'checks for a missing output file' do
      args = parser.parse_args(['http://example.com'])
      expect { parser.validate_args args }
        .to raise_error(WGif::MissingOutputFileException)
    end

    it 'checks for an invalid URL' do
      args = parser.parse_args(['crazy nonsense', 'output.gif'])
      expect { parser.validate_args args }
        .to raise_error(WGif::InvalidUrlException)
    end

    it 'checks for an invalid timestamp' do
      args = parser.parse_args([
        'http://lol.wut',
        'output.gif',
        '-s',
        'rofl'
      ])
      expect { parser.validate_args args }
        .to raise_error(WGif::InvalidTimestampException)
    end

    it 'returns true when args are OK' do
      args = parser.parse_args([
        'https://crazynonsense.info',
        'output.gif'
      ])
      expect { parser.validate_args args }.not_to raise_error
    end
  end

  it 'parses and validates' do
    expect { parser.parse(['http://lol.wut']) }
      .to raise_error(WGif::MissingOutputFileException)
  end
end
