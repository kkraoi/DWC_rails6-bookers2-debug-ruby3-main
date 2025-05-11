class UsersController < ApplicationController
  # ログインしていない時にアクセスするとログイン画面へ遷移
  before_action :authenticate_user!

  # 他人のアクセス防止
  before_action :ensure_correct_user, only: [:update, :edit]

  def show
    @user = User.find(params[:id])
    @books = @user.books
    @book = Book.new

    @total_views = @books.sum(&:impressionist_count)
  end

  def index
    @users = User.all
    @book = Book.new
  end

  def edit
  end

  def update
    # ensure_correct_userをbefore_actionで読んでいるため@userを定義する必要はない
    if @user.update(user_params)
      redirect_to user_path(@user.id), notice: "You have updated user successfully."
    else
      render "edit"
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end

  # ユーザをチェック
  def ensure_correct_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path(current_user)
    end
  end
end
