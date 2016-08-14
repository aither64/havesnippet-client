require 'net/http'
require 'json'

module HaveSnippet::Client
  class Client
    def initialize(server, api_key = nil)
      @server = server
      @api_key = api_key
    end

    def paste(opts)
      data = {}
      data.update(opts)

      data[:format] = :json
      data[:api_key] = @api_key if @api_key

      uri = URI(File.join(@server, '/api/paste/'))

      Response.new(Net::HTTP.post_form(uri, data))
    end
  end

  class Response
    attr_reader :response, :data

    def initialize(res)
      @response = res
      @data = JSON.parse(res.body, symbolize_names: true) if res.code == '200'
    end

    def ok?
      @data && @data.has_key?(:url)
    end

    def errors
      @data && @data[:error]
    end

    def url
      @data && @data[:url]
    end
  end
end
