# Value object to create objects for the activity page
class ActivityView
  def initialize(data)
    @data = data
  end

  def call
    views_participations_by_date = [
      { name: 'Participations', data: participations },
      { name: 'Views', data: views }
    ]
    views_by_day, participations_by_day = views_and_part_by_day
    { views_participations_by_date: views_participations_by_date,
      views_by_day: views_by_day,
      participations_by_day: participations_by_day }.to_json
  end

  def views(views = Hash.new(0))
    @data.each do |activity|
      views[activity['date']] = activity['views']
    end
    Hash[views.sort]
  end

  def participations(participations = Hash.new(0))
    @data.each do |activity|
      participations[activity['date']] = activity['participations']
    end
    Hash[participations.sort]
  end

  def views_participation_dow(views_participation = {})
    @data.each do |activity|
      views_participation[activity['date']] =
      [activity['views'], activity['participations']]
    end
    views_participation_dow = Hash.new { |hash, key| hash[key] = [] }
    views_participation.each do |date, view_par|
      day_of_week = Date.parse(date).strftime '%A'
      views_participation_dow[day_of_week] << view_par
    end
    views_participation_dow
  end

  def views_and_part_by_day(views_by_day = {}, participations_by_day = {})
    Date::DAYNAMES.each do |day|
      views_by_day[day] = 0
      participations_by_day[day] = 0
    end
    views_participation_dow.each do |day, view_par|
      views_by_day[day] = view_par.map { |e| e[0] }.reduce(:+)
      participations_by_day[day] = view_par.map { |e| e[1] }.reduce(:+)
    end
    [views_by_day, participations_by_day]
  end
end
