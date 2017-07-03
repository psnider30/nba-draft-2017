# Our CLI controller
class NbaDraft2017::Cli

  BASE_PATH = "http://www.nba.com/draft/2017/prospects/"

  def call
    puts '2017 NBA Draft Picks'
    list_players
  end

  def list_players
    puts "2017 NBA draft results"
    NbaDraft2017::Scraper.scrape_nba
    #NbaDraft2017::Scraper.scrape_draft
    #NbaDraft2017::Scraper.scrape_player(BASE_PATH + 'alpha_kaba')
  	# Here Doc http://blog.jayfields.com/2006/12/ruby-multiline-strings-here-doc-or.html
  	#puts <<-DOC.gsub(/^\s+/, '')
	  	#1. Markelle Fultz
	  	#2. Lonzo Ball
  	#DOC
  end

  def menu

  end

  def good_bye
    puts "Thanks for checking out the 2017 NBA Draft! Prognosis: Sorry, you're teams probably still going to lose to the Warriors!"
  end
end