module ApplicationHelper
  def my_name
    "Kostia Kaploon"
  end

  def form_group_tag(errors, &block)
    if errors.any?
      content_tag :div, capture(&block), class: 'form-group has-error'
    else
      content_tag :div, capture(&block), class: 'form-group'
    end
  end

  def markdown(text)
    renderer = Redcarpet::Render::HTML.new
    extentions = { fenced_code_blocks: true }
    redcarpet = Redcarpet::Markdown.new(renderer, extentions)
    (redcarpet.render text).html_safe
  end

  def will_paginate(model)
    # pages = model.count.to_f / model.per_page
    page = (params[:page] || 1).to_i
    pages = model.pages.to_i
    render partial: "shared/will_paginate", locals: {page: page, pages: pages}
  end
end