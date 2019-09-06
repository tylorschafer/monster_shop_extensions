FactoryBot.define do
  factory :user do
    sequence(:name) {|x| "Name #{x}"}
    sequence(:address) {|x| "Address #{x}"}
    sequence(:city) {|x| "City #{x}"}
    sequence(:state) {|x| "State #{x}"}
    zip {rand(10000..99999)}
    sequence(:email) {|x| "email #{x}"}
    sequence(:password) {|x| "password#{x}"}
    role { 1 }
    association :merchant, factory: :merchant
  end
end
