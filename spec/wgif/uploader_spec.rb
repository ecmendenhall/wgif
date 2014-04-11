require 'json'
require 'spec_helper'
require 'typhoeus'
require 'wgif/uploader'

describe WGif::Uploader do
  let(:api_key) { 'api-key' }
  let(:uploader) { WGif::Uploader.new(api_key) }
  let(:success) { Typhoeus::Response.new(
    response_code: 200,
    return_code: :ok,
    body: {data: {link: 'foo'}}.to_json)
  }

  let(:failure) { Typhoeus::Response.new(
    response_code: 400,
    return_code: :error,
    body: {data: {error: 'You should be ashamed of yourself.'}}.to_json )
  }
  let(:tempfile) { Tempfile.new('whatever') }
  let(:request_params) { {body: {image: tempfile},
                          headers: {Authorization: "Client-ID #{api_key}"}} }

  it 'sends an authorized POST request to Imgur with image file data' do
    File.stub(:open).and_yield(tempfile)
    expect(Typhoeus).to receive(:post).
      with('https://api.imgur.com/3/image', request_params).and_return(success)
    uploader.upload(tempfile.path)
  end

  it 'raises an exception if request is not successful' do
    Typhoeus.stub(/http/).and_return(failure)
    expect{ uploader.upload(tempfile.path) }.
      to raise_error(WGif::ImgurException, 'You should be ashamed of yourself.')
  end

  it 'returns the url when successful' do
    File.stub(:open).and_yield(tempfile)
    expect(Typhoeus).to receive(:post).
      with('https://api.imgur.com/3/image', request_params).and_return(success)
    expect(uploader.upload(tempfile.path)).to eq("foo")
  end

end