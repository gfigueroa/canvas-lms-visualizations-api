require 'virtus'
require 'active_model'

DEFAULT_API = 'https://canvas.instructure.com/api/v1/'
API = 'api/v1/'
DATA_OPTIONS = [
  nil, 'activity', 'users', 'assignments', 'discussion_topics',
  'student_summaries', 'enrollments', 'quizzes'
]

# Value object that goes to canvas api calls
class ParamsForCanvasApi
  include Virtus.model
  include ActiveModel::Validations

  attr_accessor :canvas_api, :canvas_token, :course_id, :data

  validates :canvas_token, presence: true
  validates_inclusion_of :data, in: DATA_OPTIONS

  def initialize(url, token, course_id = nil, data = nil)
    @canvas_api =
    if url
      url[-7..-1] == API ? url : "#{url}API"
    else DEFAULT_API
    end
    @canvas_token = token
    @course_id = course_id
    @data = data
  end
end
