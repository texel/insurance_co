class LoginsController < ApplicationController
  def new
  end
  
  def create
    result = Docusign::Base.credentials(params[:email], params[:password], Docusign::Config[:credential_endpoint_url])
    
    if result.success?
      # See if there are multiple accounts etc
    else
      flash[:error] = result.authentication_message
      redirect_to 'new'
    end
  end
end
