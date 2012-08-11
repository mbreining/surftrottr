class Avatar < ActiveRecord::Base
  # Images sizes.
  MICRO_SIZE_RESIZE = '"20x20^"'
  MINI_THUMB_SIZE_RESIZE = '"40x40^"'
  THUMB_SIZE_RESIZE = '"50x50^"'
  IMG_SIZE_RESIZE = '"150x190^"'
  MICRO_SIZE_CROP = '"20x20"'
  MINI_THUMB_SIZE_CROP = '"40x40"'
  THUMB_SIZE_CROP = '"50x50"'
  IMG_SIZE_CROP = '"150x190"'
  
  # Image directories.
  URL_STUB = "/images/avatars"
  DIRECTORY = File.join("public", "images", "avatars")
  
  def initialize(user, image = nil)
    @user = user
    @image = image
    Dir.mkdir(DIRECTORY) unless File.directory?(DIRECTORY)
  end
  
  def exists?
    File.exists?(File.join(DIRECTORY, filename))
  end

  def exist?
    exists?
  end
  
  def url
    "#{URL_STUB}/#{filename}"
  end
  
  def thumbnail_url
    "#{URL_STUB}/#{thumbnail_name}"
  end
  
  def mini_thumbnail_url
    "#{URL_STUB}/#{mini_thumbnail_name}"
  end

  def micro_url
    "#{URL_STUB}/#{micro_name}"
  end
  
  # Save the avatar image.
  def save
    valid_file? and successful_conversion?
  end

  # Delete the avatar image from the filesystem.
  def delete
    [filename, thumbnail_name, mini_thumbnail_name, micro_name].each do |name|
	  image = "#{DIRECTORY}/#{name}"
	  File.delete(image) if File.exists?(image)
	end
  end 

  private
  
  # Return the filename of the main avatar.
  def filename
    "#{@user.screen_name}.png"
  end  
  
  # Return the filename of the avatar thumbnail.
  def thumbnail_name
    "#{@user.screen_name}_thumbnail.png"
  end

  # Return the filename of the avatar mini thumbnail.
  def mini_thumbnail_name
    "#{@user.screen_name}_mini_thumbnail.png"
  end
  
  # Return the filename of the micro avatar.
  def micro_name
    "#{@user.screen_name}_micro.png"
  end
   
  # Return the (system-dependent) ImageMagick convert executable.
  def convert
    if ENV["OS"] =~ /Windows/
	  # Set this to point to the right Windows directory for ImageMagick.
	else
	  "/usr/bin/convert"
	end
  end
  
  # Return true for a valid, nonempty image file.
  def valid_file?
    # The upload should be nonempty.
	if @image.size.zero?
	  errors.add_to_base("Please enter an image filename")
	  return false
	end
	unless @image.content_type =~ /^image/
	  errors.add(:image, "is not a recognized format")
	  return false
	end
	if @image.size > 1.megabyte
	  errors.add(:image, "can't be bigger than 1 megabyte")
	  return false
	end
	return true
  end
  
  # Try to resize image file and convert to PNG.
  # We use ImageMagick's convert command to ensure sensible image sizes.
  def successful_conversion? 
    # Prepare the filenames for the conversion.
    source = File.join("tmp", "#{@user.screen_name}_full_size")
    full_size = File.join(DIRECTORY, filename)
    thumb_size = File.join(DIRECTORY, thumbnail_name)
    mini_thumb_size = File.join(DIRECTORY, mini_thumbnail_name)
	micro_size = File.join(DIRECTORY, micro_name)
    # Ensure that small and large images both work by writing to a normal file. 
    # (Small files show up as StringIO, larger ones as Tempfiles.)
    File.open(source, "wb") { |f| f.write(@image.read) }
    # Convert the files.
	# Make sure the MAGICK_HOME and DYLD_LIBRARY_PATH environment variables are set
	# before invoking the ImageMagick convert tool (see config/environment.rb).
    img = system("#{convert} #{source} -resize #{IMG_SIZE_RESIZE} -gravity center -extent #{IMG_SIZE_CROP} #{full_size}")
    thumb = system("#{convert} #{source} -resize #{THUMB_SIZE_RESIZE} -gravity center -extent #{THUMB_SIZE_CROP} #{thumb_size}")
    mini_thumb = system("#{convert} #{source} -resize #{MINI_THUMB_SIZE_RESIZE} -gravity center -extent #{MINI_THUMB_SIZE_CROP} #{mini_thumb_size}")
    micro = system("#{convert} #{source} -resize #{MICRO_SIZE_RESIZE} -gravity center -extent #{MICRO_SIZE_CROP} #{micro_size}")
	File.delete(source) if File.exists?(source)
    # Both conversions must succeed, else it's an error.
	unless img and thumb and mini_thumb and micro
	  errors.add_to_base("File upload failed. Try a different image?")
	  return false
	end
    return true
  end
end
