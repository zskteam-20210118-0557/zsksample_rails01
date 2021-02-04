require 'rails_helper'

RSpec.describe Micropost, type: :model do
  let(:user) { create(:user) }
  let(:micropost) { create(:micropost, user_id: user.id) }

  context 'バリデーション' do
    it 'マイクロポストが有効である' do
      expect(micropost).to be_valid
    end

    it 'コンテントがない場合は無効である' do
      micropost = build(:micropost, content: '    ')
      micropost.valid?
      expect(micropost.errors[:content]).to include("can't be blank")
    end

    it 'ユーザーがない場合は無効である' do
      micropost = build(:micropost, user_id: nil)
      micropost.valid?
      expect(micropost.errors[:user_id]).to include("can't be blank")
    end

    it 'コンテントが140文字以内であること' do
      micropost = build(:micropost, content: 'a' * 141)
      micropost.valid?
      expect(micropost.errors[:content]).to include('is too long (maximum is 140 characters)')
    end
  end
end
