module ApplicationHelper
  def markdown(text)
    unless @markdown
      options = {
        hard_wrap: true
      }
      extensions = {
        no_intra_emphasis: true,
        tables: true,
        fenced_code_blocks: true,
        autolink: true,
        quote: true,
        disable_indented_code_blocks: true,
        strikethrough: true,
        lax_spacing: true,
        space_after_headers: true,
        underline: true,
        highlight: true,
        quote: true

      }
      renderer = Redcarpet::Render::HTML.new(options)
      @markdown = Redcarpet::Markdown.new(renderer, extensions)
    end
    @markdown.render(text).html_safe
  end
  
end
