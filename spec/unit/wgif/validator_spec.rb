require 'spec_helper'
require 'wgif/validator'

describe WGif::Validator do
  let(:valid_args) do
    {
      url: 'https://crazynonsense.info',
      output: 'output.gif',
      trim_from: '00:00:01'
    }
  end

  it 'checks for an invalid URL' do
    args = valid_args.merge(url: 'crazy nonsense')
    expect { described_class.new(args).validate }
      .to raise_error(WGif::InvalidUrlException)
  end

  it 'checks for a missing output file' do
    args = valid_args.merge(output: nil)
    expect { described_class.new(args).validate }
      .to raise_error(WGif::MissingOutputFileException)
  end

  it 'checks for an invalid timestamp' do
    args = valid_args.merge(trim_from: 'rofl')
    expect { described_class.new(args).validate }
      .to raise_error(WGif::InvalidTimestampException)
  end

  it 'returns true when args are OK' do
    expect { described_class.new(valid_args).validate }
      .not_to raise_error
  end
end
