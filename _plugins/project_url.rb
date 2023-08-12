module Jekyll
  class ProjectUrlTag < Liquid::Tag

    def initialize(tag_name, name, tokens)
      super
      @name = name
    end

    def render(context)
      "#{context.registers[:site].config['url']}/project/#{@name}"
    end
  end
end

Liquid::Template.register_tag('project_url', Jekyll::ProjectUrlTag)