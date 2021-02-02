require 'rails_helper'

RSpec.describe Micropost, type: :model do
  let(:micropost) { create(:micropost) }

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
  end
end
