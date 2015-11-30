class CommentsController < ApplicationController
  def create
    @comment = Comment.new(params.require(:comment).permit(:body))
    @comment.post_id = params[:post_id].to_i

    @post = @comment.post
    @topic = @post.topic
    @comment.user_id = current_user.id if current_user


    # authorize @comment
    
    if @comment.save
      flash[:notice] = "Comment was saved."
      redirect_to [@topic, @post]
    else
      flash[:error] = "There was an error saving the comment. Please try again."
      redirect_to [@topic, @post]
    end
  end
end