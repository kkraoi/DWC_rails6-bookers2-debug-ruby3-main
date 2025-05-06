class Relationship < ApplicationRecord
  # フォローされているユーザー：followerという関連名としてUserモデルと関連付ける。実態としてfollower_idを外部キーとして、Userモデルと参照を行う。
  belongs_to :follower, class_name: "User"

  # フォローしているユーザー
  belongs_to :followed, class_name: "User"
end
