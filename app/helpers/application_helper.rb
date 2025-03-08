module ApplicationHelper
  def custom_button(label, path, color: "primary", size: "md", extra_classes: "")
    link_to label, path, class: "custom-btn btn-#{color} btn-#{size} #{extra_classes}"
  end

  def custom_form_button(label, color: "primary", size: "md")
    content_tag :button, label, class: "custom-btn btn-#{color} btn-#{size}", type: "submit", data: { turbo: "false" }
  end
end
