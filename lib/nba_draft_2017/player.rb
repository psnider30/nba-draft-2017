class NbaDraft2017::Player

  attr_accessor :name, :last_name, :first_name, :pick, :round, :nba_team, :position, :former_team, :height, :weight, :former_status, :age,
    :key_stats, :ppg, :rpg, :apg, :tpg, :spg, :bpg, :mpg, :FG, :_3PT, :FT

    @@all = []

    def initialize(player_hash)
      player_hash.each {|attribute, value| self.send("#{attribute=}", value) }
      @@all << self
    end

    def self.create_from_collection(players_array)
      players_array.each { |player| NbaDraft2017::Player.new(player) }
    end

    def add_player_attributes(attributes_hash)
      attributes_hash.each { |attribute, value| self.send("#{attribute}=", value) }
    end

    def self.all
      @@all
    end
end
