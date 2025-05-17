class Contact < ApplicationRecord
  belongs_to :user
  has_many :phone_numbers, dependent: :destroy

  accepts_nested_attributes_for :phone_numbers, allow_destroy: true

  validates :name, presence: true
  validates :name, presence: true, uniqueness: { scope: :user_id, message: "must be unique per user" }

end
