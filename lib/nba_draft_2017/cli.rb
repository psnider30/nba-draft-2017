# Our CLI controller
class NbaDraft2017::Cli

  base_path = "http://www.nba.com/draft/2017/prospects/"

  def call
    puts 'Welcome to the 2017 NBA Draft'
    make_players
    add_attributes_to_players
  end

  def list_players

  end

  def make_players
    players_array = NbaDraft2017::Scraper.scrape_draft
    NbaDraft2017::Player.create_from_collection(players_array)
  end

  def add_attributes_to_players
    base_path = "http://www.nba.com/draft/2017/prospects/"
    NbaDraft2017::Player.all.each do |player|
      attributes = NbaDraft2017::Scraper.scrape_player(base_path + "#{player.first_name}_#{player.last_name}")
      NbaDraft2017::Player.add_player_attributes(attributes)
  end

  def menu

  end

  def good_bye
    puts "Thanks for checking out the 2017 NBA Draft! Prognosis: Sorry, you're teams probably still going to lose to the Warriors!"
  end
end
