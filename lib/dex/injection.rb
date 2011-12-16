require 'active_support'
require 'active_support/dependencies'

module Dex
  class InjectableDep    
    attr_reader :mod, :dex, :method
    
    def initialize mod, dex
      @mod, @dex = mod, dex
    end
    
    def perform_injection_on! mod_const
    end
    
    class << self
      def build type, mod, dex
        Types[type.to_sym].new mod, dex
      end
    end
  end
  
  class RequireOrLoadDep < InjectableDep
    def perform_injection_on! mod_const
      ActiveSupport::Dependencies.require_or_load dex
    end
  end
  
  class LoadConstantDep < InjectableDep
    def perform_injection_on! mod_const
      dex.constantize
    end
  end
  
  class IncludeModuleDep < LoadConstantDep
    def perform_injection_on! mod_const
      dex_const = super
      
      mod_const.send :include, dex_const unless mod_const.included_modules.include?(dex_const)
    end
  end
  
  class ExtendModuleDep < LoadConstantDep
    def perform_injection_on! mod_const
      mod_const.send :extend, super
    end
  end
  
  Types = {
    :require => RequireOrLoadDep,
    :load_constant => LoadConstantDep,
    :include => IncludeModuleDep,
    :extend => ExtendModuleDep
  }

  
  module Injection
    # module Accessors
      def _dex_registered_dexes
        @@_dex_registered_dexes ||= {}
      end
    # end
    
    def load_missing_constant from_mod, const_name
      super.tap do |c|
        _dex_include_registered_for c
      end
    end
    
    def _dex_include_registered_for mod_const
      return unless Module === mod_const
      dexes = _dex_registered_dexes[mod_const.name]
      return if dexes.nil?
      
      dexes.each do |dex|
        dex.perform_injection_on! mod_const
      end
    end
    
    def register_dex_for mod, dex, type = :include
      dexes = _dex_registered_dexes[mod] ||= []
      dexes << InjectableDep.build(type, mod, dex)
    end
  end
end

def RegisterDex mod, dex, type = :include
  ActiveSupport::Dependencies.register_dex_for mod, dex, type
end

ActiveSupport::Dependencies.send :include, Dex::Injection
ActiveSupport::Dependencies.send :extend, Dex::Injection
