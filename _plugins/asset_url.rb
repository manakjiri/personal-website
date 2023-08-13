module Jekyll
  content_url = "/assets/content"

  class VideoUrlTag < Liquid::Tag
    def initialize(tag_name, name, tokens)
      super
      @name = name
    end

    def render(context)
      "#{@content_url}/videos/#{@name}"
    end
  end

  class DocumentUrlTag < Liquid::Tag
    def initialize(tag_name, name, tokens)
      super
      @name = name
    end

    def render(context)
      "#{@content_url}/documents/#{@name}"
    end
  end

  class ImageUrlTag < Liquid::Tag
    def initialize(tag_name, name, tokens)
      super
      @name = name
    end

    def render(context)
      "#{@content_url}/images/#{@name}"
    end
  end

  class IconUrlTag < Liquid::Tag
    def initialize(tag_name, name, tokens)
      super
      @name = name
    end

    def render(context)
      "#{@content_url}/icons/#{@name}"
    end
  end
end

Liquid::Template.register_tag('video_url', Jekyll::VideoUrlTag)
Liquid::Template.register_tag('document_url', Jekyll::DocumentUrlTag)
Liquid::Template.register_tag('image_url', Jekyll::ImageUrlTag)
Liquid::Template.register_tag('icon_url', Jekyll::IconUrlTag)