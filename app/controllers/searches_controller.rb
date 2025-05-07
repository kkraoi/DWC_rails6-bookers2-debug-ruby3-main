class SearchesController < ApplicationController
  before_action :authenticate_user!

  def search
    # ?model= の値を取得
    @model = params[:model]
    # ?content= の値を取得
    @content = params[:content]
    # ?method= の値を取得
    @method = params[:method]

    if @model == "user"
      @records = User.search_for(@content, @method)
    else
      @records = Book.search_for(@content, @method)
    end
  end
end
