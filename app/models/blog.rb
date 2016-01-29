class Blog < ApplicationRecord
  # Associations
  belongs_to :author, foreign_key: :user_id, class_name: :User
  has_many :comments, dependent: :destroy

  # Validations
  validates :title, :description, presence: true
end
