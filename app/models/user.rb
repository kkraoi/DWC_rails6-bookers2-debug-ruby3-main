class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books
  has_one_attached :profile_image
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy

  # フォローしている関連づけ：active_relationshipsという関連名で、follower_idを外部キーとしてRelationshipモデルと関連づけ。
  has_many :active_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy

  # フォローされている関連付け
  has_many :passive_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy

  # フォローしているユーザーを参照: followingsという関連名でactive_relationshipsを経由してfollowedと関連づける
  has_many :followings, through: :active_relationships, source: :followed

  # フォロワーを参照
  has_many :followers, through: :passive_relationships, source: :follower

  validates :name, length: { minimum: 2, maximum: 20 }, uniqueness: true
  validates :introduction, length: { maximum: 50 }

  # 指定したユーザーをフォローする。
  #
  # @param param [User] フォローしたいユーザーのインスタンス
  # @return [Void]
  def follow(user)
    # active_relationshipsテーブルのfollower_idカラムにフォローしたいユーザーのidを登録する
    active_relationships.create(followed_id: user.id)
  end

  # 指定したユーザーをフォローから外す
  #
  # @param param [Type] フォローから外したいユーザー
  # @return [Void]
  def unfollow(user)
    # active_relationshipsテーブルからフォローをはずしたいユーザーのidを持つ行を削除する
    active_relationships.find_by(followed_id: user.id).destroy
  end

  # 指定したユーザーをフォローしているかどうか
  #
  # @param param [Type] 確かめたいユーザーのインスタンス
  # @return [Bool] フォローしていればTrue
  def following?(user)
    followings.include?(user)
  end

  # 検索方法(method)に応じたレコードを取得する
  #
  # @param content [String] 検索するキーワード
  # @param method [String] 検索方法 ("perfect" | "forward" | "backward" | その他(部分検索))
  # @return [ActiveRecord::Relation] 検索結果のレコード集合
  def self.search_for(content, method)
    search_by_attribute(:name, content, method)
  end
  
  def get_profile_image
    (profile_image.attached?) ? profile_image : 'no_image.jpg'
  end
end
