module AvatarHelper
  DEFAULT_AVATAR_URL = "/images/avatars/surftrottr_default_avatar.png"
  DEFAULT_THUMBNAIL_URL = "/images/avatars/surftrottr_default_thumbnail.png"
  DEFAULT_MINI_THUMBNAIL_URL = "/images/avatars/surftrottr_default_mini_thumbnail.png"
  DEFAULT_MICRO_URL = "/images/avatars/surftrottr_default_micro.png"
  
  # Return an image tag for the user avatar.
  def avatar_tag(user)
	if user.avatar.exists?
      image_tag(user.avatar.url)
	else
	  default_avatar_tag
	end
  end
  
  # Return an image tag for the user avatar thumbnail.
  def thumbnail_tag(user)
    if user.avatar.exists?
      image_tag(user.avatar.thumbnail_url)
	else
	  default_thumbnail_tag
	end
  end
  
  # Return an image tag for the user avatar mini thumbnail.
  def mini_thumbnail_tag(user)
    if user.avatar.exists?
      image_tag(user.avatar.mini_thumbnail_url)
	else
	  default_mini_thumbnail_tag
	end
  end
  
  # Return an image tag for the user micro avatar.
  def micro_tag(user)
    if user.avatar.exists?
      image_tag(user.avatar.micro_url)
	else
	  default_micro_tag
	end
  end
  
  # Return an image tag for the default avatar.
  def default_avatar_tag
    image_tag(DEFAULT_AVATAR_URL)
  end
  
  # Return an image tag for the default avatar thumbnail.
  def default_thumbnail_tag
    image_tag(DEFAULT_THUMBNAIL_URL)
  end
  
  # Return an image tag for the default avatar mini thumbnail.
  def default_mini_thumbnail_tag
    image_tag(DEFAULT_MINI_THUMBNAIL_URL)
  end
  
  # Return an image tag for the default micro avatar.
  def default_micro_tag
    image_tag(DEFAULT_MICRO_URL)
  end

end
