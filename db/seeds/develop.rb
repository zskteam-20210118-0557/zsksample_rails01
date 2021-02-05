# メインのサンプルユーザーを1人作成する
User.create!(name: 'Example User',
             email: 'example@railstutorial.org')

# 追加のユーザーをまとめて生成する
99.times do |n|
  name  = Faker::Name.name
  email = "example-#{n + 1}@railstutorial.org"
  User.create!(name: name,
               email: email)
end
