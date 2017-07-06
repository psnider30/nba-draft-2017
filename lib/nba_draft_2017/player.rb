class NbaDraft2017::Player

  attr_accessor :name, :last_name, :first_name, :profile_url, :pick, :round, :nba_team, :position, :former_team, :height, :weight, :former_status, :age,
    :key_stats, :ppg, :rpg, :apg, :tpg, :spg, :bpg, :mpg, :FG, :_3PT, :FT

  @@all = []
  @@nba_teams = []
  @@former_teams = []

  def initialize(player_hash)
    player_hash.each {|attribute, value| self.send("#{attribute}=", value) }
    @@all << self
  end

  def self.create_from_collection(players_array)
    players_array.each { |player| NbaDraft2017::Player.new(player) }
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

  def self.nba_teams
    self.all.each do |player|
      @@nba_teams << player.nba_team.downcase
    end
    @@nba_teams.uniq
  end

  def self.players_by_nba_team(nba_team)
    puts nba_team.upcase.bold.colorize(:green)
    self.all.each do |player|
      if player.nba_team.downcase == nba_team.downcase
        puts "Rd: ".colorize(:red) +"#{player.round}" + "  Pick: ".colorize(:red) +"#{player.pick} #{player.name.upcase.bold.colorize(:blue)} from #{player.former_team.colorize(:blue)}"
      end
    end
  end

  def self.former_teams
    self.all.each do |player|
      @@former_teams << player.former_team.downcase
    end
    @@former_teams.uniq
  end

  def self.players_by_former_team(former_team)
    puts former_team.upcase.bold.colorize(:green)
    self.all.each do |player|
      if player.former_team.downcase == former_team.downcase
        puts "Rd: ".colorize(:red) +"#{player.round}" + "  Pick: ".colorize(:red) +"#{player.pick} #{player.name.upcase.bold.colorize(:blue)} to #{player.nba_team.colorize(:blue)}"
      end
    end
  end

  def self.all
    @@all
  end
end
