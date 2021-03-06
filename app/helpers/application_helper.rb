# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def pdf_image_tag(image, options = {})
    options[:src] = File.expand_path(RAILS_ROOT) + '/public/images/' + image
    tag(:img, options)
  end

  def owner?(id)
    if current_user.id == id
      return true
    else
      return false
    end
  end

end
