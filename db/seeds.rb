ItemOrder.destroy_all
Order.destroy_all
Address.destroy_all
Review.destroy_all
Item.destroy_all
User.destroy_all
Coupon.destroy_all
Merchant.destroy_all

#merchants
bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
dog_shop = Merchant.create(name: "Sue's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
pug_lyfe_records = Merchant.create(name: "Pug Lyfe Records", address: '125 McPuggo Lane', city: 'Denver', state: 'CO', zip: 80216)
larrys_bath_house = Merchant.create(name: "Larry's Bath House", address: '125 Fatboi Court', city: 'Denver', state: 'CO', zip: 80216)

#bike_shop items
tire = bike_shop.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
lights = bike_shop.items.create(name: "Blinky Lights", description: "They are super bright and blinky!", price: 43, image: "https://images-na.ssl-images-amazon.com/images/I/81NBFtp5HGL._SX466_.jpg", inventory: 8)
horn = bike_shop.items.create(name: "Honky Horn", description: "Let everyone know you mean business!", price: 27, image: "https://static.evanscycles.com/production/bike-accessories/bells--horns/product-image/484-319/electra-bicycle-horn-black-silver-EV322701-8575-1.jpg", inventory: 4)

#bike_shop coups
bike_shop.coupons.create(name: 'bigdeal', coupon_type: :percent, rate: 30)
bike_shop.coupons.create(name: 'littledeal', coupon_type: :percent, rate: 5)
bike_shop.coupons.create(name: 'noway', coupon_type: :dollar, rate: 55)

#dog_shop items
pull_toy = dog_shop.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
dog_bone = dog_shop.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", inventory: 21)
collar = dog_shop.items.create(name: "Chaco Collar", description: "Dogs love name brand stuff too!", price: 35, image: "https://www.rei.com/media/3ef543ea-9b63-4f97-9c24-e5f2d4de4b85?size=784x588", inventory: 21)
stache = dog_shop.items.create(name: "Humunga Stache", description: "Make your dog look like an old-timey gentleman!", price: 19, image: "https://www.glamourmutt.com/thumbnail.asp?file=assets/images/stache1.jpg&maxx=300&maxy=0", inventory: 21)
pugtato = dog_shop.items.create(name: "Baked Pugtato", description: "Feeds a family of four!", price: 300, image: "https://i.redd.it/l6od6xh0e9jy.jpg", inventory: 2)

#dog_shop coups
dog_shop.coupons.create(name: 'dogdeal', coupon_type: :percent, rate: 25)
dog_shop.coupons.create(name: 'sweetsale', coupon_type: :percent, rate: 15)
dog_shop.coupons.create(name: 'pooch', coupon_type: :dollar, rate: 100)

#pug_lyfe items
pug_lyfe = pug_lyfe_records.items.create(name: "Respekt da Hustle (and treats)", description: "Hip Hop isn't dead", price: 20, image: "https://cdn.shopify.com/s/files/1/1869/0319/products/artwork_2Fz9cKcghIoyvemWkc1vCv-YBM41z0Oo079n1UnHV5N-OEnIIoR0vasFcNcuRO27-color-black_571x_crop_center.png?v=1522944906", inventory: 6)
music_lessons = pug_lyfe_records.items.create(name: "Band of Pugs", description: "A private serenade by this cute boi", price: 200, image: "https://i.redd.it/jixotthmobwz.jpg", inventory: 90)

#pug_lyfe coups
pug_lyfe_records.coupons.create(name: 'wowza', coupon_type: :percent, rate: 16)
pug_lyfe_records.coupons.create(name: 'puglyfe', coupon_type: :dollar, rate: 80)
pug_lyfe_records.coupons.create(name: 'pughugs', coupon_type: :percent, rate: 75)

#bath house items
cut = larrys_bath_house.items.create(name: "Cut", description: "just a cut.. no style", price: 10, image: "https://hipms.files.wordpress.com/2007/11/d8af4-wig21.jpg", inventory: 100)
cut_style = larrys_bath_house.items.create(name: "Cut n' Style", description: "beautify ur puggo", price: 50, image: "https://i.pinimg.com/originals/78/d6/c7/78d6c742fd95d4ace577d0aa89f77e94.png", inventory: 100)
bath_time = larrys_bath_house.items.create(name: "Bath Time", description: "So fresh and so clean, clean", price: 50, image: "https://i.ytimg.com/vi/fTtwE6iXCIM/maxresdefault.jpg", inventory: 100)

#bath house coups
larrys_bath_house.coupons.create(name: 'clean', coupon_type: :percent, rate: 35)
larrys_bath_house.coupons.create(name: 'wowsale', coupon_type: :dollar, rate: 45)
larrys_bath_house.coupons.create(name: 'blackfriday', coupon_type: :dollar, rate: 300)

#Users
user = User.create(name: 'Bob', email: 'bob@email.com', password: 'bob', password_confirmation: 'bob', role: 1)
joe = dog_shop.users.create(name: 'Joe', email: 'joe@email.com', password: 'joe', password_confirmation: 'joe', role: 2)
moe = dog_shop.users.create(name: 'Moe', email: 'moe@email.com', password: 'moe', password_confirmation: 'moe', role: 2)
sue = dog_shop.users.create(name: 'Sue', email: 'sue@email.com', password: 'sue', password_confirmation: 'sue', role: 3)
larry = larrys_bath_house.users.create(name: 'Larrold McFatty', email: 'larry@email.com', password: 'larry', password_confirmation: 'larry', role: 3)
biggie = pug_lyfe_records.users.create(name: 'Biggie Smalls', email: 'big@email.com', password: 'big', password_confirmation: 'big', role: 3)
meg = bike_shop.users.create(name: 'Meg MooPants', email: 'meg@email.com', password: 'meg', password_confirmation: 'meg', role: 3)
admin = User.create(name: 'admin', email: 'admin@email.com', password: 'admin', password_confirmation: 'admin', role: 4)

#orders
evette = User.create(name: 'Evette McEvette', email: 'evette@email.com', password: 'bob', password_confirmation: 'bob', role: 1)
evette_address = evette.addresses.create(nickname: 'Home', street: '123 Evette Street', city: 'Denver', state: 'CO', zip: '12345')
order_1 = evette.orders.create(name: "Evette McEvette", address: evette_address)
io1 = ItemOrder.create(item: pull_toy, order: order_1, price: pull_toy.price, quantity: 5)
io2 = ItemOrder.create(item: dog_bone, order: order_1, price: dog_bone.price, quantity: 2)
order_2 = evette.orders.create(name: "Evette McEvette", address: evette_address)
io3 = ItemOrder.create(item: cut_style, order: order_2, price: cut_style.price, quantity: 1)
io4 = ItemOrder.create(item: pug_lyfe, order: order_2, price: pug_lyfe.price, quantity: 2)

fenton = User.create(name: 'Fenton McFenton', email: 'fenty@email.com', password: 'bob', password_confirmation: 'bob', role: 1)
fenton_address = fenton.addresses.create(nickname: 'School', street: '123 Fenton Street', city: 'Denver', state: 'CO', zip: '12345')
order_3 = fenton.orders.create(name: "Fenton McFenton", address: fenton_address)
io5 = ItemOrder.create(item: stache, order: order_3, price: stache.price, quantity: 1)
io6 = ItemOrder.create(item: cut, order: order_3, price: cut.price, quantity: 6)

tylor = User.create(name: 'Tylor McTylor', email: 'tylor@email.com', password: 'bob', password_confirmation: 'bob', role: 1)
tylor_address = tylor.addresses.create(nickname: 'Work', street: '666 Tylor Street', city: 'Austin', state: 'TX', zip: '51423')
order_4 = tylor.orders.create(name: "Tylor McTylor", address: tylor_address)
io7 = ItemOrder.create(item: bath_time, order: order_4, price: bath_time.price, quantity: 1)
io8 = ItemOrder.create(item: music_lessons, order: order_4, price: music_lessons.price, quantity: 3)
