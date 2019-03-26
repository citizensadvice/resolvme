#!/usr/bin/env ruby
require "vault/vault"

def vault(path, key)
  @vault ||= ::Resolvme::Vault::Vault.new
  @vault.get_secret(path, key)
end
