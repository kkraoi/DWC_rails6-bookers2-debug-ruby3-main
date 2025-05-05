class Book < ApplicationRecord
  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy
  validates :title,presence:true
  validates :body,presence:true,length:{maximum:200}

  # ユーザーのオブジェクトを代入し、favoritesテーブルにそのユーザーidが存在するか、真偽値を返す。
  #
  # @param param [User] ユーザーのオブジェクト
  # @return [Bool] ユーザーidがfavoritesテーブルに存在したらTrue
  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end
end
