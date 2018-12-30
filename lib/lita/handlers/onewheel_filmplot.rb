require 'rest-client'
require 'nokogiri'
require 'cgi'

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

        title = response.matches[0][0]
        url_root = 'https://www.rottentomatoes.com'

        if title.match? '\s'
          # search

          search_term = CGI.escape(title)
          search_url = "https://www.rottentomatoes.com/search/?search=#{search_term}"
          Lita.logger.debug("Search mode!  #{search_url}")
          r = RestClient.get(search_url)
          if match = r.match(/RT.PrivateApiV2FrontendHost, '.*', ({.*})/)
            movie_json = JSON.parse match[1]
            slug = movie_json['movies'][0]['url']
            get_url = "#{url_root}#{slug}"
            Lita.logger.debug("Searching for #{get_url}")
          end
        else
          movie_slug = title.gsub ' ', '_'
          get_url = "#{url_root}/m/#{movie_slug}"
          Lita.logger.debug("Getting #{get_url}")
        end

        begin
          r = RestClient.get(get_url)
          noko_doc = Nokogiri::HTML(r)
          node = noko_doc.css('div#movieSynopsis')
          Lita.logger.debug("Replying with #{node.text.strip}")
          response.reply node.text.strip
        rescue RestClient::ResourceNotFound => e
          response.reply "#{movie_slug} not found."
        end
      end
    end

    Lita.register_handler(OnewheelFilmplot)
  end
end
