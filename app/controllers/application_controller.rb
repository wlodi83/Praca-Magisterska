# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  
  rescue_from 'Acl9::AccessDenied', :with => :access_denied

  private

  def access_denied
    if current_user
      render :template => 'layouts/access_denied'
    else
      flash[:notice] = 'Dostęp tylko dla użytkowników zalogowanych. Prosze spróbować zalogować się w systemie.'
      redirect_to login_path
    end
  end
  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
end 
