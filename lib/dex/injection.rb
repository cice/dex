require 'active_support'
require 'active_support/dependencies'

module Dex
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
        dex_const = dex.constantize
        mod_const.send :include, dex_const
      end
    end
    
    def register_dex_for mod, dex
      @_dex_registered_dexes ||= {}
      dexes = @_dex_registered_dexes[mod] ||= []
      dexes << dex
    end
  end
end

ActiveSupport::Dependencies.send :include, Dex::Injection
ActiveSupport::Dependencies.send :extend, Dex::Injection