require 'telegram/bot'
require 'http'

token = 'token'

access_token = 'token'


Telegram::Bot::Client.run(token) do |bot|
  bot.listen do |message|
    case message.text
      when '/start'
        bot.api.send_message(chat_id: message.chat.id,
                             text: "Hello, #{message.from.first_name}. Write /go to get last 5 posts of your friends")
      when '/go'
        data = HTTP.get("https://api.instagram.com/v1/users/self/media/recent/?access_token=#{access_token}&count=5")
        data = JSON.parse data.body
        data['data'].each do |image|
          bot.api.send_message(chat_id: message.from.id, text: "#{image['images']['standard_resolution']['url']}", parse_mode: "HTML" )
          if image['caption']
            bot.api.send_message(chat_id: message.chat.id, text: "#{  image['caption']['text']}")
          end
        end

      when '/stop'
        bot.api.send_message(chat_id: message.chat.id, text: "Bye, #{message.from.first_name}")
    end
  end
end


