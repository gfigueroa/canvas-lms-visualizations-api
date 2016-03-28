DISC_TOPS = 'discussion_topics'
DAYS_OF_WEEK = %w(Sunday Monday Tuesday Wednesday Thursday Friday Saturday)

# Value object to create objects for the users page
class UsersView
  def initialize(data)
    @data = data
  end

  def call
    # dow means dayOfWeek; so views_dow means views by day of week.
    result_one = views_dow
    result_two = participations_dow
    result_one.each do |k, _|
      result_one[k] = [result_one[k], result_two[k]]
    end
    { views_dow: result_one }.to_json
  end

  def views_dow(views_dow = {})
    @data.each do |user|
      next if user.nil?
      user.each do |user_id, v|
        JSON.parse(v).each do |item, views_participations|
          next unless item == 'page_views'
          temp_store = populate_temp_store_views(views_participations)
          views_dow[user_id] = temp_store
        end; end; end
    views_dow
  end

  def populate_temp_store_views(views_participations, temp_store = Hash.new(0))
    DAYS_OF_WEEK.each { |day| temp_store[day] = 0 }
    views_participations.each do |date, view_count|
      dow = Date.parse(date).strftime('%A')
      temp_store[dow] += view_count
    end
    temp_store
  end

  def participations_dow(participations_dow = {})
    @data.each do |user|
      next if user.nil?
      user.each do |user_id, v|
        JSON.parse(v).each do |item, views_participations|
          next unless item == 'participations'
          temp_store = populate_temp_store_parts(views_participations)
          participations_dow[user_id] = temp_store
        end; end; end
    participations_dow
  end

  def populate_temp_store_parts(views_participations, temp_store = Hash.new(0))
    DAYS_OF_WEEK.each { |day| temp_store[day] = 0 }
    views_participations.each do |hash|
      day_of_week = hash.first[1]
      dow = Date.parse(day_of_week).strftime('%A')
      hash.each do |key, value|
        temp_store[dow] += 1 if key == 'url' && value.include?(DISC_TOPS)
      end; end
    temp_store
  end
end
