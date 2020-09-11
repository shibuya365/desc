User.create!(name: "Guest", password: "123456", password_confirmation: "123456")

User.create!(name: "Example User", password: "foobar", password_confirmation: "foobar")

99.times do |n|
  name  = Faker::Name.name
  password = "password"
  User.create!(name: name, password: password, password_confirmation: password)
end

users = User.order(:created_at).take(6)
50.times do
  content = Faker::Lorem.sentence(5)
  users.each { |user| user.posts.create!(content: content) }
end

# likes
users = User.all
user  = users.first
posts = Post.all
touch_posts = posts[1..50]
touch_posts.each { |p|
  user.like_posts << p
}

