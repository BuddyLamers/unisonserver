module ApplicationHelper

  def auth_token
    "<input name='authenticity_token' 
    type='hidden' 
    value='#{form_authenticity_token}'/>".html_safe
  end

  def options_from_collection(collection)
    html_string = ""
    collection.each do |item|
      html_string += "<option value='#{item.name}'>#{item.name}</option>"
    end
    html_string.html_safe
  end
end
