require 'nokogiri'
require 'open-uri'
require 'timeout'
require 'sqlite3'

def database_init
    db = SQLite3::Database.new "empik.db"

    db.execute <<-SQL
        CREATE TABLE IF NOT EXISTS products (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            info TEXT,
            price REAL,
            url TEXT
        );
    SQL

    return db
end

def scrap_product_details(url)
    product_page = Nokogiri::HTML(URI.open(url))

    description_element = product_page.at_css('.css-aym8s9-wrapper-ProductDescriptionStyles')
    product_description = ""

    if description_element
        product_description = description_element.text.strip
    end
    return product_description
end

def scrap_products(url, db)
    product_page = Nokogiri::HTML(URI.open(url))

    product_page.css('.search-list-item').each do |product|
        title = product['data-product-name'].to_s
        price = product['data-product-price'].to_f
        link = $base_url + product.css('.seoTitle').css('a').first['href']
        details = scrap_product_details(link)
        if !price.zero? and !title.empty?
            puts "====================================================================="
            puts "Title: #{title}"
            puts "Price: #{price} PLN"
            puts "URL: #{link}"
            puts "====================================================================="
            puts ""
            db.execute("INSERT INTO products (title, info, price, url) VALUES (?, ?, ?, ?)", [title, details, price, link])
        end
    end
end

def scrap_site(category, keywords)
    db = database_init

    timeout_duration = 15

    begin
        Timeout.timeout(timeout_duration) do
            scrap_products($url, db)
        end
    rescue Timeout::Error
        puts "Timeout"
    end

    db.close
end

category = "multimedia,34"
keywords = ["akcja"]
$url = "https://www.empik.com/#{category},s?q=#{keywords.join("%20")}"
$base_url = "https://www.empik.com"

scrap_site(category, keywords)