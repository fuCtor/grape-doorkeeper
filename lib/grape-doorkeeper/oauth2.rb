require 'grape/api'
require 'doorkeeper/doorkeeper_for'
module GrapeDoorkeeper
  # OAuth 2.0 authorization for Grape APIs.

  class Middleware < Grape::Middleware::Auth::OAuth2

    def protected_endpoint?
      endpoint = env['api.endpoint']
      return endpoint.options[:route_options][:protected] if endpoint.options[:route_options].key?(:protected)

      filter_options = options[:doorkeeper].filter_options
      return true if filter_options.blank? #protect all routes

      action = endpoint.namespace.split('/')[1] || endpoint.options[:path].first

      if filter_options[:only]
        return filter_options[:only].include?( action.to_sym )
      elsif filter_options[:except]
        return !filter_options[:except].include?( action.to_sym )
      end

      false
    end

    def verify_token(token_string)
      return unless protected_endpoint?
      token = Doorkeeper::AccessToken.authenticate(token_string)
      doorkeeper = options[:doorkeeper]
      if env['api.endpoint'].options[:route_options].key?(:scopes)
        doorkeeper = Doorkeeper::DoorkeeperForBuilder.create_doorkeeper_for(:all, scopes: env['api.endpoint'].options[:route_options][:scopes])
      end

      if token
        if !token.accessible?
          error_out(401, 'expired_token')
        else
          if token.acceptable?(doorkeeper.send(:scopes))
            env['api.token'] = token
          else
            error_out(403, 'insufficient_scope')
          end
        end
      else
        error_out(401, 'invalid_token')
      end
    end

    def error_out(status, error)
      scopes = options[:doorkeeper].instance_variable_get(:@scopes)

      throw :error,
            message:  {error: error},
            status: status,
            headers: {
              'Content-Type' => 'application/json',
              'X-Accepted-OAuth-Scopes' => scopes,
              'WWW-Authenticate' => "OAuth realm='#{options[:realm]}', error='#{error}'"
            }.reject { |k,v| v.nil? }
    end

  end

  module OAuth2
    def doorkeeper_for *args
      doorkeeper_for = Doorkeeper::DoorkeeperForBuilder.create_doorkeeper_for(*args)
      use GrapeDoorkeeper::Middleware, doorkeeper: doorkeeper_for
    end
  end

end

Grape::API.extend GrapeDoorkeeper::OAuth2
