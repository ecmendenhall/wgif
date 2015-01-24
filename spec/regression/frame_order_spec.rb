require 'spec_helper'
require 'wgif/cli'

describe 'frame order bug', regression: true do
  it 'does not create frames out of order' do
    args =  ['https://www.youtube.com/watch?v=piWCBOsJr-w',
             'banana-shoot.gif',
             '-s',
             '2:22',
             '-d',
             '17',
             '-f',
             '170']
    WGif::CLI.new.make_gif(args)
    frames = Dir.entries('/tmp/wgif/frames')
    filenames = (1..170).map { |n| sprintf '%05d.png', n }
    expect(frames).to eq(['.', '..'] + filenames)
  end
end
