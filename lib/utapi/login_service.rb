require 'utapi/authorization'
require 'utapi/exceptions'
require 'utapi/connection'

# Returns a new instance of Authorization

# TODO: Make the do_* functions less reliant on instance variables, and pass them in as parameters instead.

module UTApi
  class LoginService

    def initialize(account)
      @connection = Connection.new
      @account = account

      @connection.request_interval = 0
    end


    def execute
      @nucleus_user_id = do_initial_login
      do_futweb_cookie_stage
      @server = get_server
      @persona_id, @persona_name = get_account_info
      do_auth_stage
      @phishing_token = get_phishing_token

      Authorization.new(server: @server, phishing_token: @phishing_token, sid: @sid)
    end

  private

    def require_instance_variables(*vars)
      vars.map!(&:to_s)
      unless vars.all? { |var| instance_variable_defined?("@#{var}") }
        raise "Required instance variables #{vars.join(', ')} not set"
      end
    end

    def generate_headers(*fields)
      {}.tap do |headers|
        headers['Easw-Session-Data-Nucleus-Id'] = @nucleus_user_id.to_s if fields.include?(:nuc)
        headers['X-UT-Route'] = @server || 'https://utas.fut.ea.com' if fields.include?(:route)
        headers['X-UT-SID'] = @sid if fields.include?(:sid)
      end
    end

    # Returns nucleus user id
    def do_initial_login
      response = @connection.get 'http://www.easports.com/fifa/football-club/ultimate-team'

      r2 = @connection.post(
          response.env[:url],
          {email: @account.email, password: @account.password, rememberMe: 'on', _rememberMe: 'on', _eventId: 'submit', facebookAuth: ''},
          {referer: response.env[:url].to_s}
      )

      extract_nucleus_user_id(r2.env[:body])
    end

    def extract_nucleus_user_id(body)
      nucleus_user_id = body.match /userid : "(\d+)"/
      raise LoginError, 'Cannot get nucleus user id' if nucleus_user_id.nil? or nucleus_user_id[1].to_i == 0
      nucleus_user_id[1].to_i
    end

    def do_futweb_cookie_stage
      @connection.get('http://www.easports.com/iframe/fut/', {
          locale: 'en_GB',
          baseShowoffUrl: 'http://www.easports.com/uk/fifa/football-club/ultimate-team/show-off',
          guest_app_uri:'http://www.easports.com/uk/fifa/football-club/ultimate-team'
      })
    end

    def get_server
      require_instance_variables :nucleus_user_id

      shards = @connection.get('http://www.easports.com/iframe/fut/p/ut/shards', {}, generate_headers(:nuc, :route))

      shard = shards.env[:body]['shardInfo'].find do |shard|
        shard['platforms'].include?(@account.platform.to_s)
      end

      raise LoginError, 'Could not find the server' if shard.nil?

      "#{shard['clientProtocol']}://#{shard['clientFacingIpPort']}"
    end

    def get_account_info
      require_instance_variables :server, :nucleus_user_id

      account_info = @connection.get('http://www.easports.com/iframe/fut/p/ut/game/fifa14/user/accountinfo', {}, generate_headers(:nuc, :route))

      raise LoginError, "Could not get account info: #{account_info}" unless account_info.env[:body].is_a?(Hash)

      persona = account_info.env[:body]['userAccountInfo']['personas'][0]

      # TODO: Extract a AccountInfo value object for these
      [persona['personaId'], persona['personaName']]

    end

    def do_auth_stage
      require_instance_variables :persona_id, :nucleus_user_id, :server, :persona_name

      payload = {
          isReadOnly: false,
          sku: 'FUT14WEB',
          clientVersion: 1,
          nuc: @nucleus_user_id,
          nucleusPersonaId: @persona_id,
          nucleusPersonaDisplayName: @persona_name,
          #nucleusPersonaPlatform: 'ps3', # 360 or ps3 TODO: WHERE DO THESE COME FROM??!! and is it needed?
          locale: 'en-GB',
          method: 'authcode',
          priorityLevel: 4,
          identification: { authCode: '' }
      }

      headers = generate_headers(:nuc, :route).merge({'Content-Type' => 'application/json'})

      auth = @connection.post('http://www.easports.com/iframe/fut/p/ut/auth', payload, headers)

      @sid = auth.env[:body]['sid']

    end

    def get_phishing_token

      payload = { answer: @account.hash }

      response = @connection.post('http://www.easports.com/iframe/fut/p/ut/game/fifa14/phishing/validate', payload, generate_headers(:nuc, :route, :sid))

      # This must be parsed manually, because the content-type sent isn't right!
      JSON.parse(response.env[:body])['token']

    end

  end
end