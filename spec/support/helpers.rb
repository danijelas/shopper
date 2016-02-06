RSpec.configure do |config|
  config.include Features::SessionHelpers, type: :feature
  config.include ControllerMacros, type: :controller
  config.include SelectizeHelpers, type: :feature
end
