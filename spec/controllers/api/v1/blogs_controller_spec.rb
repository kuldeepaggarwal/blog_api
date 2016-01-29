require 'rails_helper'

RSpec.describe Api::V1::BlogsController, type: :api do
  let(:admin) { FactoryGirl.create(:user, :admin) }
  let(:blogger) { FactoryGirl.create(:user, :blogger) }

  describe '#index' do
    let!(:blogs) { FactoryGirl.create_list(:blog, 2) }
    let(:response) do
      ActiveModel::ArraySerializer.new(
        blogs,
        each_serializer: Api::V1::BlogSerializer,
        root: 'blogs',
        meta: meta_attributes(blogs)
      ).to_json
    end

    shared_examples_for 'guest_index_visit' do
      it 'returns all the blogs details' do
        get api_v1_blogs_path
        expect(last_response.body).to eq(response)
      end
    end

    context 'when guest' do
      it_behaves_like 'guest_index_visit'
    end

    context 'when blogger' do
      sign_in(:blogger)

      it_behaves_like 'guest_index_visit'
    end

    context 'when admin' do
      sign_in(:admin)

      it_behaves_like 'guest_index_visit'
    end
  end

  describe '#show' do
    let(:blog) { FactoryGirl.create(:blog) }
    let(:response) { Api::V1::BlogSerializer.new(blog).to_json }

    shared_examples_for 'guest_show_visit' do
      it 'returns blog details' do
        get api_v1_blog_path(blog)
        expect(last_response.body).to eq(response)
      end
    end

    context 'when guest' do
      it_behaves_like 'guest_show_visit'
    end

    context 'when blogger' do
      sign_in(:blogger)

      it_behaves_like 'guest_show_visit'
    end

    context 'when admin' do
      sign_in(:admin)

      it_behaves_like 'guest_show_visit'
    end
  end

  describe '#create' do
    let(:blog_attributes) { FactoryGirl.attributes_for(:blog) }
    let(:response) { Api::V1::BlogSerializer.new(blog).to_json }

    shared_examples_for 'user_creates_blog' do
      context 'when valid paramaters' do
        let(:blog) { Blog.last }
        before do
          post api_v1_user_blogs_path(user, params: { blog: blog_attributes })
        end

        it 'returns 201 status code' do
          expect(last_response.status).to eq(201)
        end

        it 'returns blog details' do
          expect(last_response.body).to eq(response)
        end
      end

      context 'when invalid paramaters' do
        before do
          post api_v1_user_blogs_path(user, params: { blog: { title: '' } })
        end

        it 'returns 422 status code' do
          expect(last_response.status).to eq(422)
        end

        it 'returns error messages' do
          errors = ["Title can't be blank", "Description can't be blank"]
          expect(last_response.body).to eq(errors.to_json)
        end
      end
    end

    context 'when guest' do
      before do
        post api_v1_user_blogs_path(blogger, params: { blog: blog_attributes })
      end

      it 'returns authentication error' do
        expect(last_response.status).to eq(401)
      end
    end

    context 'when blogger' do
      sign_in(:blogger)

      context 'when creating for self' do
        let(:user) { blogger }

        it_behaves_like 'user_creates_blog'
      end

      context 'when creating for other' do
        before do
          post api_v1_user_blogs_path(admin, params: { blog: blog_attributes })
        end

        it 'returns unauthorized error' do
          expect(last_response.status).to eq(403)
        end
      end
    end

    context 'when admin' do
      sign_in(:admin)

      context 'when creating for self' do
        let(:user) { admin }

        it_behaves_like 'user_creates_blog'
      end

      context 'when creating for other' do
        let(:user) { blogger }

        it_behaves_like 'user_creates_blog'
      end
    end
  end

  describe '#update' do
    let(:blog) do
      _blog = FactoryGirl.build(:blog).tap do |blog|
        blog.author = user if defined?(user)
      end
      _blog.save!
      _blog
    end
    let(:blog_attributes) { blog.attributes }
    let(:response) { Api::V1::BlogSerializer.new(blog).to_json }

    shared_examples_for 'user_updates_blog' do
      context 'when valid paramaters' do
        before do
          put api_v1_blog_path(blog, params: { blog: blog_attributes })
        end

        it 'returns 200 status code' do
          expect(last_response.status).to eq(200)
        end

        it 'returns blog details' do
          expect(last_response.body).to eq(response)
        end
      end

      context 'when invalid paramaters' do
        before do
          put api_v1_blog_path(blog, params: { blog: { title: '' } })
        end

        it 'returns 422 status code' do
          expect(last_response.status).to eq(422)
        end

        it 'returns error messages' do
          errors = ["Title can't be blank"]
          expect(last_response.body).to eq(errors.to_json)
        end
      end
    end

    context 'when guest visits' do
      before do
        put api_v1_blog_path(blog, params: { blog: blog_attributes })
      end

      it 'returns authentication error' do
        expect(last_response.status).to eq(401)
      end
    end

    context 'when blogger visits' do
      sign_in(:blogger)

      context 'when updating for self' do
        let(:user) { blogger }

        it_behaves_like 'user_updates_blog'
      end

      context 'when updating for other' do
        let(:user) { admin }

        before do
          put api_v1_blog_path(blog, params: { blog: blog_attributes })
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

        it_behaves_like 'user_updates_blog'
      end

      context 'when updating for other' do
        let(:user) { blogger }

        it_behaves_like 'user_updates_blog'
      end
    end
  end

  describe '#destroy' do
    let(:blog) do
      _blog = FactoryGirl.build(:blog).tap do |blog|
        blog.author = user if defined?(user)
      end
      _blog.save!
      _blog
    end
    let(:response) { { message: 'resource deleted successfully' }.to_json }

    shared_examples_for 'user_deletes_blog' do
      context 'when successful' do
        before do
          delete api_v1_blog_path(blog)
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

    context 'when guest visits' do
      before do
        delete api_v1_blog_path(blog)
      end

      it 'returns authentication error' do
        expect(last_response.status).to eq(401)
      end
    end

    context 'when blogger visits' do
      sign_in(:blogger)

      context 'when deleting for self' do
        let(:user) { blogger }

        it_behaves_like 'user_deletes_blog'
      end

      context 'when deleting for other' do
        let(:user) { admin }

        before do
          delete api_v1_blog_path(blog)
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

        it_behaves_like 'user_deletes_blog'
      end

      context 'when deleting for other' do
        let(:user) { blogger }

        it_behaves_like 'user_deletes_blog'
      end
    end
  end
end
