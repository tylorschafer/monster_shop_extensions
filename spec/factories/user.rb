FactoryBot.define do
  factory :new_user do
    sequence(:name) {|x| "Name #{x}"}
    sequence(:address) {|x| "Address #{x}"}
    sequence(:city) {|x| "City #{x}"}
    sequence(:state) {|x| "State #{x}"}
    sequence(:zip) {|x| x * 10000}
    sequence(:email) {|x| "email #{x}"}
    sequence(:password) {|x| "password#{x}"}
  end
end
