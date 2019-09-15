FactoryBot.define do
  factory :address do
    sequence(:nickname) {|x| "Nickname #{x}"}
    sequence(:address) {|x| "Address #{x}"}
    sequence(:city) {|x| "City #{x}"}
    sequence(:state) {|x| "State #{x}"}
    zip {rand(10000..99999)}
  end
end