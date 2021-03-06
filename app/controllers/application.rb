# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include ExceptionNotifiable

  layout 'main'

  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => 'aff65daaa7581a7f4e4792699b91635c'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password

protected

  def authenticate
    authenticate_or_request_with_http_basic do |username, password|
      username == Pharm::Config.admin_hash['login'] && password == Pharm::Config.admin_hash['password']
    end
  end

  def load_photo
    @photo = Photo.find(params[:id])
  end
  
  def load_user
    @user = User.blog_user
  end

end
