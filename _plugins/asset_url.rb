require 'net/http'
require 'uri'

def check_exists(url)
  uri = URI.parse(url)
  request = Net::HTTP.new(uri.host, uri.port)
  request.use_ssl = (uri.scheme == "https")
  
  response = request.request_head(uri.path) # Only request the header, not the full content
  raise StandardError.new(url) unless response.code.to_i == 200
  return url
end

module Jekyll
  CONTENT_URL = "https://assets.manakjiri.cz"

  class AssetTag < Liquid::Tag
    def initialize(tag_name, name, tokens)
      super
      @name = name.strip
    end

    def render(context)
      check_exists("#{CONTENT_URL}/#{@name}")
    end
  end
end

Liquid::Template.register_tag('asset', Jekyll::AssetTag)