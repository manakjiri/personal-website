require 'net/http'
require 'uri'

def check_exists(url)
  if ENV.key?('JEKYLL_ENV') && ENV['JEKYLL_ENV'] == 'production'
    uri = URI.parse(url)
    request = Net::HTTP.new(uri.host, uri.port)
    request.use_ssl = (uri.scheme == "https")
    
    retries = 3
    begin
      response = request.request_head(uri.path) # Only request the header, not the full content
      raise StandardError.new(url) unless response.code.to_i == 200
    rescue StandardError => e
      retries -= 1
      if retries > 0
        sleep(1) # Wait for a second before retrying
        retry
      else
        raise e
      end
    end
  end
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