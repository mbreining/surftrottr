class Message < ActiveRecord::Base
  attr_accessor :subject, :body, :email

  validates_presence_of :subject, :body
  validates_length_of :subject, :maximum => Surftrottr::Application.config.db_string_max_length
  validates_length_of :body, :maximum => Surftrottr::Application.config.db_string_max_length

  def initialize(params)
    @subject = params[:subject]
    @body = params[:body]
    @email = params[:email]
  end
end
