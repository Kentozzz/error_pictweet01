FactoryBot.define do #FactoryBotを使った記述が始まるよという意味
  factory :user do #詳細データが必要ないときは、user だけ作成する
    nickname              {Faker::Name.initials(number: 2)} #Faker::Nameを使っている
    email                 {Faker::Internet.free_email } #Faker::Internetを使っている
    password              {Faker::Internet.password(min_length: 6)}
    password_confirmation {password}
  end
end