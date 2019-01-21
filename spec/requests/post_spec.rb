require 'rails_helper'
require 'byebug'

RSpec.describe  'post page', type: :request do
	let(:post) { create(:post) }
	context 'render post page' do
		it 'render post page with a slug' do
			get "/posts/#{post.slug}"
			expect(response).to  render_template(:show)
			expect(response.body).to include(post.title)
		end
	end

	context 'create new post' do
		let(:user) { create(:user) }
		let(:post_attributes) { attributes_for(:post) }

		it 'create a new post when authenticated' do
			sign_in(user)
			get '/posts/new'
			expect(response).to render_template(:new)
			expect(response.body).to include('New Post')
			post '/posts', params: { post: post_attributes }

			expect(response).to redirect_to(assigns(:post))
			follow_redirect!

			expect(response).to redirect_to(:show)
			expect(response.body).to include(post.title)
		end

		it 'dose not load a new post page when not authenticated' do
			get '/posts/new'
			expect(response).to redirect_to new_user_session_path
		end
	end
end