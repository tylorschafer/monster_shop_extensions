FactoryBot.define do
  factory :item do
    sequence(:name) {|x| "Name #{x}"}
    sequence(:description) {|x| "description: #{x}"}
    sequence(:price) {|x| x * 5}
    sequence(:image) {|x| "fake_image_url"}
    sequence(:inventory) {|x| x * 10}
    sequence(:created_at) {|x| "Created at: #{x}"}
    sequence(:updated_at) {|x| "Last Update: #{x}"}
    merchant
  end
end
