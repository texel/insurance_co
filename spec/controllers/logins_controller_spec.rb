require 'spec_helper'

describe LoginsController do
  integrate_views
  
  describe "#new" do
    it "should succeed" do
      get :new
      response.should be_success
    end
  end
  
  describe "#create" do
    context "with an invalid login" do
      before(:each) do
        Docusign::Base.stubs(:credentials).returns(stub(:success? => false, :authentication_message => 'oh noes'))
      end
      
      it "should redirect to new" do
        post :create, :email => 'foo@bar.com', :password => 'baz'
        response.should redirect_to('new')
      end
    end
  end
end
