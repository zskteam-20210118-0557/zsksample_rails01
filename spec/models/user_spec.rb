require 'rails_helper'

RSpec.describe User, type: :model do

  it "名前,メールアドレスがある場合は有効である" do
    user = User.new(
      name: "shinozaki",
      email: "shino@sample.com"
    )
    expect(user).to be_valid
  end

  it "名前がない場合は無効である" do
    user = User.new(
      name: nil,
      email: "shino@sample.com"
    )
    user.valid?
    expect(user.errors[:name]).to include("can't be blank")
  end

  it "メールアドレスがない場合は無効である"  do
    user = User.new(
      name: "shinozaki",
      email: nil
    )
    user.valid?
    expect(user.errors[:email]).to include("can't be blank")
  end

  it "名前が50文字以内であること"  do
    user =  User.new(
      name: "a"*51
    )
    user.valid?
    expect(user.errors[:name]).to include("is too long (maximum is 50 characters)")
  end

  it "重複したメールアドレスの場合、無効である" do
    user = User.create(
      name: "shinozaki",
      email: "shino@sample.com"
    )
    other_user = User.create(
      name: "shinohara",
      email: "shino@sample.com"
    )
    other_user.valid?
    expect(other_user.errors[:email]).to include("has already been taken")
  end

  it "メールアドレスが255文字以内であること" do
    user =  User.new(
      name: "shinozaki",
      email: "a"*256
    )
    user.valid?
    expect(user.errors[:email]).to include("is too long (maximum is 255 characters)")
  end

  it "メールアドレスは小文字で保持されること" do
    email = "Shino@Sample.cOm"
    user = User.create(
      name: "shinozaki",
      email: email
    )
    expect(user.email).to eq email.downcase
  end
end