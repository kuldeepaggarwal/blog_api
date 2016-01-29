class Blog < ApplicationRecord
  # Associations
  belongs_to :author, foreign_key: :user_id, class_name: :User

  # Validations
  validates :title, :description, presence: true
end
