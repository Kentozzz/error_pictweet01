require 'rails_helper'

describe TweetsController, type: :request do

  before do
    @tweet = FactoryBot.create(:tweet) #今回は予めtweetが保存されている状態にしたいのでcreateで保存しておく。
  end

  describe "GET #index" do
    it "indexアクションにリクエストすると正常にレスポンスが返ってくる" do
      get root_path #indexアクションにリクエストを送るためにroot_pathと記述する
      expect(response.status).to eq 200
      #response→リクエストに対するレスポンスそのものが含まれます
      #response.statusでレスポンスのstatusコードを取得できる
    end
    it "indexアクションにリクエストするとレスポンスに投稿済みのツイートのテキストが存在する" do
      get root_path
      expect(response.body).to include @tweet.text #response.bodyに@tweet.textが含まれているかどうかを確かめます
      #response.bodyと記述すると、ブラウザに表示されるHTMLの情報を抜き出すことができます。binding.pryで見れる
    end
    it "indexアクションにリクエストするとレスポンスに投稿済みのツイートの画像URLが存在する" do
      get root_path
      expect(response.body).to include @tweet.image #response.bodyに@tweet.imageが含まれているかどうかを確かめます
    end
    it "indexアクションにリクエストするとレスポンスに投稿検索フォームが存在する" do
      get root_path
      expect(response.body).to include "投稿を検索する" #検索フォームの「投稿を検索する」という文言がレスポンスに含まれているか
    end
  end

  describe "GET #show" do
    it "showアクションにリクエストすると正常にレスポンスが返ってくる" do
      get tweet_path(@tweet)
      expect(response.status).to eq 200
    end
    it "showアクションにリクエストするとレスポンスに投稿済みのツイートのテキストが存在する" do
      get tweet_path(@tweet)
      expect(response.body).to include @tweet.text
    end
    it "showアクションにリクエストするとレスポンスに投稿済みのツイートの画像URLが存在する" do
      get tweet_path(@tweet)
      expect(response.body).to include @tweet.image
    end
    it "showアクションにリクエストするとレスポンスにコメント一覧表示部分が存在する" do
      get tweet_path(@tweet)
      expect(response.body).to include "＜コメント一覧＞"
    end
  end
end
