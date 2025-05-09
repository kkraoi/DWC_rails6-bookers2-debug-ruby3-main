class BooksController < ApplicationController
  # ログインしていない時にアクセスするとログイン画面へ遷移
  before_action :authenticate_user!

  # 他人のアクセス防止
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]

  def show
    @book = Book.find(params[:id])
    @newbook = Book.new
    @book_comment = BookComment.new
  end

  def index
    # コントローラで1週間絞り込みをする場合
    # to = Time.current.at_end_of_day
    # from = (to - 6.day).at_beginning_of_day
    # @books = Book.includes(:favorites).sort_by { |book|
    #   -book.favorites.where(created_at: from..to).count 
    # }

    @books =  Book.includes(:favorites).sort_by { |book|
      -book.week_favorites.count
    }

    @book = Book.new
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      redirect_to book_path(@book), notice: "You have created book successfully."
    else
      @books = Book.all
      render 'index'
    end
  end

  def edit
  end

  def update
    if @book.update(book_params)
      redirect_to book_path(@book), notice: "You have updated book successfully."
    else
      render "edit"
    end
  end

  def destroy
    @book.destroy
    redirect_to books_path
  end

  private

  def book_params
    # フォームの入力はtitleとbodyカラムのみ許容
    params.require(:book).permit(:title, :body) 
  end

  def ensure_correct_user
    @book = Book.find(params[:id])
    unless @book.user == current_user
      redirect_to books_path
    end
  end
end
