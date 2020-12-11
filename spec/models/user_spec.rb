require 'rails_helper'

describe User do
  before do #beforeはテストコードをおこなう前にセットアップする記述。今回は@userというインスタンス変数を作成している
    @user = FactoryBot.build(:user) #変数はインスタンス変数にする必要があります。
    #このセットアップのおかげで各itの各コードにFactory_botを書かなくてよくなる
  end

  describe 'ユーザー新規登録' do #「'ユーザー新規登録'についての記述」
    context '新規登録がうまくいくとき' do #「"規登録がうまくいくとき"という条件でテストをおこなう」
      it "nicknameとemail、passwordとpassword_confirmationが存在すれば登録できる" do
        expect(@user).to be_valid #「@userがvalid(正しい)く保存されることを判断
      end
      it "nicknameが6文字以下で登録できる" do
        @user.nickname = "aaaaaa"
        expect(@user).to be_valid #「@userがvalid(正しい)く保存されることを判断
      end
      it "passwordが6文字以上であれば登録できる" do
        @user.password = "000000"
        @user.password_confirmation = "000000"
        expect(@user).to be_valid #「@userがvalid(正しい)く保存されることを判断
      end
      it "2名のuserが登録できる" do
        @user1 = FactoryBot.create(:user)
        @user2 = FactoryBot.build(:user)
        expect(@user2).to be_valid #「@userがvalid(正しい)く保存されることを判断
      end
    end

    context '新規登録がうまくいかないとき' do
      it "nicknameが空だと登録できない" do
        @user.nickname = ''
        @user.valid? #作成したデータが保存できるものかどうかを確認する。
        expect(@user.errors.full_messages).to include("Nickname can't be blank")
      end
      it "nicknameが7文字以上であれば登録できない" do
        @user.nickname = "aaaaaaa"
        @user.valid?
        expect(@user.errors.full_messages).to include("Nickname is too long (maximum is 6 characters)")
      end
      it "emailが空では登録できない" do
        @user.email = "" #データ作成
        @user.valid? #作成したデータが保存できるものかどうかを確認する。
        expect(@user.errors.full_messages).to include("Email can't be blank")
        #@user.errors.full_messagesの中に"Email can't be blank"の文字列が含まれているかどうかを確認。
      end
      it "重複したemailが存在する場合登録できない" do
        @user.save
        another_user = FactoryBot.build(:user) #Userのインスタンス作成
        #↑FactoryBotを使用しない場合user = User.new(nickname: "abe", email: "kkk@gmail.com", password: "00000000", password_confirmation: "00000000")と書かなければいけない。
        #user.rbにFactoryBotの記述をしているのでanother_user = FactoryBot.build(:user)と書くだけでいい。
        #buildは.newと同じ意味。
        another_user.email = @user.email
        another_user.valid?
        expect(another_user.errors.full_messages).to include("Email has already been taken")
      end
      it "passwordが空では登録できない" do
        @user.password = ""
        @user.valid?
        expect(@user.errors.full_messages).to include("Password can't be blank")
      end
      it "passwordが5文字以下であれば登録できない" do
        @user.password = "00000"
        @user.password_confirmation = "00000"
        @user.valid?
        expect(@user.errors.full_messages).to include("Password is too short (minimum is 6 characters)")
      end
      it "passwordが存在してもpassword_confirmationが空では登録できない" do
        @user.password_confirmation = ""
        @user.valid?
        expect(@user.errors.full_messages).to include("Password confirmation doesn't match Password")
      end
    end
  end
end
