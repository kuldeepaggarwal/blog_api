module ApiHelper
  include Rack::Test::Methods
  include Rails.application.routes.url_helpers
  include PaginationHelpers

  def default_url_options
    {}
  end

  def app
    Rails.application
  end

  def params
    HashWithIndifferentAccess.new(last_request.params)
  end

  private
    def meta_attributes(collection)
      if collection.is_a?(Array)
        collection = paginate(collection)
      end
      super
    end
end
