# Value object to create objects for the enrollments page
class EnrollmentsView
  def initialize(data)
    @data = data
  end

  def call
    @data.to_json
  end
end
