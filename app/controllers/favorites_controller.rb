class FavoritesController < ApplicationController
  def create
    # 投稿された本を定義
    post_book = Book.find(params[:book_id])

    # user_idが紐づいたfavoritesテーブルに、book_idを投稿された本で登録
    favorite = current_user.favorites.new(book_id: post_book.id)
    favorite.save

    # 本のshowページにリダイレクト
    redirect_to books_path
  end

  def destroy
    # 投稿された本を定義
    post_book = Book.find(params[:book_id])

    # user_idが紐づいたfavoritesテーブルから、投稿された本を探し出し、
    favorite = current_user.favorites.find_by(book_id: post_book.id)
    # 削除する
    favorite.destroy

    # 本のshowページにリダイレクト
    redirect_to books_path
  end
end
