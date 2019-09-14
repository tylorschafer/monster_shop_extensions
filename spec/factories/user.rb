FactoryBot.define do
  factory :user do
    before(:create) do |user|
      user.addresses << create(:address, user: user)
    end
    sequence(:name) {|x| "Name #{x}"}
    sequence(:email) {|x| "email #{x}"}
    sequence(:password) {|x| "password#{x}"}
    role { 1 }
    association :merchant, factory: :merchant
  end
end
