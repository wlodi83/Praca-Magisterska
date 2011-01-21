# This controller handles the login/logout function of the site.  
class SessionsController < ApplicationController
  access_control do
    allow all
  end
  # render new.erb.html
  def new
  end

  def create
    logout_keeping_session!
    user = User.authenticate(params[:login], params[:password])
    if user
      # Protects against session fixation attacks, causes request forgery
      # protection if user resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      # reset_session
      self.current_user = user
      new_cookie_flag = (params[:remember_me] == "1")
      handle_remember_cookie! new_cookie_flag
      redirect_back_or_default('/')
      flash[:success] = "Zalogowano pomyślnie"
    else
      note_failed_signin
      @login       = params[:login]
      @remember_me = params[:remember_me]
      render :action => 'new'
    end
  end

  def destroy
    logout_killing_session!
    flash[:notice] = "Zostałeś wylogowany z systemu."
    redirect_back_or_default('/')
  end

protected
  # Track failed login attempts
  def note_failed_signin
    flash.now[:error] = "Nie możesz zalogować się jako '#{params[:login]}'"
    logger.warn "Niepoprawny login '#{params[:login]}' od #{request.remote_ip} w #{Time.now.utc}"
  end
end
