class FavoriteMailer < ApplicationMailer
  default from: "favorites@kostia-dojit.herokuapp.com"

  def new_comment(user, post, comment)

    headers["Message-ID"] = "<comments/#{comment.id}@kostia-dojit.herokuapp.com"
    headers["In-Reply-To"] = "<post/#{post.id}@kostia-dojit.herokuapp.com"
    headers["References"] = "<post/#{post.id}@kostia-dojit.herokuapp.com"

    @user = user
    @post = post
    @comment = comment

    mail(to: user.email, subject: "New comment on #{post.title}")
  end
end
