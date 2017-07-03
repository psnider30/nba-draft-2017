Description: CLI gem for 2017 NBA draft picks

-  A cli for the 2017 NBA draft from http://www.nba.com/draft/board

user types in 2017_nba_draft
Ask would you like to see drat picks by order, NBA team, or college/origin

=begin
def self.scrape_draft
  players = []
  doc = Nokogiri::HTML(open('http://www.cbssports.com/nba/news/2017-nba-draft-picks-complete-results-full-list-of-players-selected-highlights-grades/'))
  draft = doc.xpath('//*[@id="article-main-body"]/div/ol')
  pick = '1'
  i = 0
  while i < 60
    player_info = draft.css('li p')[i]
    player = self.new
    player.pick = pick.to_s
    player.nba_team = player_info.css('strong').text.gsub("\u00A0", "").gsub(':', '').strip
    details = player_info.text.split(' ')
    player.position = details. detect { |d| d.include?('(') }.strip

    if i < 30
      player.round = '1'
      player.former_team = player_info.text.split('-')[-1].chop.strip

      if details[0].include?(':')
        player.first_name = details[0].split(':')[1].gsub("\u00A0", "").strip
        player.last_name = details[1].strip
      else
        player.first_name = details[1].split(':')[1].gsub("\u00A0", "").strip
        player.last_name = details[2].gsub("\u00A0", "").strip
      end
    elsif i >= 30
      player.round = '2'
      player.former_team = details[-1].gsub("\u00A0", "").strip

      player.first_name = details[1].gsub("\u00A0", "").strip
      player.last_name = details[2].gsub("\u00A0", "").strip
    end
    player.name = player.first_name + ' ' + player.last_name
    players << player
    pick = pick.to_i + 1
    i += 1
  end
end
=end
