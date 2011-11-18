Bundler.require(:default, :test)

require 'rspec'

Dir[File.expand_path('../support/**/*.rb', __FILE__)].each do |file|
  require file
end

RSpec.configure do |config|
end
