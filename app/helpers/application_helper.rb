module ApplicationHelper
  def custom_button(label, path, color: "primary", size: "md", extra_classes: "")
    link_to label, path, class: "custom-btn btn-#{color} btn-#{size} #{extra_classes}"
  end

  def custom_form_button(label, color: "primary", size: "md")
    content_tag :button, label, class: "custom-btn btn-#{color} btn-#{size}", type: "submit", data: { turbo: "false" }
  end

  def video_poster_url(content)
    return url_for(content.thumbnail) if content.thumbnail.attached?

    # Try multiple timestamps (1s, 2s, 3s) and let JavaScript handle frame detection
    "#{url_for(content.media)}#t=1,2,3"
  end
end
