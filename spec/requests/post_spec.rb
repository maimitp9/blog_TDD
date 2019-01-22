require 'rails_helper'
require 'byebug'

RSpec.describe  'post page', type: :request do
  
	context 'render post page' do
    let(:post) { create(:post) }
		it 'render post page with a slug' do
			get "/posts/#{post.slug}"
			expect(response).to  render_template(:show)
			expect(response.body).to include(post.title)
		end
	end

	context 'new post' do
		let(:user) { create(:user) }
    
    it 'redirect to sign in when unauthenticated' do
      get '/posts/new'
      expect(response).to redirect_to new_user_session_path
    end

    it 'render new post when authenticated' do
      sign_in(user)
      get '/posts/new'
      expect(response).to render_template(:new)
      expect(response.body).to include('New Post')
    end
  end

  context 'create post' do
    let(:user) { create(:user) }
    let(:post_attributes) { attributes_for(:post) }

    it 'Does not create post when unauthenticated' do
      post '/posts', params: { post: post_attributes }
      expect(response).to redirect_to new_user_session_path
    end

    it 'Does create post when authenticated' do
      sign_in(user)
      post '/posts', params: { post: post_attributes }
      expect(response).to redirect_to(assigns(:post))
      follow_redirect!
      expect(response).to render_template(:show)
      expect(response.body).to include(post_attributes[:title])
    end
  end

  context 'edit post' do
    let(:post) { create(:post) }
    let(:user) { create(:user) }

    it 'redirect to login page when unauthenticated' do
      get "/posts/#{post.slug}/edit"
      expect(response).to redirect_to new_user_session_path
    end

    it 'edit page when authenticated' do
      sign_in(user)
      get "/posts/#{post.slug}/edit"
      expect(response).to render_template(:edit)
      expect(response.body).to include('Edit Post')
    end
  end

  context 'update post' do
    let(:post) { create(:post) }
    let(:user) { create(:user) }
    let(:post_attributes) { attributes_for(:post) }

    it 'redirect to login when unauthenticated' do
      put "/posts/#{post.slug}"
      expect(response).to redirect_to new_user_session_path
    end

    it 'update post when authenticated' do
      sign_in(user)
      put "/posts/#{post.slug}", params: { post: post_attributes }
      expect(response).to redirect_to(assigns(:post))
      follow_redirect!
      post.reload
      expect(response).to render_template(:show)
      expect(response.body).to include(post_attributes[:title])
      expect(post.title).to eq(post_attributes[:title])
    end
  end

  context 'delete post' do
    let(:post) { create(:post) }
    let(:user) { create(:user) }
    
    it 'redirect to login when unauthenticated' do
      delete "/posts/#{post.slug}"
      expect(response).to redirect_to new_user_session_path
    end

    it 'delete post when authenticated' do
      sign_in(user)
      delete "/posts/#{post.slug}"
      expect(response).to redirect_to posts_path
      expect(Post.find_by(slug: post.slug)).to eq(nil)
    end
  end
end