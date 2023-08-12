module Jekyll
  class DocumentUrlTag < Liquid::Tag

    def initialize(tag_name, name, tokens)
      super
      @name = name
    end

    def render(context)
      "/assets/content/documents/#{@name}"
    end
  end
end

Liquid::Template.register_tag('document_url', Jekyll::DocumentUrlTag)