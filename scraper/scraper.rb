require 'rubygems'
require 'nokogiri'       
require 'open-uri'

# ************************* EXO 1 **********************
#NEED SOME IMPROVEMENT BUDDY!!!

def  get_the_email_of_a_townhal_from_its_webpage(urls_commune) #prend en parametre un tableau de string et chaque string est un lien
    
    email_regex =  /.+\@.+\..+/ # regex pour reconaitre un email
    my_hash = {}#cree un hash
    
    urls_commune.each do |url|  # parcours chaque lien dans le tableau de lien
        data = Nokogiri::HTML(open(url)) #ouvre le lien
        rows = data.css("td") #cible la table data
        ville = url.split("/").last.gsub(".html","") #recupere le nom de la ville
        rows.each do |row| # boucle dans chaque row
         
            if  row.inner_html.encode('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: '') =~ email_regex #verifie si c'est un email
               my_hash[ville] = row.inner_html #ajoute le ville et l'eam dans l'array
             end 
        end
        
    end
    return my_hash #retourne l'array
end

def get_all_the_urls_of_val_doise_townhalls(url_departement) #prend en paramete la page ou se trouve la liste des urls des communes de val d'oise
    data = Nokogiri::HTML(open(url_departement)) #ouvre le site
    rows = data.css(".lientxt").map { |link| link['href'] } #va dans la classe lientext et recupere le lien des mairies avec ./
    
    links = []
    k=0
    rows.each do |link| #parcours le tableau
        
        links[k] = link.gsub("./","http://annuaire-des-mairies.com/") #enleve les ./ et remplace par annuaire des mairies
        k+=1
        
    end
    return links # retourne le tableau de lien
end
# ************************* EXO 2 **********************
def  get_the_name_and_price_of_cryptocurrencies(crypto_url) # prend en parametre le len de coinmarketcap

    crypto = Hash.new  # cree un hash
    
    data = Nokogiri::HTML(open(crypto_url))   #va sur le site de coinmarketcap
    row = data.css("tbody").css('tr').each{|tr|  #va cibler la balise tbody et recupere chaque nom et pix de cryptomonaie
	    crypto[tr.css('a')[1].text] = tr.css('td')[4].text.to_s.delete("\n")
		}	
    return crypto  #retourne le hash avec les noms des cryptos et leurs prix
end
# ************************* EXO 3 **********************
def get_all_depute_name_and_email(main_url)
    regex =  /[a-z][a-z\-]+/  #regex pour nom et email No phone or pseudo twitter
    arr = []  #cree un array
    z=0  #cree un compteur
    data = Nokogiri::HTML(open(main_url)) #ouvre url site infos deputee
    rows = data.css(".list_ann li").map{ |li| li.search('h2','.ann_mail')} #cible la classe list_ann  et cherche balise h2 et la classe ann_mail
    rows.each do |data|  #parcour le tableau
      if data.inner_html  =~  regex  #verifie si c'est un nom ou un email
            
        arr[z] =data.inner_html  #ajoute data dans array
        z +=1 #incremente compteur
      end
    end
    my_hash=Hash[*arr.flatten]  # cree un hash a partir de l'array avec key index n et value index n+1
    return my_hash #retourne le hash
end


puts "************************* EXO 1 **********************"

urls_commune = get_all_the_urls_of_val_doise_townhalls("http://annuaire-des-mairies.com/val-d-oise.html")
puts get_the_email_of_a_townhal_from_its_webpage(urls_commune)  #lance exo 1

puts "************************* EXO 2 **********************"

puts get_the_name_and_price_of_cryptocurrencies("https://coinmarketcap.com/all/views/all/")  #lance exo 2
puts "************************* EXO 3 **********************"

puts get_all_depute_name_and_email("https://www.voxpublic.org/spip.php?page=annuaire&cat=deputes&pagnum=577")  # lance exos 3