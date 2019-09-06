require 'rails_helper'

RSpec.describe 'Health endpoint', type: :request do

  describe 'GET /health' do 
    before {get '/healt'}

    it 'should return OK' do 
      payload = JSON.parse(resonse.body)
      expect(payload).not_to be_empty
      expect(payload['api']).to eq('OK')
    end

    it 'should return status code 200' do 
      payload = JSON.parse(resonse.body)
      expect(response).to have_http_status(200)
    end

  end
end