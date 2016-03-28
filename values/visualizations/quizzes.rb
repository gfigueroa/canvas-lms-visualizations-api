# Value object to create objects for the quizzes page
class QuizzesView
  def initialize(data)
    @data = data
  end

  def call
    return { result: 'No quiz found' }.to_json if @data.empty?
    result = final_scores
    result = [{ name: 'Lowest Score', data: result[:low] },
              { name: 'Average Score', data: result[:average] },
              { name: 'Highest Score', data: result[:high] }]
    { scores: result }.to_json
  end

  def scores(scores = { high: {}, low: {}, average: {} })
    @data.each do |dat|
      dat.each do |name, statistics|
        statistics = JSON.parse(statistics)['quiz_statistics'][0]
        scores.each_key do |key|
          scores[key][name] = [
            statistics['submission_statistics']["score_#{key}"],
            statistics['points_possible']
          ]
        end; end; end
    scores
  end

  def final_scores
    final_scores = scores
    final_scores.each_key do |key|
      final_scores[key].delete_if { |_, value| value[0].nil? }
    end
    final_scores.each_key do |key|
      final_scores[key] =
      Hash[final_scores[key].map { |k, v| [k, v[0] * 100.0 / v[1]] }]
    end
    final_scores
  end
end
