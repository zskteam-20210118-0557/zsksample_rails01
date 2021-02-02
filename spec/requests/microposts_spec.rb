require 'rails_helper'

RSpec.describe '/microposts', type: :request do
  describe 'GET /index' do
    before do
      FactoryBot.create :micropost
      get microposts_path
    end

    it 'リクエストが成功すること' do
      expect(response.status).to eq 200
    end

    it '投稿内容が表示されていること' do
      expect(response.body).to include 'MyText'
    end
  end

  describe 'GET #show' do
    before do
      micropost = FactoryBot.create :micropost
      get micropost_path(micropost.id)
    end

    context '投稿が存在する場合' do
      it 'リクエストが成功すること' do
        expect(response.status).to eq 200
      end

      it '投稿内容とユーザーidが表示されていること' do
        expect(response.body).to include 'MyText'
      end
    end
  end
  context '投稿が存在しない場合' do
    it 'エラーが表示されること' do
      expect { get micropost_path 100 }.to raise_error ActiveRecord::RecordNotFound
    end
  end
end

describe 'GET /new' do
  before do
    get new_micropost_path
  end

  it 'リクエストが成功すること' do
    expect(response.status).to eq 200
  end
end

describe 'GET /edit' do
  before do
    micropost = FactoryBot.create :micropost
    get edit_micropost_path micropost.id
  end

  it 'リクエストが成功すること' do
    expect(response.status).to eq 200
  end

  it '投稿内容とユーザーidが表示されていること' do
    expect(response.body).to include 'MyText'
  end
end

describe 'POST /create' do
  context 'パラメータが妥当な場合' do
    it 'リクエストが成功すること' do
      post microposts_path, params: { micropost: FactoryBot.attributes_for(:micropost) }
      expect(response.status).to eq 302
    end

    it '投稿が登録されること' do
      expect do
        post microposts_path,
             params: { micropost: FactoryBot.attributes_for(:micropost) }
      end .to change { Micropost.count }.by(1)
    end

    it 'リダイレクトすること' do
      post microposts_path, params: { micropost: FactoryBot.attributes_for(:micropost) }
      expect(response).to redirect_to Micropost.last
    end
  end

  context 'パラメータが不正な場合' do
    it 'リクエストが成功すること' do
      post microposts_path, params: { micropost: FactoryBot.attributes_for(:micropost, content: '') }
      expect(response.status).to eq 200
    end

    it 'エラーが表示されること' do
      post microposts_path, params: { micropost: FactoryBot.attributes_for(:micropost, content: '') }
      expect(response.body).to include 'prohibited this micropost from being saved'
    end
  end
end

describe 'PATCH /update' do
  context 'パラメータが妥当な場合' do
    it 'リクエストが成功すること' do
      micropost = FactoryBot.create :micropost
      patch micropost_path(micropost.id),
            params: { micropost: FactoryBot.attributes_for(:micropost, content: 'MyText2') }
      expect(response.status).to eq 302
    end

    it '投稿内容が更新されること' do
      micropost = FactoryBot.create :micropost
      expect do
        patch micropost_path(micropost.id),
              params: { micropost: FactoryBot.attributes_for(:micropost, content: 'MyText2') }
      end
        .to change { Micropost.find(micropost.id).content }.from('MyText').to('MyText2')
    end

    it 'リダイレクトすること' do
      micropost = FactoryBot.create :micropost
      patch micropost_path(micropost.id), params: { micropost: FactoryBot.attributes_for(:micropost, name: 'ユーザーA') }
      expect(response).to redirect_to Micropost.last
    end
  end

  context 'パラメータが不正な場合' do
    it 'リクエストが成功すること' do
      micropost = FactoryBot.create :micropost
      patch micropost_path(micropost.id), params: { micropost: FactoryBot.attributes_for(:micropost, content: '') }
      expect(response.status).to eq 200
    end

    it '投稿内容が変更されないこと' do
      micropost = FactoryBot.create :micropost
      expect do
        patch micropost_path(micropost.id),
              params: { micropost: FactoryBot.attributes_for(:micropost, content: '') }
      end
        .to_not(change { micropost.content })
    end

    it 'エラーが表示されること' do
      micropost = FactoryBot.create :micropost
      patch micropost_path(micropost.id), params: { micropost: FactoryBot.attributes_for(:micropost, content: '') }
      expect(response.body).to include 'prohibited this micropost from being saved'
    end
  end
end

describe 'DELETE /destroy' do
  before do
    @micropost = FactoryBot.create :micropost
  end

  it 'リクエストが成功すること' do
    delete micropost_path @micropost
    expect(response.status).to eq 302
  end

  it '投稿が削除されること' do
    expect do
      delete micropost_path @micropost
    end.to change(Micropost, :count).by(-1)
  end

  it '投稿一覧にリダイレクトすること' do
    delete micropost_path @micropost
    expect(response).to redirect_to(microposts_path)
  end
end
