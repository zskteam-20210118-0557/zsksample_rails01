require 'rails_helper'

RSpec.describe '/users', type: :request do
  describe 'GET /index' do
    before do
      FactoryBot.create :user
      get users_path
    end

    it 'リクエストが成功すること' do
      expect(response.status).to eq 200
    end

    it 'ユーザー名とメールアドレスが表示されていること' do
      expect(response.body).to include 'hoge'
      expect(response.body).to include 'hoge@example.com'
    end
  end

  describe 'GET #show' do
    before do
      user = FactoryBot.create :user
      get user_path(user.id)
    end

    context 'ユーザーが存在する場合' do
      it 'リクエストが成功すること' do
        expect(response.status).to eq 200
      end

      it 'ユーザー名とメールアドレスが表示されていること' do
        expect(response.body).to include 'hoge'
        expect(response.body).to include 'hoge@example.com'
      end
    end

    context 'ユーザーが存在しない場合' do
      it 'エラーが表示されること' do
        expect { get user_path User.count + 1 }.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end

  describe 'GET /new' do
    before do
      get new_user_path
    end

    it 'リクエストが成功すること' do
      expect(response.status).to eq 200
    end
  end

  describe 'GET /edit' do
    before do
      user = FactoryBot.create :user
      get edit_user_path user.id
    end

    it 'リクエストが成功すること' do
      expect(response.status).to eq 200
    end

    it 'ユーザー名とメールアドレスが表示されていること' do
      expect(response.body).to include 'hoge'
      expect(response.body).to include 'hoge@example.com'
    end
  end

  describe 'POST /create' do
    context 'パラメータが妥当な場合' do
      it 'リクエストが成功すること' do
        post users_path, params: { user: FactoryBot.attributes_for(:user) }
        expect(response.status).to eq 302
      end

      it 'ユーザーが登録されること' do
        expect { post users_path, params: { user: FactoryBot.attributes_for(:user) } }.to change { User.count }.by(1)
      end

      it 'リダイレクトすること' do
        post users_path, params: { user: FactoryBot.attributes_for(:user) }
        expect(response).to redirect_to User.first
      end
    end

    context 'パラメータが不正な場合' do
      it 'リクエストが成功すること' do
        post users_path, params: { user: FactoryBot.attributes_for(:user, name: '') }
        expect(response.status).to eq 200
      end

      it 'エラーが表示されること' do
        post users_path, params: { user: FactoryBot.attributes_for(:user, name: '') }
        expect(response.body).to include 'prohibited this user from being saved'
      end
    end
  end

  describe 'PATCH /update' do
    context 'パラメータが妥当な場合' do
      it 'リクエストが成功すること' do
        user = FactoryBot.create :user
        patch user_path(user.id), params: { user: FactoryBot.attributes_for(:user, name: 'ユーザーA') }
        expect(response.status).to eq 302
      end

      it 'ユーザー名が更新されること' do
        user = FactoryBot.create :user
        expect { patch user_path(user.id), params: { user: FactoryBot.attributes_for(:user, name: 'ユーザーA') } }
          .to change { User.find(user.id).name }.from('hoge').to('ユーザーA')
      end

      it 'リダイレクトすること' do
        user = FactoryBot.create :user
        patch user_path(user.id), params: { user: FactoryBot.attributes_for(:user, name: 'ユーザーA') }
        expect(response).to redirect_to User.first
      end
    end

    context 'パラメータが不正な場合' do
      it 'リクエストが成功すること' do
        user = FactoryBot.create :user
        patch user_path(user.id), params: { user: FactoryBot.attributes_for(:user, name: '') }
        expect(response.status).to eq 200
      end

      it 'ユーザー名が変更されないこと' do
        user = FactoryBot.create :user
        expect { patch user_path(user.id), params: { user: FactoryBot.attributes_for(:user, name: '') } }
          .to_not(change { user.name })
      end

      it 'エラーが表示されること' do
        user = FactoryBot.create :user
        patch user_path(user.id), params: { user: FactoryBot.attributes_for(:user, name: '') }
        expect(response.body).to include 'prohibited this user from being saved'
      end
    end
  end

  describe 'DELETE /destroy' do
    before do
      @user = FactoryBot.create :user
    end

    it 'リクエストが成功すること' do
      delete user_path @user
      expect(response.status).to eq 302
    end

    it 'ユーザーが削除されること' do
      expect do
        delete user_path @user
      end.to change(User, :count).by(-1)
    end

    it 'ユーザー一覧にリダイレクトすること' do
      delete user_path @user
      expect(response).to redirect_to(users_path)
    end
  end
end
