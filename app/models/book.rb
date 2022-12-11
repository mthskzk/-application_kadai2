class Book < ApplicationRecord
  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :post_comments, dependent: :destroy
  validates :title,presence:true
  validates :body,presence:true,length:{maximum:200}
  validates :score, presence:true
  validates :score, numericality: {
    less_than_or_equal_to: 5,
    greater_than_or_equal_to: 1
  }

  scope :latest, -> {order(created_at: :desc)}
  scope :old, -> {order(created_at: :asc)}
  scope :score_count, -> {order(score: :desc)}

  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

  def self.looks(search, word)
    if search == "perfect_match"
      @book=Book.where("title LIKE?", "#{word}")
    elsif search == "forward_match"
      @book=Book.where("title LIKE?", "#{word}%")
    elsif search == "backward_match"
      @book=Book.where("title LIKE?", "%#{word}")
    elsif search == "partial_match"
      @book=Book.where("title LIKE?", "%#{word}%")
    else
      @book=Book.all
    end
  end

end
