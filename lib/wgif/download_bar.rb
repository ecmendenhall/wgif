require 'ruby-progressbar'

module WGif
  class DownloadBar

    FORMAT = '==> %p%% |%B|'
    SMOOTHING = 0.8

    attr_reader :progress_bar

    def initialize
      @progress_bar = ProgressBar.create(
        format: FORMAT,
        smoothing: SMOOTHING,
        total: @size
      )
    end

    def update_total(size)
      @progress_bar.total = size
    end

    def increment_progress(size)
      @progress_bar.progress += size
    end
  end
end
