# Value object to create objects for the assignments page
class AssignmentsView
  def initialize(data)
    @data =
    data.sort_by { |k, _| k['due_at'] } unless
      data.any? { |k, _| k['due_at'].nil? }
  end

  def call
    return { result: 'No assignment found' }.to_json if @data.nil?
    { tard: tard, scores: final_scores,
      scores_percent: scores_percent }.to_json
  end

  def tardiness(tardiness = { missing: {}, late: {}, on_time: {} })
    @data.each do |assignment|
      tardiness.each_key do |key|
        tardiness[key][assignment['title']] = [
          assignment['tardiness_breakdown'][key.to_s],
          assignment['tardiness_breakdown']['total']]
      end
    end
    tardiness
  end

  def clean_up_tardiness
    clean_tard = tardiness
    clean_tard.each_key { |key| clean_tard[key].delete_if { |k, _| k.nil? } }
    clean_tard.each_key do |key|
      clean_tard[key] = Hash[clean_tard[key].map { |k, v| [k, v[0] * v[1]] }]
    end
    clean_tard
  end

  def tard
    tardiness = clean_up_tardiness
    [{ name: 'Missing Submissions', data: tardiness[:missing] },
     { name: 'Late Submissions', data: tardiness[:late] },
     { name: 'On Time Submissions', data: tardiness[:on_time] }]
  end

  def scores(scores = {})
    @data.each do |assignment|
      scores[assignment['title']] = [
        assignment['min_score'], assignment['first_quartile'],\
        assignment['median'], assignment['third_quartile'],\
        assignment['max_score'], assignment['points_possible']
      ]
    end
    scores.delete_if { |key, value| key.nil? || value.any?(&:nil?) }
    scores
  end

  def scores_percent
    scores_percent = scores
    scores_percent.each do |key, values|
      scores_percent[key] = values.map.each_with_index do |value, index|
        (value / values[5].to_f * 100).round 2 unless index == 5
      end.compact
    end
    scores_percent
  end

  def final_scores
    final_scores = scores
    final_scores.each do |key, values|
      final_scores[key] = values[0..4]
    end
    final_scores
  end
end
