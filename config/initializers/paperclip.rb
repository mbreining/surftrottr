if ENV["RAILS_ENV"] == "production"
	Paperclip.options[:command_path] = '/usr/local/bin'
else
	Paperclip.options[:command_path] = '/usr/local/ImageMagick-6.4.6/bin'
end