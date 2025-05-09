class Book < ApplicationRecord
  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy

  # Favoriteクラス(モデル)からwhereメソッドで1週間分のレコードを取ってきて、week_favoritesという関連名で登録。
  # (Time.current.at_end_of_day - 6.day).at_beginning_of_day: 6日前の日付の開始時刻（00:00:00）を取得する
  # Time.current.at_end_of_day: 現時刻の終わりの時刻（23:59:59）を取得する
  # 「7日間」ではなく「6日間+今日」 の範囲になる
  has_many :week_favorites, -> { where(created_at: ((Time.current.at_end_of_day - 6.day).at_beginning_of_day)..(Time.current.at_end_of_day)) }, class_name: 'Favorite'
  
  validates :title,presence:true
  validates :body,presence:true,length:{maximum:200}

  # ユーザーのオブジェクトを代入し、favoritesテーブルにそのユーザーidが存在するか、真偽値を返す。
  #
  # @param param [User] ユーザーのオブジェクト
  # @return [Bool] ユーザーidがfavoritesテーブルに存在したらTrue
  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

  # 検索方法(method)に応じたレコードを取得する
  #
  # @param content [String] 検索するキーワード
  # @param method [String] 検索方法 ("perfect" | "forward" | "backward" | その他(部分検索))
  # @return [ActiveRecord::Relation] 検索結果のレコード集合
  def self.search_for(content, method)
    search_by_attribute(:title, content, method)
  end

  def self.search_for(content, method)
    search_by_attribute(:title, content, method)
  end
end
