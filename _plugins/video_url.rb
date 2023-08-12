module Jekyll
  class VideoUrlTag < Liquid::Tag

    def initialize(tag_name, name, tokens)
      super
      @name = name
    end

    def render(context)
      "/assets/content/videos/#{@name}"
    end
  end
end

Liquid::Template.register_tag('video_url', Jekyll::VideoUrlTag)