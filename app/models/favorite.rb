class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :book

  # {scope: :book_id} <= book_idごとに
  validates :user_id, uniqueness: {scope: :book_id}
end
