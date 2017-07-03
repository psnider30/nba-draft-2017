class NbaDraft2017::Scraper

  attr_accessor :name, :last_name, :first_name, :pick, :round, :nba_team, :position, :former_team, :height, :weight, :former_status, :age,
    :key_stats

  def self.scrape_draft
    doc = Nokogiri::HTML(open('http://www.cbssports.com/nba/news/2017-nba-draft-picks-complete-results-full-list-of-players-selected-highlights-grades/'))
    draft = doc.xpath('//*[@id="article-main-body"]/div/ol')
    players = []
    pick = '1'
    i = 0

    while i < 60
      player_info = draft.css('li p')[i]
      player = {}
      player[:pick] = pick.to_s
      player[:nba_team] = player_info.css('strong').text.gsub("\u00A0", "").gsub(':', '').strip
      details = player_info.text.split(' ')
      player[:position] = details. detect { |d| d.include?('(') }.strip

      if i < 30
        player[:round] = '1'
        player[:former_team] = player_info.text.split('-')[-1].chop.strip

        if details[0].include?(':')
          player[:first_name] = details[0].split(':')[1].gsub("\u00A0", "").strip
          player[:last_name] = details[1].gsub("\u00A0", "").strip
        else
          player[:first_name] = details[1].split(':')[1].gsub("\u00A0", "").strip
          player[:last_name] = details[2].gsub("\u00A0", "").strip
        end
      elsif i >= 30
        player[:round] = '2'
        player[:former_team] = details[-1].gsub("\u00A0", "").strip

        player[:first_name] = details[1].gsub("\u00A0", "").strip
        player[:last_name] = details[2].gsub("\u00A0", "").strip
      end
      player[:name] = player[:first_name] + ' ' + player[:last_name]
      players << player
      pick = pick.to_i + 1
      i += 1

      players << player
    end

    players

  end

  def self.scrape_player(player_url)
    player_page = Nokogiri::HTML(open(player_url))
    player = {}
    #profile = player_page.css('#draft-prospect-profile')
    ht_weight = player_page.css('.stats').text.split(':')[1]
    player[:height] = ht_weight.split('/')[0].gsub("\"", "").strip
    player[:weight] = ht_weight.split('/')[1].strip
    player[:former_status] = player_page.css('.status').text.split(':')[1].strip
    dob = player_page.css('.birthday').text.split(':')[1].strip
    player[:age] = get_age(dob)
    player[:key_stats] = get_key_stats(player_page)
    player
  end

  def self.get_age(dob)
    b_year= dob.split(' ')[2].strip.to_i
    b_month = Date::MONTHNAMES.index(dob.split(' ')[0].strip)
    b_day = dob.split(' ')[1].chop.strip.to_i
    age = Date.today.year - b_year - ((Date.today.month > b_month || (Date.today.month == b_month && date.today.day >= b_day)) ? 0 : 1)
  end

  def self.get_key_stats(player_page)
    idx = 0
    while idx < 15
      if player_page.css(".field-items p[#{idx}] strong").text.downcase.strip == "key statistics:"
        return key_stats = player_page.css(".field-items p[#{idx}]").text.split(':')[1].strip
      end
      idx += 1
    end
  end

end