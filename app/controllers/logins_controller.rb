class LoginsController < ApplicationController
  def new
  end
  
  def create
    result = Docusign::Base.credentials(params[:email], params[:password], Docusign::Config[:credential_endpoint_url])
    
    if result.success?
      # Store the password- we'll need it for the rest of the session
      session[:password] = params[:password]
      
      # See if there are multiple accounts
      if result.accounts.size > 1
        # Store both accounts for disambiguation
        session[:accounts] = []
        
        result.accounts.each do |a|
          session[:accounts] << account_hash(a)
        end
        
        redirect_to new_account_selection_path
      else
        session[:account] = account_hash(result.accounts.first)
        redirect_to new_template_path
      end
    else
      flash[:error] = result.authentication_message
      redirect_to new_login_path
    end
  end
end
