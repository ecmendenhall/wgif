require 'spec_helper'
require 'wgif/download_bar'

describe WGif::DownloadBar do

  context 'setup' do

    let(:download_bar) { described_class.new }
    let(:mock_progress_bar) { double(ProgressBar) }

    before do
      allow(ProgressBar).to receive(:create).and_return(mock_progress_bar)
    end

    it 'creates a ProgressBar with the correct format, smoothing, and size' do
      progress_bar_params = {
        format: '==> %p%% |%B|',
        smoothing: 0.8,
        total: nil
      }
      expect(ProgressBar).to receive(:create).with(progress_bar_params)
      described_class.new
    end

    it 'updates the total size' do
      expect(mock_progress_bar).to receive(:total=).with(500)
      download_bar.update_total(500)
    end

    it 'increments the current progress' do
      expect(mock_progress_bar).to receive(:progress).and_return(1)
      expect(mock_progress_bar).to receive(:progress=)
      download_bar.increment_progress(100)
    end

  end

end
