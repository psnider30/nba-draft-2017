class NbaDraft2017::Scraper

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
      player[:former_team] = player_info.text.split('-')[-1].gsub("\u00A0", "").strip
      details = player_info.text.split(' ')
      player[:position] = details. detect { |d| d.include?('(') }.strip

      if i < 30
        player[:round] = '1'

        if details[0].include?(':')
          player[:first_name] = details[0].split(':')[1].gsub("\u00A0", "").strip
          player[:last_name] = details[1].gsub("\u00A0", "").strip
        else
          player[:first_name] = details[1].split(':')[1].gsub("\u00A0", "").strip
          player[:last_name] = details[2].gsub("\u00A0", "").strip
        end
      elsif i >= 30
        player[:round] = '2'

        player[:first_name] = details[1].gsub("\u00A0", "").strip
        player[:last_name] = details[2].gsub("\u00A0", "").strip
      end
      player[:name] = player[:first_name] + ' ' + player[:last_name]
      if player[:first_name] == 'Andzejs'
        player[:profile_url] = 'anzejs_pasecniks'
      else
        player[:profile_url] = player[:first_name].gsub(/\W/, '').downcase + '_' + player[:last_name].gsub(/\W/, '').downcase
      end
      players << player
      pick = pick.to_i + 1
      i += 1
    end
    players
  end

  def self.scrape_player(profile_url)
    player_page = Nokogiri::HTML(open(profile_url))
    player = {}
    #profile = player_page.css('#draft-prospect-profile')
    ht_weight = player_page.css('.stats').text.split(':')[1]
    player[:height] = ht_weight.split('/')[0].gsub("\"", "").strip if ht_weight
    player[:weight] = ht_weight.split('/')[1].strip if ht_weight
    player[:former_status] = player_page.css('.status').text.split(':')[1].strip
    dob = player_page.css('.birthday').text.split(':')[1].strip
    player[:age] = get_age(dob) if dob
    stats = get_key_stats(player_page)
    split_key_stats(stats, player)
    player
  end

  def self.get_age(dob)
    b_year= dob.split(' ')[2].strip.to_i
    b_month = Date::MONTHNAMES.index(dob.split(' ')[0].strip)
    b_day = dob.split(' ')[1].chop.strip.to_i
    age = Date.today.year - b_year - ((Date.today.month > b_month || (Date.today.month == b_month && Date.today.day >= b_day)) ? 0 : 1)
  end

  def self.get_key_stats(player_page)
    stats = nil
    idx = 10
    while idx <= 14 && stats == nil
      if player_page.css(".field-items p[#{idx}] strong").text.downcase.strip == "key statistics:"
        stats = player_page.css(".field-items p[#{idx}]").text.split(':')[1].strip
      end
      idx += 1
    end
    stats
  end

  def self.split_key_stats(stats, player)
    if stats
      player[:key_stats] = []
      stats.strip.split(','). each do |stat|
        if stat.downcase.include?('ppg')
          player[:ppg] = stat.split(' ')[0].strip.to_f
          player[:key_stats] << player[:ppg].to_s + ' ' + stat.split(' ')[1].strip
        elsif stat.downcase.include?('rpg')
          player[:rpg] = stat.split(' ')[0].strip.to_f
          player[:key_stats] << player[:rpg].to_s + ' ' + stat.split(' ')[1].strip
        elsif stat.downcase.include?('apg')
          player[:apg] = stat.split(' ')[0].strip.to_f
          player[:key_stats] << player[:apg].to_s + ' ' + stat.split(' ')[1].strip
        elsif stat.downcase.include?('tpg')
          player[:tpg] = stat.split(' ')[0].strip.to_f
          player[:key_stats] << player[:tpg].to_s + ' ' + stat.split(' ')[1].strip
        elsif stat.downcase.include?('spg')
          player[:spg] = stat.split(' ')[0].strip.to_f
          player[:key_stats] << player[:spg].to_s + ' ' + stat.split(' ')[1].strip
        elsif stat.downcase.include?('bpg')
          player[:bpg] = stat.split(' ')[0].strip.to_f
          player[:key_stats] << player[:bpg].to_s + ' ' + stat.split(' ')[1].strip
        elsif stat.downcase.include?('mpg')
          player[:mpg] = stat.split(' ')[0].strip.to_f
          player[:key_stats] << player[:mpg].to_s + ' ' + stat.split(' ')[1].strip
        elsif stat.downcase.include?('FG')
          player[:FG] = stat.split(' ')[0].strip.to_f
          player[:key_stats] << player[:FG].to_s + ' ' + stat.split(' ')[1].strip
        elsif stat.downcase.include?('3PT')
          player[:_3PT] = stat.split(' ')[0].strip.to_f
          player[:key_stats] << player[:_3PT].to_s + ' ' + stat.split(' ')[1].strip
        elsif stat.downcase.include?('FT')
          player[:FT] = stat.split(' ')[0].strip.to_f
          player[:key_stats] << player[:FT].to_s + ' ' + stat.split(' ')[1].strip
        end
      end
    end
  end

end
