class User < ApplicationRecord
  # External Method Calls
  has_secure_password
  has_secure_token :authentication_token

  # Validations
  validates :email, :first_name, presence: true
  with_options allow_blank: true do
    validates :email, email: true, uniqueness: { case_sensitive: false }
    validates :password, length: { minimum: 5 }
  end

  # Callbacks
  after_destroy :prevent_last_user_deletion!

  private
    def prevent_last_user_deletion!
      unless self.class.exists?
        error_message = %q{last user can't be deleted}
        errors.add(:base, error_message)
        raise ActiveRecord::RecordNotDestroyed, error_message
      end
    end
end
