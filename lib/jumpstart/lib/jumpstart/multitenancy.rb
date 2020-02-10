module Jumpstart
  module Multitenancy

    def self.domain?
      selected.include?("domain")
    end

    def self.subdomain?
      selected.include?("subdomain")
    end

    def self.path?
      selected.include?("path")
    end

    def self.session?
      selected.include?("session")

    def self.selected
      Array.wrap(Jumpstart.config.multitenancy)
    end
  end
end
