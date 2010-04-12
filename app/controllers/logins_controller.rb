class LoginsController < ApplicationController
  def new
  end
  
  def create
    result = Docusign::Base.credentials(params[:email], params[:password], Docusign::Config[:credential_endpoint_url])
    
    if result.success?
      # See if there are multiple accounts etc
      if result.accounts.size > 1
        # Store both accounts for disambiguation
        session[:accounts] = []
        
        result.accounts.each do |a|
          session[:accounts] << account_hash(a)
        end
        
        redirect_to new_account_selection_path
      else
        session[:account] = account_hash(result.accounts.first)
        redirect_to account_path
      end
    else
      flash[:error] = result.authentication_message
      redirect_to new_login_path
    end
  end
  
  protected
  
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
