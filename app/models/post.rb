class Post < ApplicationRecord
   has_one_attached :image
   belongs_to :genre
   belongs_to :user
   has_many :comments, dependent: :destroy
   has_many :favorites, dependent: :destroy
   has_many :notifications, dependent: :destroy
   #地図機能
   geocoded_by :address
   after_validation :geocode, if: :address_changed?
   #バリデーション
   validates :title, presence: true
   validates :body, presence: true
   validates :image, presence: true
   validates :address, presence: true

   #いいね機能
   def favorited_by?(user)
     favorites.exists?(user_id: user.id)
   end

   #通知機能
   def create_notification_by(current_user)
      notification = current_user.active_notifications.new(
         post_id: id,
         visited_id: user_id,
         action: "favorite"
      )
      notification.save if notification.valid?
   end
   def create_notification_comment!(current_user, comment_id)
      # 自分以外にコメントしている人をすべて取得し、全員に通知を送る
      temp_ids = Comment.select(:user_id).where(post_id: id).where.not(user_id: current_user.id).distinct
      temp_ids.each do |temp_id|
         save_notification_comment!(current_user, comment_id, temp_id['user_id'])
      end
      # まだ誰もコメントしていない場合は、投稿者に通知を送る
      save_notification_comment!(current_user, comment_id, user_id) if temp_ids.blank?
   end
   def save_notification_comment!(current_user, comment_id, visited_id)
      # コメントは複数回することが考えられるため、１つの投稿に複数回通知する
      notification = current_user.active_notifications.new(
         post_id: id,
         comment_id: comment_id,
         visited_id: visited_id,
         action: 'comment'
       )
     # 自分の投稿に対するコメントの場合は、通知済みとする
     if notification.visitor_id == notification.visited_id
        notification.checked = true
     end
     notification.save if notification.valid?
   end

   #ジャンル機能
   def self.genre_search(search_genre)
     Post.where(genre_id: search_genre)
   end
end