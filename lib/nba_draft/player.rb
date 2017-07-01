class NbaDraft::Player
=begin
  def self.scrape_players_info
    players = []

    players << self.scrape_rd1_draft_board
    players << self.scrape_rd2_draft_board
  end

  def self.scrape_rd1_draft_board
    players = []
    draft = Nokogiri::HTML(open('http://www.espn.com/nba/draft/rounds'))
    round_1 = draft.xpath('//*[@id="accordion__parent"]')
    round_1.css('li').each do |player_info|
      player = NbaDraft::Player.new
      pick = "#{player_info.attr('data-key')}"
      player[:pick] = player_info.css('a/div/span[0]').text
      player[:name] = player_info.css('a/div/span[1]').text
      player[:former_team] = player_info.css('a/div/span[2]').text
      player[:position] = player_info.css('a/div/span[3]').text
      player[:height] = draft.css('div > div.draftcast__module.draftcast__module--selectionMade > div > div > div > div > div > div.draftcast__player > div.draftcast__player__data > div.draftcast__player__stats > span:nth-child(1)').text
      player[:weight] = player_info.css('.draftcast__player__stats span[1]')

#//*[@id="pick-1"]/div/div[2]/div/div/div/div/div/div[1]/div[1]/div[2]/span[1]
#//*[@id="pick-1"]/div/div[2]/div/div/div/div/div/div[1]/div[1]/div[2]/span[1]
#pick-1 > div > div.draftcast__module.draftcast__module--selectionMade > div > div > div > div > div > div.draftcast__player > div.draftcast__player__data > div.draftcast__player__stats > span:nth-child(1)
#fultz = draft.xpath('//*[@id="accordion__parent"]/li[1]/a/div/span[1]').text
    end
  end
=end
    def self.scrape_draft
      players = []
      draft = Nokogiri::HTML(open('https://www.sbnation.com/nba/2017/6/22/15850112/nba-draft-2017-results-pick-by-pick'))
      picks = picks.css('.c-entry-content')
      picks.css('p[2]').each do |player_info|
        binding.pry
        player_info

      end
    end

    def scrape_player(player_url)
      player_page = Nokogiri::HTML(open(player_url))
      self.nba_team = player_page.xpath('//*[@id="draft-prospect-profile"]/div[1]/div/div/div[1]/div/div[2]/div/draft-prospect-profile/section/div[2]/a').text
      self.ht_weight = player_page.xpath('//*[@id="draft-prospect-profile"]/div[1]/div/div/div[2]/div[3]').text.split(':')[1]

    end
#//*[@id="draft-prospect-profile"]/div[1]/div/div/div[1]/div/div[2]/div/draft-prospect-profile/section/div[2]/a

end


NbaDraft::Player.scrape_draft
#p = NbaDraft::Player.new
#p.scrape_player('http://www.nba.com/draft/2017/prospects/markelle_fultz')
#NbaDraft::Player.scrape_nba
#picks = draft.css('#draftcast-draftroundresults .draftTable__tbody .draftTable__row li')
