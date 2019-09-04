class User < ApplicationRecord
    validates_presence_of :name, :address, :city, :state, :zip
    validates_confirmation_of :password, require: true
    validates :email, presence: true, uniqueness: true
    validates :role, numericality: {only_integer: true, greater_than_or_equal_to: 0}

    enum role: {user: 1, merchant_employee: 2, merchant_admin: 3, admin: 4}

    has_secure_password
end
