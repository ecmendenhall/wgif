require 'json'
require 'typhoeus'
require 'wgif/exceptions'

module WGif
  class Uploader

    UPLOAD_ENDPOINT = 'https://api.imgur.com/3/image'

    def initialize(client_id)
      @client_id = client_id
    end

    def upload(filename)
      File.open(filename, 'r') do |file|
        response = Typhoeus.post(UPLOAD_ENDPOINT,
                                 body: { image: file },
                                 headers: auth_header)
        if response.success?
          image_url(response)
        else
          raise WGif::ImgurException, error_message(response)
        end
      end
    end

    private

    def image_url(response)
      JSON.parse(response.body)['data']['link']
    end

    def error_message(response)
      JSON.parse(response.body)['data']['error']
    end

    def auth_header
      { Authorization: "Client-ID #{@client_id}" }
    end
  end
end
