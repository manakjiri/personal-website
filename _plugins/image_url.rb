module Jekyll
  class ImageUrlTag < Liquid::Tag

    def initialize(tag_name, name, tokens)
      super
      @name = name
    end

    def render(context)
      "/assets/images/#{@name}"
    end
  end
end

Liquid::Template.register_tag('image_url', Jekyll::ImageUrlTag)