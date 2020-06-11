require 'open-uri'
require 'nokogiri'
#require 'byebug'
#require 'colorize'


t=0
phone=[]
$price=[]
title=[]
linki=[]
$id=[]
$old_id=[]
dd=[]
yourfile="baza.txt"

def pars
  url = 'https://www.avito.ru/barnaul/avtomobili?cd=1&radius=200'
  html = open(url) { |r| r.read }
  @doc = Nokogiri::HTML(html)
end

# DEF Считали старый файл
def loadid()
  File.open("baza.txt", "r").each_line do |line|
    $old_id << line
  end
end

# DEF Спарсили страницу
def razbor()
  @doc.css('.item_table-wrapper').each do |k|
  name=k.css('h3')[0].text
  link=k.css('a')[0]['href']
  p=k.css('.snippet-price-row').text.gsub(/[\?] /,'').split
  $price << "#{link}==#{p[0]}#{p[1]}\n"
  $id << "#{link}==#{p[0]}#{p[1]}\n".split('_').last
  end
end

def sravnil()
# Сравнили списки двух массивов
puts "++++++++++++++++"
$old_id.each do |ll|
  if $id.include?(ll) 
  
  else 
   puts "New - #{ll}" 
  end
end
end

token = ENV['TELEGRAM_BOT_API_KEY']

Telegram::Bot::Client.run(token) do |bot|
  bot.listen do |message|
    case message.text
    when '/start'
	pars()
	loadid()
	razbor()
	sravnil()
      bot.api.send_message(chat_id: message.chat.id, text: "Hello, #{ll}")
    when '/stop'
      bot.api.send_message(chat_id: message.chat.id, text: "Bye, #{message.from.first_name}")
    end
  end
end

# Считали старый файл



#puts old

puts '\\\\\\\\\\\\\\\\\\'

# Перезаписали файл основной с базой
File.open(yourfile, 'w') do |f| 
  f.puts($id)
end

