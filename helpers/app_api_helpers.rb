# Helper module for app, handling API
module AppAPIHelper
  def result_route(params, arr)
    if params['data'] == 'discussion_topics'
      all_discussion(*arr)
    elsif params['data'] == 'quizzes'
      all_quiz(*arr)
    elsif params['data'] == 'users'
      user_by_user(*arr)
    elsif params['no_analytics']
      course_info(*arr)
    else course_analytics(*arr)
    end
  end

  def course_analytics(canvas_api, canvas_token, course_id, data)
    url = canvas_api + 'courses/' + course_id + "/analytics/#{data}"
    visit_canvas = VisitCanvasAPI.new(url, canvas_token)
    visit_canvas.call
  end

  def course_info(canvas_api, canvas_token, course_id, data)
    url = canvas_api + 'courses/' + course_id + "/#{data}"
    visit_canvas = VisitCanvasAPI.new(url, canvas_token)
    visit_canvas.call
  end

  def all_discussion(canvas_api, canvas_token, course_id, data)
    discussions = course_info(canvas_api, canvas_token, course_id, data)
    discussions = JSON.parse(discussions)
    discussions.map do |discussion|
      Concurrent::Future.new do
        course_info(canvas_api, canvas_token, course_id,
                    "/#{data}/#{discussion['id']}/view")
      end; end.map(&:execute).map(&:value).to_json
  end

  def all_quiz(canvas_api, canvas_token, course_id, data)
    quizzes = course_info(canvas_api, canvas_token, course_id, data)
    quizzes = JSON.parse(quizzes)
    quizzes.map do |quiz|
      Concurrent::Future.new do
        { quiz['title'] => course_info(canvas_api, canvas_token, course_id,
                                       "/#{data}/#{quiz['id']}/statistics") }
      end; end.map(&:execute).map(&:value).to_json
  end

  def user_by_user(canvas_api, canvas_token, course_id, data)
    persons = course_info(canvas_api, canvas_token, course_id, 'enrollments')
    student_ids = JSON.parse(persons, quirks_mode: true).map do |person|
      person['user_id'] if person['type'] == 'StudentEnrollment'
    end
    student_ids.compact.map do |id|
      Concurrent::Future.new do
        { "#{id}" => course_analytics(canvas_api, canvas_token, course_id,
                                      "/#{data}/#{id}/activity") }
      end; end.map(&:execute).map(&:value).to_json
  end
end
