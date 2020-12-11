require 'rails_helper' #RSpecを利用する際に、共通の設定を書いておくファイルで共通の設定やメソッドを適用します。

RSpec.describe Tweet, type: :model do
  before do
    @tweet = FactoryBot.build(:tweet)
  end

  describe 'ツイートの保存' do #describeは「●●についての記述」と言う意味
    context "ツイートが保存できる場合" do #contextは「どういう条件でテストをおこなうか」を書く
      it "画像とテキストがあればツイートは保存される" do #itは「どのような結果になることを試しているのか」example（イグザンプル）→itに書くような「こうなるはず」の例を整理することを意味する。
        expect(@tweet).to be_valid # 「expect(@tweet).to be_valid」→「@tweetが正しい（valid）であることを期待する」
        #「expect(X).to eq Y」は「Xの結果はYになる」eqは＝と覚えればいい
      end
      it "テキストのみあればツイートは保存される" do #itは「どのような結果になることを試しているのか」
        @tweet.image = ""
        expect(@tweet).to be_valid
      end
    end
    context "ツイートが保存できない場合" do
      it "テキストがないとツイートは保存できない" do
        @tweet.text = "" #データを作成
        @tweet.valid? #21行目で作成されたデータが保存できるものなのかを確認
        #valid?はバリデーションが動きオブジェクトにエラーが無い場合trueが返される。※反対の意味でinvalid?がある
        expect(@tweet.errors.full_messages).to include("Text can't be blank") #includesは、@tweet.errors.full_messagesに"Text can't be blank"の文字列が含まれているかどうかを確認。
        #@tweetがvalid?で出たエラーをerrorsで表示し、full_messagesでエラーメッセージを出力する。
      end
      it "ユーザーが紐付いていないとツイートは保存できない" do #"ユーザーが紐付いていないとツイートは保存できない"ことを試す記述
        @tweet.user = nil #データを作成
        @tweet.valid? #データが正しく保存できるものかを確認。
        expect(@tweet.errors.full_messages).to include("User must exist") #includes()は、expect(X).to include(Y)の様に使用する。「t@weet.errors.full_messagesの中に"User must exist"という文字列が含まれているかどうか」を確認する。
        #@tweetがvalid?で出たエラーをerrorsで表示し、full_messagesでエラーメッセージを出力する。
        #valid?によってfalseと判定されたデータには、"Nickname can't be blank"（ニックネームは空欄ではいけない） というエラーメッセージが格納されている
      end
    end
  end
end