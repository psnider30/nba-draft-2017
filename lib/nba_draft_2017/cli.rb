class NbaDraft2017::Cli

  @@key_stats = ['ppg', 'rpg', 'apg', 'tpg', 'spg', 'bpg', 'mpg', 'fg', 'three', 'ft']

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
    dotted_line
    puts "Round 1".colorize(:blue).bold
    dotted_line

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

    dotted_line
  end

  def list_round_2
    puts "Round 2".colorize(:blue).bold
    dotted_line

    i = 30
    while i < 60
      player = NbaDraft2017::Player.all[i]
      puts "#{i + 1}. #{player.name.colorize(:green).bold} #{player.position.colorize(:red)} from #{player.former_team.colorize(:blue).bold} drafted by #{player.nba_team.colorize(:green).bold}"
      i += 1
    end

    dotted_line
  end

  def dotted_line
    puts "------------------------------------------------------------".bold.colorize(:red)
  end

    def make_players
    NbaDraft2017::Scraper.scrape_draft
  end

  def add_attributes_to_players
      NbaDraft2017::Player.all.each do |player|
        add_attributes_to_player(player.name)
      end
  end

  def menu
    input = nil

    while input != 'exit'
      list_controls
      input = gets.strip.downcase
      if input == 'draft'
        list_draft
      elsif input == 'rd1' || input == 'rd 1'
        list_round_1
      elsif input == 'rd2' || input == 'rd 2'
        list_round_2
      elsif input == 'player' || input == 'players'
        find_and_list_player
      elsif input == 'nba team' || input == 'nba'
        list_draft_picks_by_nba_team
      elsif input == 'former team' || input == 'former'
        list_draft_picks_by_former_team
      elsif input == 'compare stats'
        compare_stats
      elsif input == 'exit'
        good_bye
      else
        error
      end
    end
  end

  def list_controls
    draft = "'draft'"
    round_1 = "'rd1'"
    round_2 = "'rd2'"
    player = "'player'"
    nba_team = "'nba'"
    former_team = "'former'"
    puts "Enter #{draft.colorize(:green)}, #{round_1.colorize(:green)} or #{round_2.colorize(:green)} to see list of draft picks."
    puts "Enter #{player.colorize(:green)} to see player details and stats"
    puts "Enter #{nba_team.colorize(:green)} to show players drafted by a NBA team"
    puts "Enter #{former_team.colorize(:green)} to show players drated out of colleges or clubs"
    puts "Enter " + "'compare stats'".colorize(:green) + " to see player with stat average above number specified by user"
    puts "To quit, type" + " 'exit'".colorize(:green)
  end

  def find_and_list_player
    puts "Please enter player draft pick number or player name."
    lookup = gets.strip

    if lookup.to_i.between?(1, NbaDraft2017::Player.all.size)
      player = NbaDraft2017::Player.find_player_by_pick(lookup)
      list_player_details(player)
    elsif player ||= NbaDraft2017::Player.find_player_by_name(lookup)
      list_player_details(player)
    else
      error
    end
    player
  end

  def list_player_details(player)
    if NbaDraft2017::Player.all_attributes
      player
    else
      player = NbaDraft2017::Player.add_attributes_to_player(player)
    end

    puts "#{player.name.upcase.bold.underline}".colorize(:green).bold
    puts "  Round:".bold.colorize(:red) +" #{player.round}" + "  Pick:".bold.colorize(:red) +" #{player.pick}"
    puts "  Drafted By:".bold.colorize(:red) +" #{player.nba_team}"
    puts "  From:".bold.colorize(:red) +" #{player.former_team}"
    puts "  Position:".bold.colorize(:red) +" #{player.position}"
    puts "  Drafted As:".bold.colorize(:red) +" #{player.former_status}"
    puts "  Age:".bold.colorize(:red) +" #{player.age}"
    puts "  Height:".bold.colorize(:red) +" #{player.height}"
    puts "  Weight:".bold.colorize(:red) +" #{player.weight}"
    puts "  STATS".colorize(:green).bold if player.key_stats

    if player.key_stats
      puts "    PPG:".bold.colorize(:red) + " #{player.ppg}" if player.ppg
      puts "    RPG:".bold.colorize(:red) + " #{player.rpg}" if player.rpg
      puts "    APG:".bold.colorize(:red) + " #{player.apg}" if player.apg
      puts "    FG:".bold.colorize(:red) + " #{(player.fg * 100).round(2)}%" if player.fg
      puts "    3PT:".bold.colorize(:red) + " #{(player.three * 100).round(2)}%" if player.three
      puts "    FT:".bold.colorize(:red) + " #{(player.ft * 100).round(2)}%" if player.ft
      puts "    TPG:".bold.colorize(:red) + " #{player.tpg}" if player.tpg
      puts "    SPG:".bold.colorize(:red) + " #{player.spg}" if player.spg
      puts "    BPG:".bold.colorize(:red) + " #{player.bpg}" if player.bpg
      puts "    MPG:".bold.colorize(:red) + " #{player.mpg}" if player.mpg
    end
  end

  def compare_stats
    puts "This might take a minute for first comaprison.".bold.colorize(:green)
    puts "To proceed enter a stat category from #{@@key_stats} or 'menu' to return to menu"
    stat_category = gets.downcase.strip
    if @@key_stats.include?(stat_category)
      puts "Enter a number to see players that have a higher average for #{stat_category.colorize(:green)} and make sure to enter a decimal for fg%, three%, and ft%"
      stat_num = gets.strip
      if stat_num.to_f.between?(0.001,40)
        NbaDraft2017::Player.stat_greater_than(stat_category, stat_num)
      elsif stat_num == 'menu' || stat_num == 'exit'
        menu
      else
        error
      end
    elsif stat_category == 'menu' || stat_category == 'exit'
      menu
    else
      error
    end
  end

  def list_draft_picks_by_nba_team
    puts NbaDraft2017::Player.nba_teams.sort
    puts 'Enter an NBA team (name only) as in list above:'.colorize(:green)

    nba_team = gets.strip.downcase

    if NbaDraft2017::Player.nba_teams.include?(nba_team)
      NbaDraft2017::Player.players_by_nba_team(nba_team)
      more_info_on_player?(nba_team)
    else
      error
    end
  end

  def list_draft_picks_by_former_team
    puts NbaDraft2017::Player.former_teams.sort
    puts 'Enter a School or Country name exactly as shown in list above:'.colorize(:green)

    former_team = gets.strip.downcase

    if NbaDraft2017::Player.former_teams.include?(former_team)
      NbaDraft2017::Player.players_by_former_team(former_team)
      more_info_on_player?(former_team)
    else
      error
    end
  end

  def more_info_on_player?(team)
    request = nil

    while request != 'n' && request != 'exit'
      puts "Would you like more info on any of the players? 'y' or 'n'?"
      request = gets.downcase.strip

      if request =='y'
        player = find_and_list_player

        if player.nba_team.downcase != team.downcase && player.former_team.downcase != team.downcase
          dotted_line
          puts "That player isn't on or from #{team} though!!!".upcase.bold.colorize(:red)
          dotted_line
        end

      elsif request == 'n' || request == 'exit'
        break

      else
        error
      end

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
