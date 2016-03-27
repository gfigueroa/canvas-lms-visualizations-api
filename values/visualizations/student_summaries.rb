# Value object to create objects for the student_summaries page
class StudentSummariesView
  def initialize(data)
    @data = data
  end

  def call
    tardiness, page_views, participations = tardiness_view_part
    {
      tard: tard(tardiness), summaries_height: summaries_height(tardiness),
      views_pars: views_pars(page_views, participations),
      views_pars_height: views_pars_height(page_views, participations)
    }.to_json
  end

  def tardiness_view_part(page_views = {}, participations = {}, tardiness =
    { missing: {}, late: {}, on_time: {}, floating: {} })
    @data.each do |user|
      tardiness.each_key do |key|
        tardiness[key]["user_#{user['id']}"] =
        user['tardiness_breakdown'][key.to_s]
      end
      page_views["user_#{user['id']}"] = user['page_views']
      participations["user_#{user['id']}"] = user['participations']
    end
    [tardiness, page_views, participations]
  end

  def tard(tardiness)
    [{ name: 'Late Submissions', data: tardiness[:late]
      .sort_by { |_, value| value }.reverse.to_h },
     { name: 'Missing Submissions', data: tardiness[:missing] },
     { name: 'Floating', data: tardiness[:floating] },
     { name: 'On Time Submissions', data: tardiness[:on_time] }]
  end

  def summaries_height(tardiness)
    tardiness.map { |key, _| tardiness[key].length }.max * 30
  end

  def views_pars(page_views, participations)
    views_pars = [
      { name: 'Views', data: page_views },
      { name: 'Participations', data: participations }
    ]
    views_pars.each do |view_par|
      view_par[:data] = Hash[view_par[:data].sort_by { |_, c| c }.reverse]
    end
    views_pars
  end

  def views_pars_height(page_views, participations)
    [page_views.length, participations.length].max * 30
  end
end
