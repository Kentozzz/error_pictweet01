FactoryBot.define do
  factory :tweet do
    text {Faker::Lorem.sentence}
    image {Faker::Lorem.sentence}
    association :user #users.rbのFactoryBotとアソシエーションがあることを意味します。
    #（↑UserはTweetを必ず持っているわけではないので、users.rbには記述しません）
  end
end