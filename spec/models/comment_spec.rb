require 'rails_helper'

describe Comment do
  include TestFactories

  describe "after_create" do
    before do
      $redis.select 1
      $redis.flushdb
      
      @post = associated_post
      @user = authenticated_user
      @comment = Comment.new(body: 'My comment', post_id: @post.id, user_id: 10000)
    end
    
    context "with user's permission" do
      it "send an email to users who have favorited the post" do
        @user.favorite(@post.id)

        allow(FavoriteMailer)
          .to receive(:new_comment)
          .with(@user, @post, @comment)
          .and_return( double(deliver: true))

        @comment.save
      end

      it "does not send emails to users who haven't" do
        expect(FavoriteMailer)
          .not_to receive(:new_comment)

        @comment.save
      end
    end

    context "without permission" do
      before {@user.update_attribute(:email_favorites, false)}

      it "does not send emails, end to users who have favorited" do
        @user.favorite(@post.id)

        expect( FavoriteMailer )
          .not_to receive(:new_comment)

        @comment.save
      end
    end

  end
end