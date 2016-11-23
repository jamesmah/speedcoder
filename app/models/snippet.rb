class Snippet < ApplicationRecord
  belongs_to :user
  has_many :attempts, dependent: :destroy

end
