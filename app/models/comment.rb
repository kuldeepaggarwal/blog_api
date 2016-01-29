class Comment < ApplicationRecord
  # Validations
  belongs_to :blog
  belongs_to :creator, class_name: :User

  # Validations
  validates :text, presence: true
end
