require 'spec_helper'
require 'dex/injection'

describe 'Dex' do
  before do
    ActiveSupport::Dependencies.autoload_paths << File.join(File.dirname(__FILE__), '..', 'autoload_fixtures')
    ActiveSupport::Dependencies.hook!
  end
  
  after do
    ActiveSupport::Dependencies.clear
    ActiveSupport::Dependencies.unhook!
    ActiveSupport::Dependencies.autoload_paths = []
  end
  
  describe '"load" mechanism' do
    it 'should not include non-registered dex' do
      Example1.new.should_not respond_to :example1_dexed_method
    end
    
    it 'should include registered dex' do
      RegisterDex 'Example1', 'Example1::Dex'
      Example1.new.should respond_to :example1_dexed_method
    end
    
    it 'should re-include registered dexes after reload' do
      RegisterDex 'Example1', 'Example1::Dex'
      Example1.new.should respond_to :example1_dexed_method
      
      ActiveSupport::Dependencies.clear
      Object.const_defined?(:Example1).should be false
      Example1.new.should respond_to :example1_dexed_method
    end
  end
  
  describe '"require" mechanism' do
    it 'should include decorators on load of a constant' do
      RegisterDex 'Example1', 'Example1::Dex'
      Example1.new.should respond_to :example1_dexed_method
    end
  end
  
  it 'should require decorators for nested autoloaded classes' do
    
  end
  
  describe 'include / extend confusion' do
    class IncludeExtendTest
      include ActiveSupport::Dependencies
    end
    
    it 'should use same Hash, regardless if Dependencies included as module or not' do
      test = IncludeExtendTest.new
      
      test._dex_registered_dexes.object_id.should be ActiveSupport::Dependencies._dex_registered_dexes.object_id
    end
  end
end