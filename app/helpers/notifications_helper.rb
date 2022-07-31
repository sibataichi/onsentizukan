module NotificationsHelper

	def notification_form(notification)
		@visitor = notification.visitor
		#コメントを毎回nilにすることでバグを回避する、前のコメントが悪さする可能性がある為。
		@comment = nil
		your_post = link_to 'あなたの投稿', post_path(notification), style:"font-weight: bold;"
		@visitor_comment = notification.comment_id
		#notification.actionがfollowかlikeかcommentか
		case notification.action
		when "follow" then
			tag.a(notification.visitor.name, href:user_path(id: @visitor.id), style:"font-weight: bold;")+"があなたをフォローしました"
		when "favorite" then
			tag.a(notification.visitor.name, href:user_path(id: @visitor.id), style:"font-weight: bold;")+"が"+tag.a('あなたの投稿', href:post_path(notification.post_id), style:"font-weight: bold;")+"にいいねしました"
		when "comment" then
			@comment = Comment.find_by(id: @visiter_comment)&.content
			tag.a(@visitor.name, href:user_path(id: @visitor.id), style:"font-weight: bold;")+"が"+tag.a('あなたの投稿', href:post_path(notification.post_id), style:"font-weight: bold;")+"にコメントしました"
		end
	end

	#通知未確認の場合 headerに黄色いマーク点灯するよう記述している
	def unchecked_notifications
    @notifications = current_user.passive_notifications.where(checked: false)
    end
end