require 'rails_helper'

RSpec.describe 'ユーザー新規登録', type: :system do
  before do
    @user = FactoryBot.build(:user)
  end
  context 'ユーザー新規登録ができるとき' do
    it '正しい情報を入力すればユーザー新規登録ができてトップページに移動する' do
      # トップページに移動する
      visit root_path #visit 〇〇_pathのように記述すると、〇〇のページへ遷移することを表現できます
      # トップページにサインアップページへ遷移するボタンがある
      expect(page).to have_content('新規登録') #visitで訪れた先のページの見える分だけの情報が格納されています。「ログアウト」などのカーソルを合わせてはじめて見ることができる文字列はpageの中に含まれません。
      # expect(page).to have_content('X')と記述すると、visitで訪れたpageの中に、Xという文字列があるかどうかを判断する。
      # 新規登録ページへ移動する
      visit new_user_registration_path
      # ユーザー情報を入力する
      fill_in 'Nickname', with: @user.nickname #fill_in 'フォームの名前', with: '入力する文字列'のように記述することで、フォームへの入力を行うことができます。
      fill_in 'Email', with: @user.email #Emailのフォームに@userのemailカラムの文字列を入れる
      fill_in 'Password', with: @user.password
      fill_in 'Password confirmation', with: @user.password_confirmation
      # サインアップボタンを押すとユーザーモデルのカウントが1上がる
      expect{
        find('input[name="commit"]').click #find("クリックしたい要素").clickと記述することで、実際にクリックができるようになる。
        #検証でinputを見るとname="commit"と書いてある。つまりinput要素のname属性を指定。
      }.to change { User.count }.by(1) #expect{ "何かしらの動作" }.to change { モデル名.count }.by(1)と記述することによって、モデルのレコードの数がいくつ変動するのかを確認できます。changeマッチャでモデルのカウントをする場合のみ、expect()ではなくexpect{}となります。
      # expect()とexpect{}の違い→http://libitte.hatenablog.jp/entry/20141129/1417251425 何かしらの動作→送信ボタンをクリックした時。すなわち、find('input[name="commit"]').clickが入ります。
      # トップページへ遷移する
      expect(current_path).to eq root_path #current_pathは現在いるページのpath
      #expect(current_path).to eq root_pathと記述すれば「今いるページがroot_pathであること」を確認できます
      # カーソルを合わせるとログアウトボタンが表示される
      expect(
        find(".user_nav").find("span").hover #find("ブラウザ上の要素").hoverとすることで、特定の要素にカーソルをあわせたときの動作を再現できます。
              #ログアウトボタンはヘッダーの中のspan要素をhoverすることで現れます。しかし、span要素は他でも使われているため、その親要素のuser_navクラスもあわせて指定します
      ).to have_content('ログアウト')
      # サインアップページへ遷移するボタンやログインページへ遷移するボタンが表示されていない
      expect(page).to have_no_content('新規登録') #have_no_contentはhave_contentの逆で、文字列が存在しないことを確かめるマッチャです。
      expect(page).to have_no_content('ログイン')
    end
  end
  context 'ユーザー新規登録ができないとき' do
    it '誤った情報ではユーザー新規登録ができずに新規登録ページへ戻ってくる' do
      #トップページに移動
      visit root_path
      # トップページにサインアップページへ遷移するボタンがある
      expect(page).to have_content('新規登録')
      # 新規登録ページへ移動する
      visit new_user_registration_path
      # ユーザー情報を入力する
      fill_in 'Nickname', with: ""
      fill_in 'Email', with: ""
      fill_in 'Password', with: ""
      fill_in 'Password confirmation', with: ""
      # サインアップボタンを押してもユーザーモデルのカウントは上がらない
      expect{
        find('input[name="commit"]').click
      }.to change { User.count }.by(0) #{ User.count }.by(0)としてレコードの数が変わらないこと（変化が0であること）を確かめています。
      # 新規登録ページへ戻される
      expect(current_path).to eq "/users"
      #新規登録がうまくいかなかった時はトップページには遷移せずに、新規登録ページに再度戻されます。新規登録ページのURLは/usersとなるので、正しく戻されているかどうかを確認しています。
    end
  end
end

RSpec.describe 'ログイン', type: :system do
  before do
    @user = FactoryBot.create(:user)
  end
  context 'ログインができるとき' do
    it '保存されているユーザーの情報と合致すればログインができる' do
      # トップページに移動する
      visit root_path
      # トップページにログインページへ遷移するボタンがある
      expect(page).to have_content('ログイン')
      # ログインページへ遷移する
      visit new_user_session_path
      # 正しいユーザー情報を入力する
      fill_in 'Email', with: @user.email
      fill_in 'Password', with: @user.password
      # ログインボタンを押す
      find('input[name="commit"]').click
      # トップページへ遷移する
      expect(current_path).to eq root_path
      # カーソルを合わせるとログアウトボタンが表示される
      expect(
        find(".user_nav").find("span").hover
      ).to have_content('ログアウト')
      # サインアップページへ遷移するボタンやログインページへ遷移するボタンが表示されていない
      expect(page).to have_no_content('新規登録')
      expect(page).to have_no_content('ログイン')
    end
  end
  context 'ログインができないとき' do
    it '保存されているユーザーの情報と合致しないとログインができない' do
      # トップページに移動する
      visit root_path
      # トップページにログインページへ遷移するボタンがある
      expect(page).to have_content('ログイン')
      # ログインページへ遷移する
      visit new_user_session_path
      # ユーザー情報を入力する
      fill_in 'Email', with: ""
      fill_in 'Password', with: ""
      # ログインボタンを押す
      find('input[name="commit"]').click
      # ログインページへ戻される
      expect(current_path).to eq new_user_session_path
    end
  end
end
