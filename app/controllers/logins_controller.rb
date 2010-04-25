class LoginsController < ApplicationController
  def new
  end
  
  def create
    result = Docusign::Base.credentials(params[:email], params[:password], Docusign::Config[:credential_endpoint_url])
    
    if result.success?
      # Store the email and password- we'll need them for the rest of the session
      session.email    = params[:email]
      session.password = params[:password]
      
      # See if there are multiple accounts
      if result.accounts.size > 1
        # Store all accounts for disambiguation
        session.accounts = result.accounts.map { |a| account_hash(a) }
        
        redirect_to new_account_selection_path
      else
        session.account = account_hash(result.accounts.first)
        redirect_to new_template_path
      end
    else
      flash[:error] = result.authentication_message
      redirect_to new_login_path
    end
  end
  
  def destroy
    reset_session
    redirect_to new_login_path
  end
end
