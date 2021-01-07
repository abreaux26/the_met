class Museum
  attr_reader :name,
              :exhibits,
              :patrons

  def initialize(name)
    @name = name
    @exhibits = []
    @patrons = []
  end

  def add_exhibit(exhibit)
    @exhibits << exhibit
  end

  def admit(patron)
    @patrons << patron
  end

  def recommend_exhibits(patron)
    patron.interests.flat_map do |interest|
      exhibits.find_all do |exhibit|
        exhibit.name == interest
      end
    end
  end

  def patrons_by_exhibit_interest
    @exhibits.each_with_object({}) do |exhibit, hash|
      hash[exhibit] = patrons_by_exhibit(exhibit)
    end
  end

  def patrons_by_exhibit(exhibit)
    @patrons.find_all do |patron|
      patron.interests.include? exhibit.name
    end
  end

  def ticket_lottery_contestants(exhibit)
    interested_patrons = patrons_by_exhibit_interest[exhibit]
    interested_patrons.find_all do |patron|
      patron.spending_money < exhibit.cost
    end
  end

  def draw_lottery_winner(exhibit)
    ticket_lottery_contestants(exhibit).sample
  end
end
