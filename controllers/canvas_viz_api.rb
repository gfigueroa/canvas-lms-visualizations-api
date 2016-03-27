require 'sinatra'
require 'sinatra/base'
require 'config_env'
require 'rack/ssl-enforcer'
require 'httparty'
require 'ap'
require 'concurrent'
require 'rbnacl/libsodium'
require 'json'

configure :development, :test do
  absolute_path = File.absolute_path './config/config_env.rb'
  ConfigEnv.path_to_config(absolute_path)
end

# Visualizations for Canvas LMS Classes
class CanvasVisualizationAPI < Sinatra::Base
  enable :logging
  use Rack::MethodOverride

  configure :development, :test do
    set :root, 'http://localhost:9292'
  end

  configure :production do
    use Rack::SslEnforcer
    set :session_secret, ENV['MSG_KEY']
    set :root, 'https://canvas-viz-api.herokuapp.com'
  end

  api_get_root = lambda do
    "Welcome to our API v1. Here's <a "\
    'href="https://github.com/ISS-Analytics/canvas-lms-visualizations-api">'\
    'our github homepage</a>.'
  end

  get_course_list = lambda do
    payload = BearerToken.new(env['HTTP_AUTHORIZATION'])
    halt 400 unless payload.valid?
    token = DecryptPayload.new(payload.bearer_token)
    token =
    begin
      token.call
    rescue => e
      logger.error e
      halt 401
    end
    params_for_api = ParamsForCanvasApi.new(params['url'], token)
    halt 400 unless params_for_api.valid?
    courses = GetCoursesFromCanvas.new(params_for_api.canvas_api,
                                       params_for_api.canvas_token)
    courses.call
  end

  go_to_api_with_request = lambda do
    payload = BearerToken.new(env['HTTP_AUTHORIZATION'])
    halt 400 unless payload.valid?
    token = DecryptPayload.new(payload.bearer_token)
    token =
    begin
      token.call
    rescue => e
      logger.error e
      halt 401
    end
    params_for_api = ParamsForCanvasApi.new(
      params['url'], token, params['course_id'], params['data']
    )
    halt 400 unless params_for_api.valid?
    result =
    case params['data']
    when 'assignments', 'student_summaries', 'activity' then
      GetCourseAnalyticsFromCanvas.new(params_for_api)
    when 'quizzes' then GetQuizzesFromCanvas.new(params_for_api)
    when 'users' then GetUserLevelDataFromCanvas.new(params_for_api)
    when 'enrollments' then GetCourseInfoFromCanvas.new(params_for_api)
    when 'discussion_topics' then GetDiscussionsFromCanvas.new(params_for_api)
    end
    result.call
  end

  encrypt_token = lambda do
    token = BearerToken.new(env['HTTP_AUTHORIZATION'])
    halt 400 unless token.valid?
    token = EncryptToken.new(token.bearer_token)
    token.call
  end

  # API Routes
  ['/', '/api/v1/?'].each { |path| get path, &api_get_root }
  get '/courses/?', &get_course_list
  get '/courses/:course_id/:data/?', &go_to_api_with_request
  get '/encrypt_token/?', &encrypt_token
end
