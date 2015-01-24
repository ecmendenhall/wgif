require 'spec_helper'
require 'wgif/cli'

describe WGif::CLI do
  let(:cli) { described_class.new }

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
      expect(out)
        .to include('Usage: wgif [YouTube URL] [output file] [options]')
      cli.argument_parser.argument_summary.each do |help_info|
        expect(out).to include(help_info)
      end
      expect(out).to include('Example:')
    end

    it 'catches invalid URLs' do
      allow_any_instance_of(WGif::ArgumentParser).to receive(:parse)
        .and_raise(WGif::InvalidUrlException)
      expect { cli.make_gif([]) }.to raise_error(SystemExit)
      message = 'That looks like an invalid URL. Check the syntax.'
      expect_help_with_message(@mock_stdout.string, message)
    end

    it 'catches invalid timestamps' do
      allow_any_instance_of(WGif::ArgumentParser).to receive(:parse)
        .and_raise(WGif::InvalidTimestampException)
      expect { cli.make_gif([]) }.to raise_error(SystemExit)
      message = 'That looks like an invalid timestamp. Check the syntax.'
      expect_help_with_message(@mock_stdout.string, message)
    end

    it 'catches missing output args' do
      allow_any_instance_of(WGif::ArgumentParser).to receive(:parse)
        .and_raise(WGif::MissingOutputFileException)
      expect { cli.make_gif([]) }.to raise_error(SystemExit)
      message = 'Please specify an output file.'
      expect_help_with_message(@mock_stdout.string, message)
    end

    it 'catches missing videos' do
      allow_any_instance_of(WGif::ArgumentParser).to receive(:parse)
        .and_raise(WGif::VideoNotFoundException)
      expect { cli.make_gif([]) }.to raise_error(SystemExit)
      message = "WGif can't find a valid YouTube video at that URL."
      expect_help_with_message(@mock_stdout.string, message)
    end

    it 'catches encoding exceptions' do
      allow_any_instance_of(WGif::ArgumentParser).to receive(:parse)
        .and_raise(WGif::ClipEncodingException)
      expect { cli.make_gif([]) }.to raise_error(SystemExit)
      message = 'WGif encountered an error transcoding the video.'
      expect_help_with_message(@mock_stdout.string, message)
    end

    it 'catches upload errors' do
      allow_any_instance_of(WGif::ArgumentParser).to receive(:parse)
        .and_raise(WGif::ImgurException, 'Imgur error')
      expect { cli.make_gif([]) }.to raise_error(SystemExit)
      expect_help_with_message(@mock_stdout.string, 'Imgur error')
    end

    it 'raises SystemExit when thrown' do
      allow_any_instance_of(WGif::ArgumentParser).to receive(:parse)
      expect { cli.make_gif([]) }.to raise_error(SystemExit)
    end

    it 'Prints the backtrace for all other exceptions' do
      exception = StandardError.new 'crazy error'
      allow_any_instance_of(WGif::ArgumentParser).to receive(:parse)
        .and_raise(exception)
      expect { cli.make_gif([]) }.to raise_error(SystemExit)
      message = 'Something went wrong creating your GIF. The details:'
      expect_help_with_message(@mock_stdout.string, message)
      expect(@mock_stdout.string).to include('Please open an issue')
      expect(@mock_stdout.string).to include("#{exception}")
      expect(@mock_stdout.string).to include(exception.backtrace.join("\n"))
    end

    it 'prints help information' do
      expect { cli.make_gif(['-h']) }.to raise_error(SystemExit)
      cli.argument_parser.argument_summary.each do |help_info|
        expect(@mock_stdout.string).to include(help_info)
      end
    end
  end
end
