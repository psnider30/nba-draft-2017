class NbaDraft2017::Player

  attr_accessor :name, :last_name, :first_name, :profile_url, :pick, :round, :nba_team, :position, :former_team, :height, :weight, :former_status, :age,
    :key_stats, :ppg, :rpg, :apg, :tpg, :spg, :bpg, :mpg, :fg, :three, :ft

  @@all = []
  @@nba_teams = []
  @@former_teams = []
  @@all_attributes = nil

  def initialize(player_hash)
    player_hash.each {|attribute, value| self.send("#{attribute}=", value) }
    @@all << self
  end

  def add_player_attributes(attributes_hash)
    attributes_hash.each { |attribute, value| self.send("#{attribute}=", value) }
  end

  def self.find_player_by_name(player_name)
    NbaDraft2017::Player.all.detect { |player| player.name.downcase == player_name.downcase }
  end

  def self.find_player_by_pick(pick)
    NbaDraft2017::Player.all.detect { |player| player.pick == pick.to_s }
  end


  def self.add_attributes_to_player(player)
      attributes = NbaDraft2017::Scraper.scrape_player("http://www.nba.com/draft/2017/prospects/" + player.profile_url)
      player.add_player_attributes(attributes)
      player
  end

  def self.add_attributes_to_players
      @@all_attributes = self.all.each do |player|
        add_attributes_to_player(player)
      end
  end


  def self.stat_greater_than(stat_category, stat_num)
    @@all_attributes ||= self.add_attributes_to_players
    puts "Players with a higher average #{stat_category} include:".colorize(:green)
    puts "------------------------------------------------------------".bold.colorize(:red)

    players = self.all.select.with_index(1) do |player, idx|
      if player.send(stat_category) && player.send(stat_category) > stat_num.to_f
        puts "Pick: #{idx.to_s.colorize(:green)}. #{player.name.colorize(:green)} - #{player.send(stat_category).to_s.colorize(:red)} #{stat_category}"
        player
      end

    end
    puts "Nobody!".bold.colorize(:red) if players.empty?
    puts "------------------------------------------------------------".bold.colorize(:red)
  end

  def self.nba_teams
    self.all.each do |player|
      @@nba_teams << player.nba_team.downcase.strip
    end
    @@nba_teams.uniq
  end

  def self.players_by_nba_team(nba_team)
    puts nba_team.upcase.bold.colorize(:green)

    self.all.each do |player|
      if player.nba_team.downcase == nba_team.downcase
        puts "Rd: ".colorize(:red) +"#{player.round}" + "  Pick: ".colorize(:red) +"#{player.pick} #{player.name.upcase.bold.colorize(:blue)} from #{player.former_team.bold.colorize(:blue)}"
      end
    end
  end

  def self.former_teams
    self.all.each do |player|
      @@former_teams << player.former_team.downcase.strip
    end

    @@former_teams.uniq
  end

  def self.players_by_former_team(former_team)
    puts former_team.upcase.bold.colorize(:green)

    self.all.each do |player|
      if player.former_team.downcase == former_team.downcase
        puts "Rd: ".colorize(:red) +"#{player.round}" + "  Pick: ".colorize(:red) +"#{player.pick} #{player.name.upcase.bold.colorize(:blue)} to #{player.nba_team.bold.colorize(:blue)}"
      end
    end
  end

  def self.all_attributes
    @@all_attributes
  end

  def self.all
    @@all
  end
end
