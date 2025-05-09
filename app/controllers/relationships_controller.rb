class RelationshipsController < ApplicationController
  # ログインしていない時にアクセスするとログイン画面へ遷移
  before_action :authenticate_user!

  def create
    # フォロー対象のユーザーを特定・定義
    user = User.find(params[:user_id])

    # 指定したユーザーをフォローする
    current_user.follow(user)

    # 今いる画面にリダイレクト
    redirect_to request.referer
  end

  def destroy
    # フォロー対象のユーザーを特定・定義
    user = User.find(params[:user_id])

    # 指定したユーザーのフォローを解除する
    current_user.unfollow(user)

    # 今いる画面にリダイレクト
    redirect_to request.referer
  end

  def followings
    # 対象のユーザーを特定・定義
    user = User.find(params[:user_id])

    # フォローしているユーザー一覧をインスタンス変数に格納
    @users = user.followings
  end

  def followers
    # 対象のユーザーを特定・定義
    user = User.find(params[:user_id])

    # フォロワー一覧をインスタンス変数に格納
    @users = user.followers
  end

  private
end
