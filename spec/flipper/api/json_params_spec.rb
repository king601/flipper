require 'helper'

RSpec.describe Flipper::Api::JsonParams do
  let(:app) do
    app = lambda do |env|
      request = Rack::Request.new(env)
      [200, { 'Content-Type' => 'application/json' }, [request.params.to_json]]
    end
    builder = Rack::Builder.new
    builder.use described_class
    builder.run app
    builder
  end

  describe 'json post request' do
    it 'adds request body to params' do
      response = post '/',
                      { flipper_id: 'user:2' }.to_json,
                      'CONTENT_TYPE' => 'application/json'

      params = JSON.parse(response.body)
      expect(params).to eq('flipper_id' => 'user:2')
    end

    it 'handles request bodies with multiple params' do
      response = post '/',
                      { flipper_id: 'user:2', language: 'ruby' }.to_json,
                      'CONTENT_TYPE' => 'application/json'

      params = JSON.parse(response.body)
      expect(params).to eq('flipper_id' => 'user:2', 'language' => 'ruby')
    end

    it 'handles request bodies and single query string params' do
      response = post '/?language=ruby',
                      { flipper_id: 'user:2' }.to_json,
                      'CONTENT_TYPE' => 'application/json'

      params = JSON.parse(response.body)
      expect(params).to eq('flipper_id' => 'user:2', 'language' => 'ruby')
    end

    it 'handles request bodies and multiple query string params' do
      response = post '/?language=ruby&framework=rails',
                      { flipper_id: 'user:2' }.to_json,
                      'CONTENT_TYPE' => 'application/json'

      params = JSON.parse(response.body)
      expect(params).to eq('flipper_id' => 'user:2', 'language' => 'ruby', 'framework' => 'rails')
    end

    it 'favors request body params' do
      response = post '/?language=javascript',
                      { flipper_id: 'user:2', language: 'ruby' }.to_json,
                      'CONTENT_TYPE' => 'application/json'

      params = JSON.parse(response.body)
      expect(params).to eq('flipper_id' => 'user:2', 'language' => 'ruby')
    end
  end

  describe 'url-encoded request' do
    it 'handles params the same as a json request' do
      response = post '/', flipper_id: 'user:2'
      params = JSON.parse(response.body)
      expect(params).to eq('flipper_id' => 'user:2')
    end

    it 'handles single query string params' do
      response = post '/?language=ruby', flipper_id: 'user:2'
      params = JSON.parse(response.body)
      expect(params).to eq('flipper_id' => 'user:2', 'language' => 'ruby')
    end

    it 'handles multiple query string params' do
      response = post '/?language=ruby&framework=rails', flipper_id: 'user:2'
      params = JSON.parse(response.body)
      expect(params).to eq('flipper_id' => 'user:2', 'language' => 'ruby', 'framework' => 'rails')
    end
  end
end
