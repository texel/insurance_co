# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include Intercession
  
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  def ds_connection
    if session[:account] && session[:password]
      @connection ||= Docusign::Base.login(
        :integrators_key => Docusign::Config[:integrators_key],
        :email           => session[:account][:email],
        :password        => session[:password],
        :endpoint_url    => Docusign::Config[:default_endpoint_url],
        :wiredump_dev    => Docusign::Config[:debug] ? STDOUT : nil
      )
    else
      missing = []
      missing << "account" unless session[:account]
      missing << "password" unless session[:password]
      
      raise "Attempted to create a Docusign connection without: #{missing.join(', ')} "
    end
  end
  
  def account_hash(account)
    {
      :account_id   => account.account_id,
      :account_name => account.account_name,
      :email        => account.email,
      :user_name    => account.user_name,
      :user_id      => account.user_id
    }
  end
end
