require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }

  context 'バリデーション' do
    it '名前,メールアドレスがある場合は有効である' do
      expect(user).to be_valid
    end

    it '名前がない場合は無効である' do
      user = build(:user, name: nil)
      user.valid?
      expect(user.errors[:name]).to include("can't be blank")
    end

    it 'メールアドレスがない場合は無効である' do
      user = build(:user, email: nil)
      user.valid?
      expect(user.errors[:email]).to include("can't be blank")
    end

    it '名前が50文字以内であること' do
      user = build(:user, name: 'a' * 51)
      user.valid?
      expect(user.errors[:name]).to include('is too long (maximum is 50 characters)')
    end

    it '重複したメールアドレスの場合、無効である' do
      other_user = build(:user, email: user.email)
      other_user.valid?
      expect(other_user.errors[:email]).to include('has already been taken')
    end

    it 'メールアドレスが255文字以内であること' do
      user = build(:user, email: "#{'a' * 250}@sample.com")
      user.valid?
      expect(user.errors[:email]).to include('is too long (maximum is 255 characters)')
    end

    it 'メールアドレスは小文字で保持されること' do
      email = 'Shino@Sample.cOm'
      user = User.create(
        name: 'shinozaki',
        email: email
      )
      expect(user.email).to eq email.downcase
    end

    it 'メールアドレスの@前後に.があると無効である' do
      user = build(:user, email: 'shino9.@.sample.com')
      user.valid?
      expect(false).to be false
    end
  end
end
