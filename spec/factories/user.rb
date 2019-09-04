FactoryBot.define do
  factory :user do
    name {'Bobb' }
    address { '234 A st' }
    city { 'Wonderland' }
    state { 'CA' }
    zip { 90345 }
    email { 'bobb@gmail.com' }
    password { 'supersafe' }
  end
end
