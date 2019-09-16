FactoryBot.define do
  factory :order do
    sequence(:name) {|x| "Name #{x}"}
    sequence(:created_at) {|x| "Created at: #{x}"}
    sequence(:updated_at) {|x| "Last Update: #{x}"}
    user
  end
end
