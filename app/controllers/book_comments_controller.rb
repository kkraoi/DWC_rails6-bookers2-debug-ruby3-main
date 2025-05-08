class BookCommentsController < ApplicationController
  def create
    # コメント対象の本を定義
    post_book = Book.find(params[:book_id])

    # ユーザーに紐づいたコメントに、対象の本を紐づける
    @comment = current_user.book_comments.new(book_comment_params)

    # コメントのbook_idを登録
    @comment.book_id = post_book.id
    @comment.save
  end

  def destroy
    @comment = BookComment.find(params[:id])
    @comment.destroy
  end

  private

  # フォーム入力内容をcommentのみ許容し、それを返す
  def book_comment_params
    params.require(:book_comment).permit(:comment)
  end
end
