require 'spec_helper'
require 'wgif/installer'

describe WGif::Installer do
  let(:installer) { described_class.new }

  context 'checking for Homebrew' do

    it 'finds Homebrew when it exists' do
      expect(Kernel).to receive(:system).with('brew info').
        and_return(true)
      expect(installer.homebrew_installed?).to eq(true)
    end

    it 'returns false when Homebrew does not exist' do
      expect(Kernel).to receive(:system).with('brew info').
        and_return(false)
      expect(installer.homebrew_installed?).to eq(false)
    end

  end

  context 'installing dependencies' do

    it 'does not install dependencies if they are found' do
      expect(Kernel).to receive(:system).with('which ffmpeg').
        and_return(true)
      expect(Kernel).not_to receive(:system).with('brew install ffmpeg')
      installer.install('ffmpeg')
    end

    it 'installs dependencies' do
      expect(Kernel).to receive(:system).with('which ffmpeg').
        and_return(false)
      expect(Kernel).to receive(:system).with('brew install ffmpeg')
      installer.install('ffmpeg')
    end

    it 'has a list of its dependencies' do
      expect(installer.class::DEPENDENCIES).
        to eq(['ffmpeg', 'imagemagick'])
    end

    it 'checks if a dependency exists' do
      expect(Kernel).to receive(:system).with('which imagemagick')
      installer.installed?('imagemagick')
    end

  end

  context 'running' do

    before do
      @mock_stdout = StringIO.new
      @real_stdout, $stdout = $stdout, @mock_stdout
    end

    after do
      $stdout = @real_stdout
    end

    it 'installs all dependencies' do
      expect(Kernel).to receive(:system).with('brew info').
        and_return(true)
      expect(Kernel).to receive(:system).with('which ffmpeg').
        and_return(true)
      expect(Kernel).to receive(:system).with('which imagemagick').
        and_return(false)
      expect(Kernel).to receive(:system).with('brew install imagemagick')
      installer.run
    end

    it 'prints a helpful error if homebrew is not found' do
      expect(Kernel).to receive(:system).with('brew info').
        and_return(false)
      expect{ installer.run }.to raise_error(SystemExit)
      expect(@mock_stdout.string).to eq("WGif can't find Homebrew. Visit http://brew.sh/ to get it.\n")
    end
  end

end
