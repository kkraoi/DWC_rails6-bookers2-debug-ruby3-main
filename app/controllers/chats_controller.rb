class ChatsController < ApplicationController
  before_action :block_non_related_users, only: [:show]

  # チャットルーム表示のアクション
  def show
    # チャット相手のユーザを取得
    @user = User.find(params[:id])

    # 現在のユーザーが参加しているチャットルーム一覧の取得
    rooms = current_user.user_rooms.pluck(:room_id)

    # 相手ユーザーとの共有チャットルームが存在するか確認。
    user_rooms = UserRoom.find_by(user_id: @user.id, room_id: rooms)
    p "🦀 #{user_rooms}"

    #ここまでの流れ。例えば下記のようなテーブルになっているとして。
    # user_rooms
    # | user_id | room_id |
    # | :------- | :------- |
    # | 1        | 1        |
    # | 1        | 2        |
    # | 2        | 1        |
    # | 3        | 5        |
    # | 4        | 8        |
    # current_userは1、@userは2だとすると、
    # rooms = [1, 2]となる
    # ①UserRoom.find_by(user_id: 2 => {user_id: 2, room_id: 1}となる。
    # ②UserRoom.find_by(room_id: [1, 2]) だと↓のようなレコードが候補となる。
    # | 1        | 1        |
    # | 1        | 2        |
    # | 2        | 1        |
    # user_id: 2 かつ room_id: 1 か 2 の両方満たすレコードは
    # | 2        | 1        |
    # とうことで、UserRoom.find_by(user_id: @user.id, room_id: rooms)は
    # {user_id: 2, room_id: 1} のような感じとなる。

    unless user_rooms.nil?
      # 共有チャットルームが存在する場合、そのチャットルームをインスタンス変数で渡す
      @room = user_rooms.room
    else
      # 共有チャットルームが存在しない場合、新しいチャットルームを作成
      @room = Room.new
      @room.save

      # チャットルームに現在のユーザーと相手ユーザーを追加
      UserRoom.create(user_id: current_user.id, room_id: @room.id)
      UserRoom.create(user_id: @user.id, room_id: @room.id)
    end

    # チャットルームに関連付けられたメッセージを取得
    @chats = @room.chats

    # 新しいメッセージを作成するための空のChatオブジェクトを生成
    @chat = Chat.new(room_id: @room.id)
  end

  # チャットメッセージの送信するアクション
  def create
    # フォームから送信されたメッセージを取得し、現在のユーザーに関連付けて保存
    @chat = current_user.chats.new(chat_params)

    # バリデーションに合格しない場合はエラーを表示
    render :validate unless @chat.save
  end

  # チャットメッセージの削除するアクション
  def destroy
    # ログイン中のユーザーに関連するチャットメッセージを削除
    @chat = current_user.chats.find(params[:id])
    @chat.destroy
  end

  private

  # フォームからのパラメータを制限
  def chat_params
    params.require(:chat).permit(:message, :room_id)
  end

  def block_non_related_users
    # チャット相手のユーザを取得
    user = User.find(params[:id])

    # ユーザーが互いにフォローしているか
    unless current_user.following?(user) && user.following?(current_user)
      # していなければ、前の画面にリダイレクト
      redirect_to request.referer
    end
  end
end
