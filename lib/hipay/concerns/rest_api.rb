require "net/https"
require 'uri'

module RestApi
  extend ActiveSupport::Concern

    def initialize opts = {}
      @options = opts.with_indifferent_access
      @uri = set_uri
      @http = Net::HTTP.new(@uri.host, @uri.port)
      @http.use_ssl = true if @uri.port == 443
    end

    {
      post: true,
      put: true,
      patch: true,
      delete: false,
      get: false
    }.each do |method, has_body|
      define_method method do |url, attrs|
        if has_body
          query method, get_path(url), attrs
        else
          query method, get_path(url, attrs)
        end
      end
    end

    def get_path url, attrs = {}
      full_path = [@uri.request_uri, url].join('/')
      if attrs.present?
        return [full_path, URI.encode_www_form(attrs)].join('?')
      else
        return full_path
      end
    end

    def query(method, full_path, attrs = {})
      req = "Net::HTTP::#{method.to_s.capitalize}".constantize.new full_path

      req.set_form_data attrs unless attrs.blank?

      req.basic_auth(@options[:username], @options[:password])

      handle_response @http.request(req)
    end

    def handle_response response
      Hash.from_xml(response.read_body)["response"]
    end

    private
      def set_uri
        urls = retrieve_urls(self.class)

        @options[:env_test] ||= true

        if @options[:url]
          uri_to_parse = @options[:url]
        else
          uri_to_parse = @options[:env_test].to_s == "true" ? urls[:test_url] : urls[:prod_url]
        end

        URI.parse(uri_to_parse)
      end

      def retrieve_urls(current_class)
        case current_class.to_s
        when "Hipay::Client::TPP"
          test_url = Hipay::GATEWAY_TEST_URL
          prod_url = Hipay::GATEWAY_PROD_URL
        when "Hipay::Client::Tokenization"
          test_url = Hipay::TOKENIZATION_TEST_URL
          prod_url = Hipay::TOKENIZATION_PROD_URL
        end
        return {test_url: test_url, prod_url: prod_url}
      end


end
