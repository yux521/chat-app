require 'rails_helper'

RSpec.describe "Users", type: :system do
  it 'ログインしていない状態でトップページにアクセスした場合、サインインページに移動する' do
    # トップページに遷移する
    visit root_path
    # ログインしていない場合、サインインページに遷移していることを確認する

     expect(current_path).to eq new_user_session_path
  end

  it 'ログインに成功し、トップページに遷移する' do
    # 予め、ユーザーをDBに保存する
    # 解説：データベースにcreateメソッドでユーザーをテスト用のDBに保存します。保存したユーザーで、この後ログインを行います。
    @user = FactoryBot.create(:user)

    # サインインページへ移動する
    visit  new_user_session_path
    # ログインしていない場合、サインインページに遷移していることを確認する
    expect(current_path).to eq new_user_session_path
    # 解説：保存したユーザーは、ログインを行っていないので、ログイン画面に遷移します。


    # すでに保存されているユーザーのemailとpasswordを入力する
    fill_in 'user_email', with: @user.email
    fill_in 'user_password', with: @user.password
    # ログインボタンをクリックする
    click_on("Log in")
    # 解説：保存したユーザーの「メールアドレス」「パスワード」をfill_inメソッドで入力を行います。入力後に、click_onメソッドで「Log in」をクリックしてログインをします。

    # トップページに遷移していることを確認する
    expect(current_path).to eq root_path
    # 解説：expectメソッドを用いて、ログインページ（current_path）から、トップページ（root_path）に遷移していることを確認しています。
  end


  it 'ログインに失敗し、再びサインインページに戻ってくる' do
    # 予め、ユーザーをDBに保存する
    @user = FactoryBot.create(:user)
    # 解説：データベースにcreateメソッドでユーザーを保存します。保存したユーザーで、この後ログインを行います。


    # トップページに遷移する
    visit root_path
    # ログインしていない場合、サインインページに遷移していることを確認する
    expect(current_path).to eq new_user_session_path


    # 誤ったユーザー情報を入力する
    fill_in 'user_email', with: "test"
    fill_in 'user_password', with: "test"
    # ログインボタンをクリックする
    click_on("Log in")
    # 解説①：テストではログインに失敗する挙動を、確認することが目的です。したがって、データベースに保存されている、「メールアドレス」「パスワード」とは異なる値を入力します。
    # 解説②：この際に、確実に失敗する必要があるので、どちらも"test"という文字列を入力しています。

    # サインインページに戻ってきていることを確認する
    expect(current_path).to eq new_user_session_path

  end
end
