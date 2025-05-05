class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :book

  # {scope: :post_image_id} <= post_image_idごとに
  validates user_id, uniqueness: {scope: :post_image_id}
end
