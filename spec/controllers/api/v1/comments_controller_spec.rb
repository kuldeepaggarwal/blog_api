require 'rails_helper'

RSpec.describe Api::V1::BlogsController, type: :api do
  let(:admin) { FactoryGirl.create(:user, :admin) }
  let(:blogger) { FactoryGirl.create(:user, :blogger) }
  let(:blog) { FactoryGirl.create(:blog) }

  describe '#index' do
    context 'when guest' do
      before { get api_v1_blog_comments_path(blog) }

      it 'returns unauthorized error' do
        expect(last_response.status).to eq(401)
      end
    end

    shared_examples_for 'logged in user who sees list of comments' do
      let!(:comments) { FactoryGirl.create_list(:comment, 2, blog: blog) }
      let(:response) do
        ActiveModel::ArraySerializer.new(
          comments,
          each_serializer: Api::V1::CommentSerializer,
          root: 'comments',
          meta: meta_attributes(comments)
        ).to_json
      end

      before { get api_v1_blog_comments_path(blog) }

      it 'returns comments for a blog' do
        expect(last_response.body).to eq(response)
      end
    end

    context 'when admin' do
      sign_in(:admin)

      it_behaves_like('logged in user who sees list of comments')
    end

    context 'when blogger' do
      sign_in(:blogger)

      it_behaves_like('logged in user who sees list of comments')
    end
  end

  describe '#create' do
    context 'when guest' do
      before { post api_v1_blog_comments_path(blog) }

      it 'returns unauthorized error' do
        expect(last_response.status).to eq(401)
      end
    end

    shared_examples_for 'logged in user who create a comment' do
      let!(:comment_attributes) { { text: "New comment" } }
      let(:response) { Api::V1::CommentSerializer.new(comment).to_json }

      context 'when valid paramaters' do
        let(:comment) { Comment.last }
        before do
          post api_v1_blog_comments_path(blog, params: { comment: comment_attributes })
        end

        it 'returns 201 status code' do
          expect(last_response.status).to eq(201)
        end

        it 'returns comment details' do
          expect(last_response.body).to eq(response)
        end
      end

      context 'when invalid paramaters' do
        before do
          post api_v1_blog_comments_path(blog, params: { comment: { text: '' } })
        end

        it 'returns 422 status code' do
          expect(last_response.status).to eq(422)
        end

        it 'returns error messages' do
          errors = ["Text can't be blank"]
          expect(last_response.body).to eq(errors.to_json)
        end
      end
    end

    context 'when admin' do
      sign_in(:admin)

      it_behaves_like('logged in user who create a comment')
    end

    context 'when blogger' do
      sign_in(:blogger)

      it_behaves_like('logged in user who create a comment')
    end
  end

  describe '#update' do
    let(:comment) do
      _comment = FactoryGirl.build(:comment).tap do |comment|
        comment.creator = user if defined?(user)
      end
      _comment.save!
      _comment
    end
    let(:comment_attributes) { { text: 'Updated comment' } }
    let(:response) { Api::V1::CommentSerializer.new(comment).to_json }

    shared_examples_for 'user_updates_comment' do
      context 'when valid paramaters' do
        before do
          put api_v1_blog_comment_path(comment.blog, comment, params: { comment: comment_attributes })
        end

        it 'returns 200 status code' do
          expect(last_response.status).to eq(200)
        end

        it 'returns blog details' do
          comment.reload
          expect(comment.text).to eq('Updated comment')
          expect(last_response.body).to eq(response)
        end
      end

      context 'when invalid paramaters' do
        before do
          put api_v1_blog_comment_path(comment.blog, comment, params: { comment: { text: '' } })
        end

        it 'returns 422 status code' do
          expect(last_response.status).to eq(422)
        end

        it 'returns error messages' do
          errors = ["Text can't be blank"]
          expect(last_response.body).to eq(errors.to_json)
        end
      end
    end

    context 'when guest' do
      before do
        put api_v1_blog_comment_path(comment.blog, comment, params: { comment: comment_attributes })
      end

      it 'returns authentication error' do
        expect(last_response.status).to eq(401)
      end
    end

    context 'when blogger' do
      sign_in(:blogger)

      context 'when updating for self' do
        let(:user) { blogger }

        it_behaves_like 'user_updates_comment'
      end

      context 'when updating for other' do
        let(:user) { admin }

        before do
          put api_v1_blog_comment_path(comment.blog, comment, params: { comment: comment_attributes })
        end

        it 'returns unauthorized error' do
          expect(last_response.status).to eq(403)
        end
      end
    end

    context 'when admins visits' do
      sign_in(:admin)

      context 'when updating for self' do
        let(:user) { admin }

        it_behaves_like 'user_updates_comment'
      end

      context 'when updating for other' do
        let(:user) { blogger }

        it_behaves_like 'user_updates_comment'
      end
    end
  end

  describe '#destroy' do
    let(:comment) do
      _comment = FactoryGirl.build(:comment).tap do |comment|
        comment.creator = user if defined?(user)
      end
      _comment.save!
      _comment
    end
    let(:response) { { message: 'resource deleted successfully' }.to_json }

    shared_examples_for 'user_deletes_comment' do
      context 'when successful' do
        before do
          delete api_v1_blog_comment_path(comment.blog, comment)
        end

        it 'returns 200 status code' do
          expect(last_response.status).to eq(200)
        end

        it 'returns blog details' do
          expect(last_response.body).to eq(response)
        end
      end

      context 'when unsuccessful' do
        pending "not possible"
      end
    end

    context 'when guest' do
      before do
        delete api_v1_blog_comment_path(comment.blog, comment)
      end

      it 'returns authentication error' do
        expect(last_response.status).to eq(401)
      end
    end

    context 'when blogger' do
      sign_in(:blogger)

      context 'when deleting for self' do
        let(:user) { blogger }

        it_behaves_like 'user_deletes_comment'
      end

      context 'when deleting for other' do
        let(:user) { admin }

        before do
          delete api_v1_blog_comment_path(comment.blog, comment)
        end

        it 'returns unauthorized error' do
          expect(last_response.status).to eq(403)
        end
      end
    end

    context 'when admins visits' do
      sign_in(:admin)

      context 'when deleting for self' do
        let(:user) { admin }

        it_behaves_like 'user_deletes_comment'
      end

      context 'when deleting for other' do
        let(:user) { blogger }

        it_behaves_like 'user_deletes_comment'
      end
    end
  end
end
