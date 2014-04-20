require 'spec_helper'
require 'wgif/cli'

describe 'empty image list bug', integration: true do
  it 'throws an empty image list error' do
    args =  ['https://www.youtube.com/watch?v=deFDlB8RiNg',
             'fish_grease.gif',
             '--start',
             '00:00:13',
             '-d',
             '3',
             '-f',
             '20',
             '--width',
             '350']
    WGif::CLI.new.make_gif(args)
  end
end
