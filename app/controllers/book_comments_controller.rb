class BookCommentsController < ApplicationController
  def create
    # コメント対象の本を定義
    post_book = Book.find(params[:book_id])

    # ユーザーに紐づいたコメントに、対象の本を紐づける
    comment = current_user.book_comments.new(post_book_params)

    # コメントのbook_idを登録
    comment.book_id = post_book.id
    comment.save

    # アクションを行う前の画面に遷移する
    redirect_to request.referer
  end

  private

  # フォーム入力内容をcommentのみ許容し、それを返す
  def post_book_params
    params.require(:book_comment).permit(:comment)
  end
end
