# Our CLI controller
class NbaDraft2017::Cli

  def call
    puts 'Welcome to the 2017 NBA Draft'
    make_players
    menu
  end

  def list_players
    list_round_1
    list_round_2
  end

  def list_round_1
    puts "Round 1".colorize(:blue).bold
    puts "------------------------------------------------------------".colorize(:red)
    i = 0
    while i < 30
      player = NbaDraft2017::Player.all[i]
      puts "#{i + 1}. #{player.name.colorize(:green).bold} #{player.position.colorize(:red)} from #{player.former_team.colorize(:blue).bold} drafted by #{player.nba_team.colorize(:green).bold}"
      i += 1
    end
    puts "------------------------------------------------------------".colorize(:red)
  end

  def list_round_2
    puts "Round 2".colorize(:blue).bold
    puts "------------------------------------------------------------".colorize(:red)
    i = 30
    while i < 60
      player = NbaDraft2017::Player.all[i]
      puts "#{i + 1}. #{player.name.colorize(:green).bold} #{player.position.colorize(:red)} from #{player.former_team.colorize(:blue).bold} drafted by #{player.nba_team.colorize(:green).bold}"
      i += 1
    end
    puts "------------------------------------------------------------".colorize(:red)
  end

  def list_player(player_name)
    player = add_attributes_to_player(player_name)
    puts "#{player.name.upcase.bold}".colorize(:green).bold
    puts "  Round:".colorize(:red) +" #{player.round}" + "  Pick:".colorize(:red) +" #{player.pick}"
    puts "  Drafted By:".colorize(:red) +" #{player.nba_team}"
    puts "  From:".colorize(:red) +" #{player.former_team}"
    puts "  Drafted As:".colorize(:red) +" #{player.former_status}"
    puts "  Height:".colorize(:red) +" #{player.height}"
    puts "  Weight:".colorize(:red) +" #{player.weight}"
    puts "  STATS".colorize(:green).bold if player.key_stats
    if player.key_stats
      puts "    PPG:".colorize(:red) + " #{player.ppg}"
      puts "    RPG:".colorize(:red) + " #{player.rpg}"
      puts "    APG:".colorize(:red) + " #{player.apg}"
      puts "    TPG:".colorize(:red) + " #{player.tpg}"
      puts "    SPG:".colorize(:red) + " #{player.spg}"
      puts "    BPG:".colorize(:red) + " #{player.bpg}"
      puts "    MPG:".colorize(:red) + " #{player.mpg}"
    end
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

  def menu
    input = nil
    while input != 'exit'
      puts "Enter 'list draft', 'round 1' or 'round 2' to see list of draft picks."
      puts "Enter 'list player' to see player details and stats or type 'exit'."
      input = gets.strip.downcase
      if input == 'list draft'
        list_players
      elsif input == 'round 1'
        list_round_1
      elsif input == 'round 2'
        list_round_2
      elsif input == 'list player'
        puts "Please enter player name or draft pick number."
        lookup = gets.strip
        if lookup.to_i > 0 && lookup.to_i <= 60
          player = NbaDraft2017::Player.find_player_by_pick(lookup)
          list_player(player.name)
        elsif NbaDraft2017::Player.find_player_by_name(lookup)
          list_player(lookup)
        else
          error
        end
      elsif input == 'exit'
        good_bye
      else
        error
      end
    end
  end

  def error
    puts "I didn't understand that! Please try agian or type 'exit'.".colorize(:red).bold
    puts "------------------------------------------------------------".colorize(:green)
  end



  def good_bye
    puts "Thanks for checking out the 2017 NBA Draft! Prognosis: Sorry, your teams probably still going to lose to the Warriors!"
  end
end
