# Our CLI controller
class NbaDraft2017::Cli

  def call
    puts 'Welcome to the 2017 NBA Draft'
    make_players
    #list_players
    #add_attributes_to_player('Markelle Fultz')
    list_player('Markelle Fultz')
  end

  def list_players
    puts "Round 1".colorize(:blue).bold
      puts "------------------------------------------------------------".colorize(:red)
    NbaDraft2017::Player.all.each.with_index(1) do |player, i|
      if i == 31
        puts puts "Round 2".colorize(:blue).bold
        puts "------------------------------------------------------------".colorize(:red)
      end
      puts "#{i}. #{player.name.colorize(:green).bold} #{player.position.colorize(:red)} from #{player.former_team.colorize(:blue).bold} drafted by #{player.nba_team.colorize(:green).bold}"
    end
  end

  def list_player(player_name)
    player = add_attributes_to_player(player_name)
    puts "#{player.name.upcase.bold}".colorize(:green)
    puts "  Round:".colorize(:red) +" #{player.round}" + "  Pick:".colorize(:red) +" #{player.pick}"
    puts "  Drafted By:".colorize(:red) +" #{player.nba_team}"
    puts "  From:".colorize(:red) +" #{player.former_team}"
    puts "  Drafted As:".colorize(:red) +" #{player.former_status}"
    puts "  Height:".colorize(:red) +" #{player.height}"
    puts "  Weight:".colorize(:red) +" #{player.weight}"
    puts "  STATS".colorize(:green)
    if player.key_stats
      puts "    PPG:".colorize(:red) + " #{player.ppg}"
      puts "    RPG:".colorize(:red) + " #{player.rpg}"
      puts "    APG:".colorize(:red) + " #{player.apg}"
      puts "    TPG:".colorize(:red) + " #{player.tpg}"
      puts "    SPG:".colorize(:red) + " #{player.spg}"
      puts "    BPG:".colorize(:red) + " #{player.bpg}"
      puts "    MPG:".colorize(:red) + " #{player.mpg}"
    end
    binding.pry
  end



  def make_players
    players_array = NbaDraft2017::Scraper.scrape_draft
    NbaDraft2017::Player.create_from_collection(players_array)
  end

  def add_attributes_to_players
      NbaDraft2017::Player.all.each do |player|
      attributes = NbaDraft2017::Scraper.scrape_player("http://www.nba.com/draft/2017/prospects/" + player.profile_url)
      player.add_player_attributes(attributes)
    end
    puts 'done'
  end

  def add_attributes_to_player(player_name)
      player = NbaDraft2017::Player.find_player_by_name(player_name)
      attributes = NbaDraft2017::Scraper.scrape_player("http://www.nba.com/draft/2017/prospects/" + player.profile_url)
      player.add_player_attributes(attributes)
      player
  end

#def player_url
#  NbaDraft2017::Player.all.each do |player|
#    player_url = "http://www.nba.com/draft/2017/prospects/" + player.first_name.gsub(/\W/, '').downcase.strip + '_' + player.last_name.gsub(/\W/, '').downcase.strip
#    puts player_url
#  end
#end

  def menu

  end



  def good_bye
    puts "Thanks for checking out the 2017 NBA Draft! Prognosis: Sorry, you're teams probably still going to lose to the Warriors!"
  end
end
