# frozen_string_literal: true
require "vault"
require "resolvme/error"

module Resolvme
  module Vault
    class Client
      # Secret with the given path not found
      class VaultSecretNotFound < ResolvmeError; end
      # Field with the given key not found inside the secret
      class VaultKeyNotFound < ResolvmeError; end

      attr_reader :vault
      # Read the secret at the provided path and return the value
      # of the field with the provided key.
      #
      # @param path [String] secret path
      # @param key [String] field key
      # @raise [VaultSecretNotFound]
      # @raise [VaultKeyNotFound]
      # @return [Object] field value
      def read_secret_field(path, key)
        secret = read_secret(path)
        raise VaultSecretNotFound,
              "Secret #{path} not found" unless secret

        value = payload(secret)[key.to_sym]

        raise VaultKeyNotFound,
              "Secret #{path} doesn't have field: #{key}" unless value
        value
      end

      # Retrieves the secret's value.
      # Handles both KV1 and KV2 secret engines.
      # @param secret [Vault::Secret] Vault secret
      # @return [Object] the secret value
      def payload(secret)
        is_kv2?(secret) ? secret.data[:data] : secret.data
      end

      # Checks whether the specified mount is versioned.
      # @param mount [Symbol] the mount path. Must end in /
      def is_versioned?(mount)
        mount_info[mount.to_sym].dig(:options, :version) ? true : false
      end

      # retrieves information about all mounts
      def mount_info
        vault.get "v1/sys/mounts"
      end

      # @return [TrueClass,FalseClass] true if the secret is KV2 and false otherwise
      def is_kv2?(secret)
        secret.data.dig(:metadata, :version)
      end

      # Initialize the object. The VAULT_GITHUB_TOKEN environment variable can
      # be used to force authentication via Github token, this is not usually
      # required if you've already authenticated via the Vault command line.
      def initialize()
        gh_token = ENV["VAULT_GITHUB_TOKEN"]
        opts = {}
        opts[:token] = ::Vault.auth.github(gh_token).auth.client_token if gh_token
        @vault = ::Vault::Client.new(opts)
        @cache = {}
      end

      # Fetches the secret from the cache or from Vault if not cached.
      def read_secret(path)
        @cache[path] ||= @vault.logical.read(path)
      end
    end
  end
end
