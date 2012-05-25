class SessionsController < Devise::SessionsController

  def create
    super
    user_session[:secret] = Digest::SHA2.base64digest DA_SALT + params[:user][:password]
  end

end
