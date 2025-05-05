class ApplicationController < ActionController::Base
  # ユーザ登録・ログイン認証時に下記のconfigure_permitted_parameters実行
  before_action :configure_permitted_parameters, if: :devise_controller?

  private

  # ログイン(サインイン)後にどこに遷移するかを設定するdeviseフックメソッド
  #
  # @param resource [Instance] ログインを実行したモデルのデータ、今回の場合はつまりログインしたUserのインスタンス。resource.idなどで使える
  # @return [String] ログイン(サインイン)後にリダイレクトするパス
  def after_sign_in_path_for(resource)
    flash[:notice] = "ログインに成功しました" # デフォルトのノッティス文言更新
    user_path(resource)
  end

  # サインアップ後にどこに遷移するかを設定するdeviseフックメソッド
  #
  # @param resource [Instance] サインアップを実行したモデルのデータ、今回の場合はつまりサインアップしたUserのインスタンス
  # @return [String] サインアップ後にリダイレクトするパス
  def after_sign_up_path_for(resource)
    flash[:notice] = "サインアップに成功しました"# デフォルトのノッティス文言更新
  end

  # サインアウト後にどこに遷移するかを設定しているdeviseフックメソッド
  #
  # @param param [Instance] アウトを実行したモデルのデータ、今回の場合はつまりログインしたUserのインスタンス
  # @return [String] サインアウト後にリダイレクトするパス
  def after_sign_out_path_for(resource)
    flash[:notice] = "サインアウトに成功しました" # デフォルトのノッティス文言更新
    root_path
  end

  # サインアップにemailフィールドを有効にする
  #
  # @return [void]
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email])
  end
end
