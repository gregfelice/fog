
module Provisioner

  class ProvisionerException < StandardError
    
    attr :error_code, :reason
    
    def initialize(error_code, reason) 

      @error_code = error_code
      @reason = reason
      
    end

  end

end
