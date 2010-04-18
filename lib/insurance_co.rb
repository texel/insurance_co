module InsuranceCo
  TEMPLATE_NAME = 'Auto Insurance Application'
  
  def self.template_path
    Rails.root.join('public', 'ds_templates', 'autoInsuranceApplication.dpd')
  end
end