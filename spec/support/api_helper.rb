module ApiHelper
  include Rack::Test::Methods
  include Rails.application.routes.url_helpers

  def default_url_options
    {}
  end

  def app
    Rails.application
  end
end
