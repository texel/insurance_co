class AccountsController < ApplicationController
  before_filter :verify_account, :verify_template
  
  def show; end
  
  protected
  
  def verify_account
    redirect_to login_path unless session.account
  end
  
  def verify_template
    redirect_to new_template_path unless session.template_id
  end
end
