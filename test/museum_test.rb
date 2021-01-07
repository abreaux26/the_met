require 'minitest/autorun'
require 'minitest/pride'
require 'mocha/minitest'
require './lib/exhibit'
require './lib/patron'
require './lib/museum'

class MuseumTest < Minitest::Test
  def test_it_exists
    dmns = Museum.new("Denver Museum of Nature and Science")

    assert_instance_of Museum, dmns
  end

  def test_it_has_readable_attributes
    dmns = Museum.new("Denver Museum of Nature and Science")

    assert_equal "Denver Museum of Nature and Science", dmns.name
    assert_equal [], dmns.exhibits
    assert_equal [], dmns.patrons
  end

  def test_add_exhibit
    dmns = Museum.new("Denver Museum of Nature and Science")
    gems_and_minerals = Exhibit.new({name: "Gems and Minerals", cost: 0})
    imax = Exhibit.new({name: "IMAX",cost: 15})

    dmns.add_exhibit(gems_and_minerals)
    dmns.add_exhibit(imax)

    assert_equal [gems_and_minerals, imax], dmns.exhibits
  end

  def test_recomment_exhibits
    dmns = Museum.new("Denver Museum of Nature and Science")

    gems_and_minerals = Exhibit.new({name: "Gems and Minerals", cost: 0})
    imax = Exhibit.new({name: "IMAX",cost: 15})
    dmns.add_exhibit(gems_and_minerals)
    dmns.add_exhibit(imax)

    patron_1 = Patron.new("Bob", 20)
    patron_1.add_interest("Dead Sea Scrolls")
    patron_1.add_interest("Gems and Minerals")

    assert_equal [gems_and_minerals], dmns.recommend_exhibits(patron_1)
  end

  def test_admit
    dmns = Museum.new("Denver Museum of Nature and Science")
    patron_1 = Patron.new("Bob", 0)

    dmns.admit(patron_1)

    assert_equal [patron_1], dmns.patrons
  end

  def test_patrons_by_exhibit_interest
    dmns = Museum.new("Denver Museum of Nature and Science")

    gems_and_minerals = Exhibit.new({name: "Gems and Minerals", cost: 0})
    imax = Exhibit.new({name: "IMAX",cost: 15})
    dmns.add_exhibit(gems_and_minerals)
    dmns.add_exhibit(imax)

    patron_1 = Patron.new("Bob", 20)
    patron_1.add_interest("IMAX")
    patron_1.add_interest("Gems and Minerals")

    patron_2 = Patron.new("Sally", 20)
    patron_2.add_interest("IMAX")

    dmns.admit(patron_1)
    dmns.admit(patron_2)

    expected = {
      gems_and_minerals => [patron_1],
      imax => [patron_1, patron_2]
    }

    assert_equal expected, dmns.patrons_by_exhibit_interest
  end

  def test_patrons_by_exhibit
    dmns = Museum.new("Denver Museum of Nature and Science")

    gems_and_minerals = Exhibit.new({name: "Gems and Minerals", cost: 0})
    imax = Exhibit.new({name: "IMAX",cost: 15})
    dmns.add_exhibit(gems_and_minerals)
    dmns.add_exhibit(imax)

    patron_1 = Patron.new("Bob", 20)
    patron_1.add_interest("IMAX")
    patron_1.add_interest("Gems and Minerals")

    patron_2 = Patron.new("Sally", 20)
    patron_2.add_interest("IMAX")

    dmns.admit(patron_1)
    dmns.admit(patron_2)

    assert_equal [patron_1], dmns.patrons_by_exhibit(gems_and_minerals)
  end

  def test_ticket_lottery_contestants
    dmns = Museum.new("Denver Museum of Nature and Science")

    gems_and_minerals = Exhibit.new({name: "Gems and Minerals", cost: 0})
    imax = Exhibit.new({name: "IMAX",cost: 15})
    dmns.add_exhibit(gems_and_minerals)
    dmns.add_exhibit(imax)

    patron_1 = Patron.new("Bob", 0)
    patron_1.add_interest("IMAX")
    patron_1.add_interest("Gems and Minerals")

    patron_2 = Patron.new("Sally", 20)
    patron_2.add_interest("IMAX")

    patron_3 = Patron.new("Johnny", 5)
    patron_3.add_interest("IMAX")

    dmns.admit(patron_1)
    dmns.admit(patron_2)
    dmns.admit(patron_3)

    assert_equal [patron_1, patron_3], dmns.ticket_lottery_contestants(imax)
  end

  def test_draw_lottery_winner
    dmns = Museum.new("Denver Museum of Nature and Science")

    gems_and_minerals = Exhibit.new({name: "Gems and Minerals", cost: 0})
    imax = Exhibit.new({name: "IMAX",cost: 15})
    dmns.add_exhibit(gems_and_minerals)
    dmns.add_exhibit(imax)

    patron_1 = Patron.new("Bob", 0)
    patron_1.add_interest("IMAX")
    patron_1.add_interest("Gems and Minerals")

    patron_2 = Patron.new("Sally", 20)
    patron_2.add_interest("IMAX")

    patron_3 = Patron.new("Johnny", 5)
    patron_3.add_interest("IMAX")

    dmns.admit(patron_1)
    dmns.admit(patron_2)
    dmns.admit(patron_3)

    assert_equal "Bob", dmns.draw_lottery_winner(imax)
    assert_nil dmns.draw_lottery_winner(gems_and_minerals)
  end

  def test_announce_lottery_winner
    dmns = Museum.new("Denver Museum of Nature and Science")

    gems_and_minerals = Exhibit.new({name: "Gems and Minerals", cost: 0})
    imax = Exhibit.new({name: "IMAX",cost: 15})
    dmns.add_exhibit(gems_and_minerals)
    dmns.add_exhibit(imax)

    patron_1 = Patron.new("Bob", 0)
    patron_1.add_interest("IMAX")
    patron_1.add_interest("Gems and Minerals")

    patron_2 = Patron.new("Sally", 20)
    patron_2.add_interest("IMAX")

    patron_3 = Patron.new("Johnny", 5)
    patron_3.add_interest("IMAX")

    dmns.admit(patron_1)
    dmns.admit(patron_2)
    dmns.admit(patron_3)

    winner = mock
    name = dmns.draw_lottery_winner(imax)
    winner.stubs(:name).returns("Bob")
    announcement = "#{winner.name} has won the IMAX exhibit lottery"

    no_winner = "No winners for this lottery"

    assert_equal announcement, dmns.announce_lottery_winner(imax)
    assert_equal no_winner, dmns.announce_lottery_winner(gems_and_minerals)
  end
end
