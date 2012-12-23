#!/usr/bin/ruby1.9.3
require 'mechanize'
require 'nokogiri'

@x = false

usage = "ruby rankingcalculator.rb [site] [keywork] [[en/it]] [[text/html]]"


if ARGV[0]
	@site = ARGV[0]
	@keyword = ARGV[1]
	if ARGV[2] && ARGV[2] == 'en'
		@google_address = 'http://www.google.com/webhp?hl=us'
		@next_link = 'Next'
	else
		@google_address = 'http://www.google.com/webhp?hl=it'
		@next_link = 'Avanti'
	end
	if ARGV[3] && ARGV[3] == 'html'
		@rendertype = 'html'
	else
		@rendertype = 'text'
	end
else
	puts usage
	exit
end


def render(pagenumber,pos,totres,rendertype)
	if rendertype == 'html'
		html = "</br>
			<b>pagenumber:</b><span>#{pagenumber.to_s}</span></br>
			<b>page position:</b><span>#{pos.to_s}</span></br>
			<b>absolute position:</b><span>#{totres.to_s}</span></br>
			</br>
			"
		puts html

	else
		puts 'site found!'
		puts "\tpagenumber: " + pagenumber.to_s + "\n\tpage position: " + pos.to_s + "\n\tabsolute position: " + totres.to_s
	end
end

def check(ap,pagenumber)
	page_html = Nokogiri::HTML.parse(ap.content)
	results = page_html.xpath('//*[@id="ires"]/ol/li')

	# shows the actual page
	#puts 'pagina: ' + pagenumber.to_s
	
	# new page = position -> 0
	pos = 0


	results.each do |result|
		pos += 1
		@totres += 1
		while result.xpath("div/div/cite").inner_text.include? @site
			@x = true
			render(pagenumber,pos,@totres,@rendertype)
			break
		end
	end	
end

begin
	agent = Mechanize.new
	agent.get @google_address
	agent.page
	agent.page.forms.first.field_with(:name => "q").value = @keyword
	agent.page.forms.first.submit
rescue
	puts "#{$!}"
	exit
end



pagenumber = 1
@totres = 0


while @x != true
	check(agent.page,pagenumber)
	if agent.page.link_with(:text => @next_link)
		agent.page.link_with(:text => @next_link).click
	else
		puts 'no other pages, site not found'
		break
	end
	pagenumber += 1
end

