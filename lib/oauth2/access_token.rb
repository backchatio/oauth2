module OAuth2
  class AccessToken
    attr_reader :client, :token, :refresh_token, :expires_in, :expires_at

    def initialize(client, token, refresh_token = nil, expires_in = nil)
      @client = client
      @token = token
      @refresh_token = refresh_token
      @expires_in = (expires_in.nil? || expires_in == '') ? nil : expires_in.to_i
      @expires_at = Time.now + @expires_in if @expires_in
    end

    # True if the token in question has an expiration time.
    def expires?
      !!@expires_in
    end

    def request(verb, path, params = {}, headers = {})
      # AB: Spec states only one of header/querystring can be present, so this was breaking GoFreerange's OAuth provider
      #@client.request(verb, path, params.merge('oauth_token' => @token), headers.merge('Authorization' => "OAuth #{@token}"))
      @client.request(verb, path, params, headers.merge('Authorization' => "OAuth #{@token}"))
    end

    def get(path, params = {}, headers = {})
      request(:get, path, params, headers)
    end

    def post(path, params = {}, headers = {})
      request(:post, path, params, headers)
    end

    def put(path, params = {}, headers = {})
      request(:put, path, params, headers)
    end

    def delete(path, params = {}, headers = {})
      request(:delete, path, params, headers)
    end
  end
end
