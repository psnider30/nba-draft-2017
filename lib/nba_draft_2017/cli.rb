# Our CLI controller
class NbaDraft2017::Cli

  def call
    puts 'Welcome to the 2017 NBA Draft!'
    make_players
    menu
  end

  def list_draft
    list_round_1
    list_round_2
  end

  def list_round_1
    puts "Round 1".colorize(:blue).bold
    puts "------------------------------------------------------------".bold.colorize(:red)
    i = 0
    while i < 30
      player = NbaDraft2017::Player.all[i]
      if i < 9
        puts "#{i + 1}.  #{player.name.colorize(:green).bold} #{player.position.colorize(:red)} from #{player.former_team.colorize(:blue).bold} drafted by #{player.nba_team.colorize(:green).bold}"
      else
        puts "#{i + 1}. #{player.name.colorize(:green).bold} #{player.position.colorize(:red)} from #{player.former_team.colorize(:blue).bold} drafted by #{player.nba_team.colorize(:green).bold}"
      end
      i += 1
    end
    puts "------------------------------------------------------------".bold.colorize(:red)
  end

  def list_round_2
    puts "Round 2".colorize(:blue).bold
    puts "------------------------------------------------------------".bold.colorize(:red)
    i = 30
    while i < 60
      player = NbaDraft2017::Player.all[i]
      puts "#{i + 1}. #{player.name.colorize(:green).bold} #{player.position.colorize(:red)} from #{player.former_team.colorize(:blue).bold} drafted by #{player.nba_team.colorize(:green).bold}"
      i += 1
    end
    puts "------------------------------------------------------------".bold.colorize(:red)
  end

  def list_player_details(player_name)
    player = add_attributes_to_player(player_name)
    puts "#{player.name.upcase.bold}".colorize(:green).bold
    puts "  Round:".bold.colorize(:red) +" #{player.round}" + "  Pick:".bold.colorize(:red) +" #{player.pick}"
    puts "  Drafted By:".bold.colorize(:red) +" #{player.nba_team}"
    puts "  From:".bold.colorize(:red) +" #{player.former_team}"
    puts "  Drafted As:".bold.colorize(:red) +" #{player.former_status}"
    puts "  Height:".bold.colorize(:red) +" #{player.height}"
    puts "  Weight:".bold.colorize(:red) +" #{player.weight}"
    puts "  STATS".colorize(:green).bold if player.key_stats
    if player.key_stats
      puts "    PPG:".bold.colorize(:red) + " #{player.ppg}" if player.ppg
      puts "    RPG:".bold.colorize(:red) + " #{player.rpg}" if player.rpg
      puts "    APG:".bold.colorize(:red) + " #{player.apg}" if player.apg
      puts "    FG%:".bold.colorize(:red) + " #{player.fg.round(2) * 100}%" if player.fg
      puts "    3PT%:".bold.colorize(:red) + " #{player.three.round(2) * 100}%" if player.three
      puts "    FT%:".bold.colorize(:red) + " #{player.ft.round(2) * 100}%" if player.ft
      puts "    TPG:".bold.colorize(:red) + " #{player.tpg}" if player.tpg
      puts "    SPG:".bold.colorize(:red) + " #{player.spg}" if player.spg
      puts "    BPG:".bold.colorize(:red) + " #{player.bpg}" if player.bpg
      puts "    MPG:".bold.colorize(:red) + " #{player.mpg}" if player.mpg
    end
  end



  def make_players
    players_array = NbaDraft2017::Scraper.scrape_draft
    NbaDraft2017::Player.create_from_collection(players_array)
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
      list_controls
      input = gets.strip.downcase
      if input == 'list draft'
        list_draft
      elsif input == 'round 1' || input == 'round1'
        list_round_1
      elsif input == 'round 2' || input == 'round2'
        list_round_2
      elsif input == 'list player'
        list_player
      elsif input == 'nba team'
        list_draft_picks_by_nba_team
      elsif input == 'former team'
        list_draft_picks_by_former_team
      elsif input == 'all'
        add_attributes_to_players
      elsif input == 'exit'
        good_bye
      else
        error
      end
    end
  end

  def list_controls
    puts "Enter 'list draft', 'round 1' or 'round 2' to see list of draft picks."
    puts "Enter 'list player' to see player details and stats"
    puts "Enter 'nba team' to show players drafted by a NBA team"
    puts "Enter 'former team' to show players drated out of colleges or clubs"
    puts "To quit, type 'exit'"
  end

  def find_and_list_player
    puts "Please enter player draft pick number or player name."
    lookup = gets.strip
    if lookup.to_i > 0 && lookup.to_i <= 60
      player = NbaDraft2017::Player.find_player_by_pick(lookup)
      list_player_details(player.name)
    elsif NbaDraft2017::Player.find_player_by_name(lookup)
      list_player_details(lookup)
    else
      error
    end
  end

  def list_draft_picks_by_nba_team
    puts 'Enter am NBA team (name only) as in list below:'.colorize(:green)
    puts NbaDraft2017::Player.nba_teams.sort
    nba_team = gets.strip.downcase
    if NbaDraft2017::Player.nba_teams.include?(nba_team)
      NbaDraft2017::Player.players_by_nba_team(nba_team)
    else
      error
    end
  end

  def list_draft_picks_by_former_team
    puts 'Enter a School or Country name exactly as shown in list below:'.colorize(:green)
    puts NbaDraft2017::Player.former_teams.sort
    former_team = gets.strip.downcase
    if NbaDraft2017::Player.former_teams.include?(former_team)
      NbaDraft2017::Player.players_by_former_team(former_team)
    else
      error
    end
  end

  def error
    puts "I didn't understand that! Please try agian or type 'exit'.".colorize(:red).bold
    puts "------------------------------------------------------------".colorize(:green).bold
  end



  def good_bye
    puts "Thanks for checking out the 2017 NBA Draft! Good Luck!"
  end
end
