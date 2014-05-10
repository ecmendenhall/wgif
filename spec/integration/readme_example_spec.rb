require 'spec_helper'
require 'wgif/cli'

describe 'README example', integration: true do
  it 'creates the same GIF as the README' do
    args =  ['https://www.youtube.com/watch?v=1A78yTvIY1k',
             'bjork.gif',
             '--start',
             '00:03:30',
             '-d',
             '2',
             '-f',
             '18',
             '--width',
             '350']
    WGif::CLI.new.make_gif(args)
    expected_sha = 'ff739544dd26b983c122bb78858481d87c7ffeff'
    gif_sha = Digest::SHA1.file('bjork.gif').hexdigest
    expect(gif_sha).to eq(expected_sha)
  end
end
