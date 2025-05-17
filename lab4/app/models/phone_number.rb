class PhoneNumber < ApplicationRecord
  belongs_to :contact

  validates :number, presence: true, format: { with: /\A\+?\d{10,15}\z/, message: "must be a valid phone number" }
end
