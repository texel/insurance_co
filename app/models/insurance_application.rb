# See lib/active_record/tableless for parent class implementation

class InsuranceApplication < ActiveRecord::Tableless
  COMPLETE_OPTIONS = [
    ['Send Application', 'send'],
    ['Send and Sign Application', 'complete'], 
    ['Send and Customize Application', 'customize']
  ]
  
  SUBJECT = "Automobile Insurance Application"
  BLURB   = "Please review and complete this automobile insurance application"
  
  column :first_name
  column :last_name
  column :make
  column :model
  column :vin
  column :completion_option, :string, 'send'
  column :signer_email
  column :cc_email
  
  validates_presence_of :first_name, :last_name, :make, :model, :vin, :completion_option, :signer_email
  
  def fill_envelope(envelope)
    returning envelope do |e|
      e.subject     = SUBJECT
      e.email_blurb = BLURB

      e.envelope_id_stamping = true
      
      e.recipients.each do |r|
        r.email = signer_email if signer_email
        
        r.signature_info = Docusign::RecipientSignatureInfo.new.tap do |i|
          i.signature_initials = initials(r.user_name)
          i.font_style         = Docusign::FontStyleCode::BradleyHandITC
          i.signature_name     = r.user_name
        end
      end
      
      %w[Make Model VIN].each do |attr|
        tab = e.tabs.find { |t| t.tab_label == attr }
        tab.value = send(attr.downcase)
      end
    end
  end
  
  protected
  
  def initials(name)
    name.to_s.split(' ').map(&:first).map(&:upcase).join
  end
end