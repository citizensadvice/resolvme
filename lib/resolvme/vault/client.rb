# frozen_string_literal: true
require "vault"
require "pathname"
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
        path = update_path_if_kv2(path)
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
        kv2_secret?(secret) ? secret.data[:data] : secret.data
      end

      # Checks whether the specified mount is versioned.
      # @param mount [Symbol] the mount path. Must end in /
      def versioned_mount?(mount)
        mount_info[mount.to_sym].dig(:options, :version) ? true : false
      end

      # retrieves information about all mounts
      def mount_info
        vault.get "v1/sys/mounts"
      end

      # @return [TrueClass,FalseClass] true if the secret is KV2 and false otherwise
      def kv2_secret?(secret)
        secret.data.dig(:metadata, :version)
      end

      # Initialize the object. The VAULT_GITHUB_TOKEN environment variable can
      # be used to force authentication via Github token, this is not usually
      # required if you've already authenticated via the Vault command line.
      def initialize
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

      # Updates the Vault path to include data/ if
      # if it is mounted on a KV v2 mount and doesn't include data/ already
      def update_path_if_kv2(path)
        if versioned_path?(path) && path_nodes(path)[1] != "data"
          return path_nodes(path).insert(1, "data").join("/")
        end

        path
      end

      # Checks if the given path is on a mount using the KV2 engine
      # and caches the result in #cache
      def versioned_path?(path)
        mount = mount_point(path)
        # cache mount checks for significant speedup
        @cache[mount] ||= versioned_mount?(mount)
        @cache[mount]
      end

      # @return [String] the mount point of the path.
      # This is the root node of the path including /
      def mount_point(path)
        path_nodes(path).first + "/"
      end

      # @return [Array] an array with the nodes of the path, e.g.
      # /secret/data/foo/bar -> ["secret", "data", "foo", "bar"]
      def path_nodes(path)
        Pathname.new(path).each_filename.to_a
      end
    end
  end
end

