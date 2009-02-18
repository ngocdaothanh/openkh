class Poll < ActiveRecord::Base
  serialize :responses, Array
  serialize :votes,     Array
  serialize :voters,    Array

  acts_as_content

  define_index do
    indexes title
    indexes comments.body, :as => :comments

    set_property :field_weights => {'title' => 10, 'comments' => 1}

    has updated_at
  end

  def after_initialize
    self.responses = [] if responses.nil?
    self.votes     = [] if votes.nil?
    self.voters    = [] if voters.nil?
  end

  def validate_on_create
    new_responses = []
    responses.each do |o|
      o.strip!
      new_responses << o unless o.empty?
    end

    self.responses = new_responses
    self.votes   = Array.new(responses.size, 0)
    self.voters  = []

    errors.add_to_base(t('content_poll.at_least_2_responses')) if responses.size < 2
  end

  def voted?(user)
    voters.include?(user.id)
  end

  def vote(user, iresponse)
    # Check range
    return if iresponse < 0 || iresponse >= responses.size

    # Check if this user has voted
    return if voted?(user)

    # This does not work
    #votes[iresponse] += 1
    #voters << user.id
    #save

    # This works
    new_votes  = votes.clone;  new_votes[iresponse] += 1
    new_voters = voters.clone; new_voters << user.id
    self.votes  = new_votes  # Assignment must be used for updating to work
    self.voters = new_voters
    save
  end

  def sum
    @sum ||= votes.inject(0) { |s, e| s += e }
  end
end
