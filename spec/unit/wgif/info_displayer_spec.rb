require 'spec_helper'
require 'wgif/info_displayer'

describe WGif::InfoDisplayer do

  let(:cache) { described_class.new }

  before do
    @mock_stdout = StringIO.new
    @real_stdout, $stdout = $stdout, @mock_stdout
  end

  after do
    $stdout = @real_stdout
  end

  it 'prints out a file size to the command line' do
    file_name = "fake_file_name.rb"
    File.stub(:size).with(file_name).and_return("1048576")
    cache.display(file_name)
    expect(@mock_stdout.string).to match(/1.000 MB/)
  end

end
