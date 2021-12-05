## Liquid tag 'postauthor' used to add an block to credit the author
## in the main text area of the layout
## Usage {% postauthor 'Author Name' %}

module Jekyll
  class RenderPostAuthorTag < Liquid::Tag

require "shellwords"

    def initialize(tag_name, text, tokens)
      super
      @text = text.shellsplit
    end

    def render(context)
        "<div class='post-author'>#{@text[0]}</div>"
    end
  end
end

Liquid::Template.register_tag('postauthor', Jekyll::RenderPostAuthorTag )
