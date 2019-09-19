require 'rails_helper'


RSpec.describe 'Posts', type: :request do
  
  describe 'GET /posts' do 
    before {get '/posts'}

    it 'should return OK' do 
      payload = JSON.parse(response.body)
      expect(payload).to be_empty
      expect(response).to have_http_status(200)
    end
  end

  #Factory boot - {create_list(:post, 10, published: true)  }
  #Rspec -  let(:posts)
  #let! early
  #let lazy evaluation
  describe 'with data in the DB' do
    let!(:posts) { create_list(:post, 10, published: true) }
    before {get '/posts'}
    it 'should return all the published posts' do 
      payload = JSON.parse(response.body)
      expect(payload.size).to eq(posts.size)
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /post{id}' do 
    let!(:post) { create(:post) }

    it 'should return a post' do 
      get "/posts/#{post.id}"
      payload = JSON.parse(response.body)
      expect(payload).to_not be_empty
      expect(payload["id"]).to eq(post.id)
      expect(payload["title"]).to eq(post.title)
      expect(payload["content"]).to eq(post.content)
      expect(payload["published"]).to eq(post.published)
      expect(payload["author"]["name"]).to eq(post.user.name)
      expect(payload["author"]["email"]).to eq(post.user.email)
      expect(payload["author"]["id"]).to eq(post.user.id)
      expect(response).to have_http_status(200)
    end
  end

  describe 'POST /post' do 
    let!(:user) {create(:user)}
    
    it 'should create a post' do 
      req_payload = {
        post: {
          title: "titulo",
          content: "content",
          published: false,
          user_id: user.id
        }
      }
      # POST HTTP
      post '/posts', params: req_payload
      payload = JSON.parse(response.body)
      expect(payload).to_not be_empty
      expect(payload['id']).to_not be_nil
      expect(response).to have_http_status(:created)
    end

    it 'should return error menssage on invalid post' do 
      req_payload = {
        post: {
          content: "content",
          published: false,
          user_id: user.id
        }
      }
      # POST HTTP
      post '/posts', params: req_payload
      payload = JSON.parse(response.body)
      expect(payload).to_not be_empty
      expect(payload['error']).to_not be_empty
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end 

  describe 'PUT /post/{id}' do 
    let!(:article) {create(:post)}
    
    it 'should update a post' do 
      req_payload = {
        post: {
          title: "titulo",
          content: "content",
          published: false,
        }
      }
      # POST HTTP
      put "/posts/#{article.id}", params: req_payload
      payload = JSON.parse(response.body)
      expect(payload).to_not be_empty
      expect(payload['id']).to eq(article.id)
      expect(response).to have_http_status(:ok)
    end

    it 'should return error menssage on invalid post update' do 
      req_payload = {
        article: {
          title: nil,
          content: nil,
          published: false
        }
      }
      # POST HTTP
      put "/posts/#{article.id}", params: req_payload
      payload = JSON.parse(response.body)
      expect(payload).to_not be_empty
      expect(payload['error']).to_not be_empty
      expect(response).to have_http_status(:internal_server_error)
    end
  end 
end