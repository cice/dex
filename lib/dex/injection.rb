require 'active_support'
require 'active_support/dependencies'

module Dex
  class InjectableDep
    attr_reader :mod, :dex, :method
    
    def initialize mod, dex, method
      @mod, @dex, @method = mod, dex, method
    end
    
    def perform_injection_on! mod_const
      mod_const.send method, dex_const
    end
    
    def dex_const
      dex.constantize
    end
  end
  
  module Injection
    attr_accessor :_dex_registered_dexes
    
    def load_missing_constant from_mod, const_name
      super.tap do |c|
        _dex_include_registered_for c
      end
    end
    
    def _dex_include_registered_for mod_const
      return unless @_dex_registered_dexes && Module === mod_const
      dexes = @_dex_registered_dexes[mod_const.name]
      return if dexes.nil?
      
      dexes.each do |dex|
        dex.perform_injection_on! mod_const
      end
    end
    
    def register_dex_for mod, dex, method = :include
      @_dex_registered_dexes ||= {}
      dexes = @_dex_registered_dexes[mod] ||= []
      dexes << InjectableDep.new(mod, dex, method)
    end
  end
end

ActiveSupport::Dependencies.send :include, Dex::Injection
ActiveSupport::Dependencies.send :extend, Dex::Injection