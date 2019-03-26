# frozen_string_literal: true
require "vault"

module Resolvme
  module Vault
    class Client
      class VaultKeyNotFoundException < ::ResolvmeError; end

      def get_secret(path, query)
        query_keys = query.split("/").map(&:to_sym)
        cache[path] ||= {}
        # TODO what if we have a key in vault containing / ?
        #   {
        #    "foo/bar/jar" : 1
        #  }
        # This will be treated the same as
        #  {
        #   foo: { bar: { jar: 1 }}
        #  }
        val = cache[path][query]
        return val unless val.nil?
        cache[path][query] = vault_secret(path, query_keys)
      end

      private

      def cache
        @cache ||= {}
      end

      def vault
        @vault ||= begin
          gh_token = ENV.fetch("VAULT_GITHUB_TOKEN", false)
          if gh_token
            vault_token = Vault.auth.github(gh_token)
            ::Vault::Client.new(address: ENV["VAULT_ADDR"], token: vault_token.auth.client_token)
          else
            # use ENV["VAULT_ADDR"] and ENV["VAULT_TOKEN"] if set
            ::Vault::Client.new
          end
        end
      end

      def vault_data(path, options = {})
        attempts = options.fetch(:attempts, 1)
        vault.with_retries(::Vault::HTTPError, attempts: attempts) do |attempt, e|
          warn "Received exception #{e} from Vault - attempt #{attempt}" if e
          vault.logical.read(path)
        end
      end

      def vault_secret(path, query = [], options = {})
        secret = vault_data(path, options)
        if secret.nil?
          msg = "Path: #{path}"
          msg += ", Keys: #{query.join(' -> ')}" unless query.empty?
          msg += ". Called from #{caller[0]}"
          raise VaultKeyNotFoundException, msg
        end
        return secret.data if query.empty?
        val = secret.data.dig(*query)
        if (val).nil?
          raise VaultKeyNotFoundException, "Path: #{path}, query: #{query}"
        end
        val
      end

    end
  end
end
