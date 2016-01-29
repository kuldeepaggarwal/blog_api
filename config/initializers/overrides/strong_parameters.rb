# https://github.com/rails/rails/pull/22830
module ActionController
  class Parameters
    delegate :include?, to: :@parameters
  end
end
