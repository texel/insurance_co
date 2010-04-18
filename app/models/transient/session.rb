module Transient
  module Session
    
    def self.sattr_accessor(*args)
      args.each do |arg|
        module_eval %Q{
          def #{arg}
            self[:#{arg}]
          end
          
          def #{arg}=(value)
            self[:#{arg}] = value 
          end
        }
      end
    end
    
    sattr_accessor :account, :password, :template_id
    
  end
end