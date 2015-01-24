require 'spec_helper'
require 'wgif/argument_parser'

describe WGif::ArgumentParser do
  let(:parser) { described_class.new }

  it 'starts at 0s by default' do
    args = parser.parse_args ['http://example.com']
    expect(args[:trim_from]).to eq('00:00:00')
  end

  it 'trims clips to 1s by default' do
    args = parser.parse_args ['http://example.com']
    expect(args[:duration]).to eq(1)
  end

  it 'parses the short frame count option' do
    options = parser.parse_options ['-f', '40']
    expect(options[:frames]).to eq(40)
  end

  it 'parses the long frame count option' do
    options = parser.parse_options ['--frames', '40']
    expect(options[:frames]).to eq(40)
  end

  it 'parses the short start time option' do
    options = parser.parse_options ['-s', '00:00:05']
    expect(options[:trim_from]).to eq('00:00:05')
  end

  it 'parses the long start time option' do
    options = parser.parse_options ['--start', '00:00:05']
    expect(options[:trim_from]).to eq('00:00:05')
  end

  it 'parses the short duration option' do
    options = parser.parse_options ['-d', '1.43']
    expect(options[:duration]).to eq(1.43)
  end

  it 'parses the long duration option' do
    options = parser.parse_options ['--duration', '5.3']
    expect(options[:duration]).to eq(5.3)
  end

  it 'parses the short dimensions option' do
    options = parser.parse_options ['-w', '400']
    expect(options[:dimensions]).to eq('400')
  end

  it 'parses the long dimensions option' do
    options = parser.parse_options ['--width', '300']
    expect(options[:dimensions]).to eq('300')
  end

  it 'parses the short upload option' do
    options = parser.parse_options ['-u']
    expect(options[:upload]).to eq(true)
  end

  it 'parses the long upload option' do
    options = parser.parse_options ['--upload']
    expect(options[:upload]).to eq(true)
  end

  it 'parses the short preview option' do
    options = parser.parse_options ['-p']
    expect(options[:preview]).to eq(true)
  end

  it 'parses the long preview option' do
    options = parser.parse_options ['--preview']
    expect(options[:preview]).to eq(true)
  end

  it 'parses the short output option' do
    options = parser.parse_options ['-i']
    expect(options[:info]).to eq(true)
  end

  it 'parses the long output option' do
    options = parser.parse_options ['--info']
    expect(options[:info]).to eq(true)
  end

  it 'handles args in wacky order' do
    args = parser.parse_args([
      '-d',
      '1.5',
      '--upload',
      'http://example.com',
      '--frames',
      '60',
      '-p',
      'my-great-gif.gif',
      '-s',
      '00:00:05'
    ])

    expect(args).to eq(url: 'http://example.com',
                       trim_from: '00:00:05',
                       duration: 1.5,
                       frames: 60,
                       output: 'my-great-gif.gif',
                       dimensions: '480',
                       upload: true,
                       preview: true)
  end
end
