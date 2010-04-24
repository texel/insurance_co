class InsuranceApplicationsController < ApplicationController
  before_filter :verify_account, :verify_template, :new_insurance_application
  
  def new; end
  
  def create
    if @insurance_application.valid?
      @envelope = @insurance_application.fill_envelope(session.template.envelope)
      
      case @insurance_application.completion_option
      when 'send'
        # Deferred sending
        puts "hi?"
      end
      # 3 signing options: embedded signing, embedded sending, deferred signing
      
      # callEmbeddedSending - docusignEmbeddedSendingService.sendEmbedded => w/ createTabs (manually created tabs), returns token for redirect
      # docusignDeferredSigningService.signLater => passes model, returns nothing, redirects to app status
      #   APPEARS to use the tabs already contained in the envelope template
      # callEmbeddedSigning - docusignEmbeddedSigningService.signEmbedded => passes model, returns token for redirect
      #   Also appears to use the tabs already contained in the envelope template
      
      render :text => 'Done!'
    else
      render :new      
    end
  end
  
  protected
  
  def new_insurance_application
    @insurance_application = InsuranceApplication.new(params[:insurance_application])
  end
end
