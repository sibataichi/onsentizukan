class Notification < ApplicationRecord

#default_scopeで、新しい通知からデータ取得
  default_scope -> { order(created_at: :desc) }
  belongs_to :post, optional: true
  belongs_to :comment, optional: true

#optional: trueは必要な情報以外nilに格納するため、belongs_toで紐づけする際にnilを許可する記述
  belongs_to :visitor, class_name: 'User', foreign_key: 'visitor_id', optional: true
  belongs_to :visited, class_name: 'User', foreign_key: 'visited_id', optional: true

end
