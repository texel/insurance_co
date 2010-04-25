class EnvelopesController < ApplicationController
  before_filter :verify_account, :verify_template
  
  def index
    # Request statuses in the last week
    status_filter = Docusign::EnvelopeStatusFilter.new.tap do |f|
      f.begin_date_time = XSD::XSDDateTime.new(1.week.ago).to_s
      f.account_id = session.account[:account_id]
    end
    
    response  = ds_connection.request_statuses :envelopeStatusFilter => status_filter
    @statuses = response.request_statuses_result.envelope_statuses
  end
end
