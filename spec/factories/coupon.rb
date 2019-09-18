FactoryBot.define do
  factory :coupon do
    sequence(:name) {|x| "Name #{x}"}
    sequence(:rate) {|x| rand(1..5) * x}
  end
end
