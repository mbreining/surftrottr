class UserMailer < ActionMailer::Base
  default :from => 'Surftrottr <do-not-reply@surftrottr.com>'

  # Send a registration confirmation email.
  def registration_confirmation(user)
    @user = user
    mail :to => user.email,
         :subject => 'Welcome to Surftrottr'
  end

  # Send an email w/ forgotten password.
  def reminder(user)
    @user = user
    mail :to => user.email,
         :subject => 'Your login information at surftrottr.com'
  end

  # Send an email to another user.
  def note(msg)
    @mail = msg
    mail :to => msg[:recipient].email,
         :subject => msg[:message].subject
  end

  # Send a friendship request to another user.
  def friend_request(msg)
    @mail = msg
    mail :to => msg[:friend].email,
         :subject => 'New surf buddy request'
  end

  # Send an email when a new comment is added.
  def new_comment(msg)
    @mail = msg
    mail :to => msg[:owner].email,
         :subject => 'New comment added'
  end

  # Send the Contact Us form to Surftrottr.
  def to_surftrottr(msg)
    @mail = msg
    if msg[:user]
      from = "#{msg[:user].screen_name} <#{msg[:user].email}>"
    else
      if msg[:message].email
        from = "Anonymous <#{msg[:message].email}>"
      else
        from = "Anonymous"
      end
    end
    recipients 'surftrottr@gmail.com'
    mail :from => from,
         :to => 'surftrottr@gmail.com',
         :subject => msg[:message].subject
  end
end
