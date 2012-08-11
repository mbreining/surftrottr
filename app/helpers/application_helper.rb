module ApplicationHelper
  # Return a link for use in layout navigation.
  def nav_link(text, controller, action="index")
    link_to text, :controller => controller, :action => action
  end

  # Return true if some user is logged in, false otherwise.
  def logged_in?
    not session[:user_id].nil?
  end

  # Return the currently logged in user.
  def current_user
    User.find(session[:user_id])
  end

  # Return a text field for a given form.
  def text_field_for_form(form, field, description = nil, alt_label = nil,
                          size=Surftrottr::Application.config.html_text_field_size,
                          maxlength=Surftrottr::Application.config.db_string_max_length)
    if !alt_label.nil?
      field_name = alt_label
    else
      field_name = field.humanize
    end

    if !description.nil?
      description_tag = content_tag(:span, description, :for => description, :class => "description")
      label = content_tag(:label, "#{field_name} #{description_tag}", :for => field)
    else
      label = content_tag(:label, "#{field_name}", :for => field)
    end

    form_field = form.text_field(field, :size => size, :maxlength => maxlength, :class => "text")
    return label + form_field
  end

  # Return true if hiding edit links is required.
  def hide_edit_links?
    not @hide_edit_links.nil?
  end

  def is_field_empty?(field)
    if field.nil? or field == ""
      return true
    end
    return false
  end

  # Creates an image_tag with an alternate "onmouseover" image.
  def image_rollover_tag(source, source_rollover, options = {})
    normal_image = image_path(source) 
    rollover_image = image_path(source_rollover)      
    image_tag(source, options.merge(:onmouseover => swap_image_to(rollover_image), :onmouseout => swap_image_to(normal_image)))
  end

  def swap_image_to(path)
    "this.src='#{path}'"
  end

  # Render flash messages.
  def render_flashes
    if flash[:notice]
      # Fade after 3 seconds.
      script = content_tag(:script, "setTimeout(\"new Effect.Fade('notice');\", 3000)", :type => "text/javascript")
      msg = content_tag(:div, flash[:notice], :id => "notice", :class => "flash")
      return script + msg
    end
    if flash[:error]
      # Fade after 5 seconds.
      script = content_tag(:script, "setTimeout(\"new Effect.Fade('error');\", 5000)", :type => "text/javascript")
      msg = content_tag(:div, flash[:error], :id => "error", :class => "flash")
      return script + msg
    end
    if flash[:permanent]
      # Permanent message (e.g. IE not supported).
      msg = content_tag(:div, flash[:permanent], :id => "permanent", :class => "flash")
      return msg
    end
  end

  # Return the average number of entries created per month.
  def monthly_average(user, entries)
    member_since = DateTime.parse(user.created_at.strftime('%Y/%m/%d'))
    now = DateTime.now
    total_days = (now - member_since).to_i
    if total_days > 30
      average = (30 * entries.length) / total_days
    elsif
      average = entries.length
    end
    return average
  end
end
