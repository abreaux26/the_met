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
end
