class User < ApplicationRecord
  # External Method Calls
  has_secure_password
  has_secure_token :authentication_token

  # Enums
  enum role: { guest: 3, blogger: 4, admin: 5 }

  # Validations
  validates :email, :first_name, presence: true
  with_options allow_blank: true do
    validates :email, email: true, uniqueness: { case_sensitive: false }
    validates :password, length: { minimum: 5 }
  end

  # Callbacks
  before_create :set_role_as_blogger, unless: :role
  after_destroy :prevent_last_user_deletion!

  private
    def set_role_as_blogger
      self.role = self.class.roles[:blogger]
    end

    def prevent_last_user_deletion!
      unless self.class.exists?
        error_message = %q{last user can't be deleted}
        errors.add(:base, error_message)
        raise ActiveRecord::RecordNotDestroyed, error_message
      end
    end
end
