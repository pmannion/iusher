class UserNotifier < ActionMailer::Base
  default from: "iusher.response@gmail.com"

  def friend_requested(user_friendship_id)
    user_friendship = UserFriendship.find(user_friendship_id)

    @user = user_friendship.user
    @friend = user_friendship.friend

    mail to: @friend.email,
         subject: "#{@user.first_name} wants to be an iUsher contact"

  end

  def friend_request_accepted(user_friendship_id)
    user_friendship = UserFriendship.find(user_friendship_id)

    @user = user_friendship.user
    @friend = user_friendship.friend

    mail to: @user.email,
         subject: "#{@friend.first_name} is now an iUsher contact"


  end


end


