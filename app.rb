require 'sinatra'
require 'json'
require 'base64'
require 'google/cloud/storage'
require "google/cloud/secret_manager"

set :bind, "0.0.0.0"
port = ENV["PORT"] || "8080"
set :port, port

post "/" do
  p 'requested'
  p ENV["SHORT_SHA"]
  # params = JSON.parse request.body.read
  p 'params --------'
  p params
  # p Base64.decode64(params['message']['data'])

  storage = Google::Cloud::Storage.new
  bucket = storage.bucket ENV["BUCKET"]
  project_id = ENV["PROJECT_ID"]

  client = Google::Cloud::SecretManager.secret_manager_service
  key = client.secret_version_path project: project_id, secret: 'sample-secret', secret_version: 'latest'
  p 'key - = = = = = ='
  p key
  res = client.access_secret_version name: key
  p 'secret - = = = = = ='
  p res.payload
  p res.payload.data

  local_file_path = "./Gemfile"
  storage_file_path = "Gemfile"

  file = bucket.create_file local_file_path, storage_file_path
  p file

  name = ENV["NAME"] || "World"
  "Hello #{name}!"
  status 200
end
