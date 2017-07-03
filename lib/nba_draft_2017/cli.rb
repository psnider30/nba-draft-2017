# Our CLI controller
class NbaDraft2017::Cli

  base_path = "http://www.nba.com/draft/2017/prospects/"

  def call
    puts 'Welcome to the 2017 NBA Draft'
    make_players
    add_attributes_to_players
    list_players
  end

  def list_players
    NbaDraft2017::Player.all.each.with_index(1) do |player, i|
      puts "#{i}. #{player.name} #{player.position} from #{player.former_team} drafted by #{player.nba_team}"
    end

  end

  def make_players
    players_array = NbaDraft2017::Scraper.scrape_draft
    NbaDraft2017::Player.create_from_collection(players_array)
  end

  def add_attributes_to_players
    base_path = "http://www.nba.com/draft/2017/prospects/"
    NbaDraft2017::Player.all.each do |player|
      player_url = player.first_name.downcase + '_' + player.last_name.downcase
      attributes = NbaDraft2017::Scraper.scrape_player(base_path + player_url)
      player.add_player_attributes(attributes)
  end
end

  def menu

  end

  def good_bye
    puts "Thanks for checking out the 2017 NBA Draft! Prognosis: Sorry, you're teams probably still going to lose to the Warriors!"
  end
end
