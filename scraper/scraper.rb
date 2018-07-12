require 'rubygems'
require 'nokogiri'       
require 'open-uri'

# ************************* EXO 1 **********************

def  get_the_email_of_a_townhal_from_its_webpage(urls_commune)
    
    email_regex =  /.+\@.+\..+/
    my_hash = {}
    
    urls_commune.each do |url|
        data = Nokogiri::HTML(open(url))
        rows = data.css("td")
        ville = url.split("/").last.gsub(".html","")
        rows.each do |row|
         
            if  row.inner_html.encode('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: '') =~ email_regex
               my_hash[ville] = row.inner_html
             end 
        end
        
    end
    return my_hash
end

def get_all_the_urls_of_val_doise_townhalls(url_departement)
    data = Nokogiri::HTML(open(url_departement))
    rows = data.css(".lientxt").map { |link| link['href'] } 
    
    links = []
    k=0
    rows.each do |link|
        
        links[k] = link.gsub("./","http://annuaire-des-mairies.com/")
        k+=1
        
    end
    return links
end
# ************************* EXO 2 **********************
def  get_the_name_and_price_of_cryptocurrencies(crypto_url)

    crypto = Hash.new
    
    data = Nokogiri::HTML(open(crypto_url))
    row = data.css("tbody").css('tr').each{|tr|
	    crypto[tr.css('a')[1].text] = tr.css('td')[4].text.to_s.delete("\n")
		}	
    return crypto
end
# ************************* EXO 3 **********************
def get_all_depute_name_and_email(main_url)
    regex =  /[a-z][a-z\-]+/
    arr = []
    z=0
    data = Nokogiri::HTML(open(main_url))
    rows = data.css(".list_ann li").map{ |li| li.search('h2','.ann_mail')}
    rows.each do |data|
      if data.inner_html  =~  regex
            
        arr[z] =data.inner_html
        z +=1
      end
    end
    my_hash=Hash[*arr.flatten]
    return my_hash
end


puts "************************* EXO 1 **********************"

urls_commune = get_all_the_urls_of_val_doise_townhalls("http://annuaire-des-mairies.com/val-d-oise.html")
puts get_the_email_of_a_townhal_from_its_webpage(urls_commune)

puts "************************* EXO 2 **********************"

puts get_the_name_and_price_of_cryptocurrencies("https://coinmarketcap.com/all/views/all/")
puts "************************* EXO 3 **********************"

puts get_all_depute_name_and_email("https://www.voxpublic.org/spip.php?page=annuaire&cat=deputes&pagnum=577")