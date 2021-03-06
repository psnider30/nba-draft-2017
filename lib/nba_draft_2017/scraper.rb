require "open_uri_redirections"
class NbaDraft2017::Scraper

  def self.scrape_draft
    doc = Nokogiri::HTML(open('http://www.cbssports.com/nba/news/2017-nba-draft-picks-complete-results-full-list-of-players-selected-highlights-grades/', :allow_redirections => :safe))
    draft = doc.xpath('//*[@id="article-main-body"]/div/ol')
    players = []
    pick = '1'

    i = 0
    while i < 60
      player = {}
      player_info = draft.css('li p')[i]

      player[:pick] = pick.to_s
      player[:nba_team] = player_info.css('strong').text.gsub("\u00A0", '').gsub(':', '').strip
      player[:former_team] = player_info.text.split('-')[-1].gsub("\u00A0", '').gsub(':', '').strip
      details = player_info.text.split(' ')
      player[:position] = details. detect { |d| d.include?('(') }.strip

      if i < 30
        player[:round] = '1'

        if details[0].include?(':')
          player[:first_name] = details[0].split(':')[1].gsub(/\W/, "").strip
          player[:last_name] = details[1].gsub(/\W/, "").strip
        else
          player[:first_name] = details[1].split(':')[1].gsub(/\W/, "").strip
          player[:last_name] = details[2].gsub(/\W/, "").strip
        end

      elsif i >= 30
        player[:round] = '2'

        player[:first_name] = details[1].gsub(/\W/, "").strip
        player[:last_name] = details[2].gsub(/\W/, "").strip
      end

      player[:name] = player[:first_name].strip + ' ' + player[:last_name].strip
      if player[:first_name] == 'Andzejs'
        player[:profile_url] = 'anzejs_pasecniks'
      else
        player[:profile_url] = player[:first_name].gsub(/\W/, '').downcase + '_' + player[:last_name].gsub(/\W/, '').downcase
      end
      NbaDraft2017::Player.new(player)
      pick = pick.to_i + 1
      i += 1
    end
  end

  def self.scrape_player(profile_url)
    player_page = Nokogiri::HTML(open(profile_url, :allow_redirections => :safe))
    player = {}
    ht_weight = player_page.css('.stats').text.split(':')[1]

    player[:height] = ht_weight.split('/')[0].gsub("\"", "").strip if ht_weight
    player[:weight] = ht_weight.split('/')[1].strip if ht_weight
    player[:former_status] = player_page.css('.status').text.split(':')[1].strip

    dob = player_page.css('.birthday').text.split(':')[1].strip
    player[:age] = get_age(dob) if dob

    stats = get_key_stats(player_page)
    split_key_stats(stats, player) if stats

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
    player[:key_stats] = stats.strip.split(',').collect do |stat|

      if stat.downcase.include?('ppg')
        player[:ppg] = stat.split(' ')[0].strip.to_f
        player[:ppg].to_s + ' ' + stat.split(' ')[1].strip
      elsif stat.downcase.include?('rpg')
        player[:rpg] = stat.split(' ')[0].strip.to_f
        player[:rpg].to_s + ' ' + stat.split(' ')[1].strip
      elsif stat.downcase.include?('apg')
        player[:apg] = stat.split(' ')[0].strip.to_f
        player[:apg].to_s + ' ' + stat.split(' ')[1].strip
      elsif stat.downcase.include?('tpg')
        player[:tpg] = stat.split(' ')[0].strip.to_f
        player[:tpg].to_s + ' ' + stat.split(' ')[1].strip
      elsif stat.downcase.include?('spg')
        player[:spg] = stat.split(' ')[0].strip.to_f
        player[:spg].to_s + ' ' + stat.split(' ')[1].strip
      elsif stat.downcase.include?('bpg')
        player[:bpg] = stat.split(' ')[0].strip.to_f
        player[:bpg].to_s + ' ' + stat.split(' ')[1].strip
      elsif stat.downcase.include?('mpg')
        player[:mpg] = stat.split(' ')[0].strip.to_f
        player[:mpg].to_s + ' ' + stat.split(' ')[1].strip
       elsif stat.downcase.include?('fg')
        player[:fg] = stat.split(' ')[0].strip.to_f
        player[:FG].to_s + ' ' + stat.split(' ')[1].strip
      elsif stat.downcase.include?('3pt')
        player[:three] = stat.split(' ')[0].strip.to_f
        player[:_3PT].to_s + ' ' + stat.split(' ')[1].strip
      elsif stat.downcase.include?('ft')
        player[:ft] = stat.split(' ')[0].strip.to_f
        player[:FT].to_s + ' ' + stat.split(' ')[1].strip
      end
    end
  end

end
