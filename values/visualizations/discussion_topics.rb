DATE = 0..9

# Value object to create objects for the users page
class DiscussionTopicsView
  def initialize(data)
    @data = data
  end

  def call
    return { result: 'No discussion available' }.to_json if
    @data.all? { |dat| dat.nil? || dat.empty? || dat == 'null' }
    comments = @data.map { |dat| JSON.parse(dat)['view'] unless dat == 'null' }
    discussions, discussions_by_id = generate_results(comments)
    discussions, discussions_by_id, discussion_height =
    prepare_results(discussions, discussions_by_id)
    {
      discussions: discussions, discussions_by_id: discussions_by_id,
      discussion_height: discussion_height
    }.to_json
  end

  def generate_results(comments, disc = Hash.new(0), disc_by_id = Hash.new(0))
    comments.each do |comment|
      next if comment.empty?
      comment.each do |comms|
        disc, disc_by_id = comms?(comms, disc, disc_by_id)
        disc, disc_by_id = replies?(comms, disc, disc_by_id)
      end
    end
    [disc, disc_by_id]
  end

  def comms?(comms, disc, disc_by_id)
    return [disc, disc_by_id] if comms['deleted'] == true
    disc[comms['created_at'][DATE]] += 1
    disc_by_id["user_#{comms['user_id']}"] += 1
    [disc, disc_by_id]
  end

  def replies?(comms, disc, disc_by_id)
    return [disc, disc_by_id] if comms['replies'].nil?
    comms['replies'].each do |reply|
      next if reply['deleted'] == true
      disc[reply['created_at'][DATE]] += 1
      disc_by_id["user_#{reply['user_id']}"] += 1
    end
    [disc, disc_by_id]
  end

  def prepare_results(discussions, discussions_by_id)
    discussions = Hash[discussions.sort]
    discussions_by_id = Hash[discussions_by_id.sort_by { |_, c| c }.reverse]
    discussion_height = discussions_by_id.length * 30
    [discussions, discussions_by_id, discussion_height]
  end
end
