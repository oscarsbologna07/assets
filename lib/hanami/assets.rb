# frozen_string_literal: true

require "json"
require "zeitwerk"

# Hanami
#
# @since 0.1.0
module Hanami
  # Assets management for Ruby web applications
  #
  # @since 0.1.0
  class Assets
    # @since 2.1.0
    # @api private
    def self.gem_loader
      @gem_loader ||= Zeitwerk::Loader.new.tap do |loader|
        root = File.expand_path("..", __dir__)
        loader.tag = "hanami-assets"
        loader.push_dir(root)
        loader.ignore(
          "#{root}/hanami-assets.rb",
          "#{root}/hanami/assets/version.rb",
          "#{root}/hanami/assets/errors.rb"
        )
        loader.inflector = Zeitwerk::GemInflector.new("#{root}/hanami-assets.rb")
      end
    end

    gem_loader.setup
    require_relative "assets/version"
    require_relative "assets/errors"

    # @since 2.1.0
    # @api private
    SEPARATOR = "/"
    private_constant :SEPARATOR

    attr_reader :config

    # @since 2.1.0
    # @api public
    def initialize(config:)
      @config = config
    end

    # @since 2.1.0
    # @api public
    def [](path)
      asset_attrs = manifest
        .fetch(path) { raise AssetMissingError.new(path) }
        .transform_keys(&:to_sym)
        .tap { |attrs|
          # The `url` attribute we receive from the manifest is actually a path; rename it as such
          # so our `Asset` attributes make more sense on their own.
          attrs[:path] = attrs.delete(:url)
        }

      Asset.new(
        **asset_attrs,
        base_url: config.base_url
      )
    end

    # @since 2.1.0
    # @api public
    def subresource_integrity?
      config.subresource_integrity.any?
    end

    # @since 2.1.0
    # @api public
    def crossorigin?(source_path)
      config.crossorigin?(source_path)
    end

    private

    def manifest
      return @manifest if instance_variable_defined?(:@manifest)

      unless config.manifest_path
        raise ConfigError, "no manifest_path configured"
      end

      unless File.exist?(config.manifest_path)
        raise ManifestMissingError.new(config.manifest_path)
      end

      @manifest = JSON.parse(File.read(config.manifest_path))
    end
  end
end
