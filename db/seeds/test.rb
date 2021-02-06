# メインのサンプルユーザーを1人作成する
User.create!(name: 'Example User',
             email: 'example@railstutorial.org')

# 追加のユーザーをまとめて生成する
99.times do |n|
  name = Faker::Name.name
  email = "example-#{n + 1}@railstutorial.org"
  User.create!(name: name,
               email: email)
end

users = User.order(:created_at).take(6)
50.times do
  content = Faker::Lorem.sentence(word_count: 5)
  users.each { |user| user.microposts.create!(content: content) }
end
