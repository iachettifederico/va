$:.unshift(File.expand_path("../lib/", __dir__))
require "va"

Matest.configure do |config|
  config.use_color
end
