class Address < ApplicationRecord
  validates_presence_of :address, :city, :state, :zip, :nickname

  belongs_to :user
end
