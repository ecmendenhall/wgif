require 'rspec'
require 'spec_helper'
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
    options[:trim_to].should eq("00:00:15")
  end

end
