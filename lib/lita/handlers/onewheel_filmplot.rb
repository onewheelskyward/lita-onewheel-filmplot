require 'rest-client'
require 'nokogiri'

module Lita
  module Handlers
    class OnewheelFilmplot < Handler
      config :api_key
      config :distance
      config :mode, default: :irc

      route /^filmplot\s+(.*)$/i,
            :get_plot,
            command: true,
            help: { '!filmplot <title>' => 'Gives you rotten tomatoes\' film summary.' }
      route /^plotline\s+(.*)$/i,
            :get_plot,
            command: true

      def get_plot(response)
        movie_slug = response.matches[0][0]
        begin
          r = RestClient.get("https://www.rottentomatoes.com/m/#{movie_slug}")
          noko_doc = Nokogiri::HTML(r)
          node = noko_doc.css('div#movieSynopsis')
          response.reply node.text.strip
        rescue RestClient::ResourceNotFound => e
          response.reply "#{movie_slug} not found."
        end
      end
    end

    Lita.register_handler(OnewheelFilmplot)
  end
end
