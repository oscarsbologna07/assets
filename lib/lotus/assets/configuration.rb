require 'lotus/assets/config/asset_type'

module Lotus
  module Assets
    class UnknownAssetType < ::StandardError
      def initialize(type)
        super("Unknown asset type: `#{ type }'")
      end
    end

    class Configuration
      PATH_SEPARATOR = '/'.freeze
      ASSET_TYPES    = ->{Hash.new{|h,k| h[k] = Config::AssetType.new }.merge!({
        javascript: Config::AssetType.new {
          tag    %(<script src="%s" type="text/javascript"></script>)
          source %(/%s.js)
        },
        stylesheet: Config::AssetType.new {
          tag    %(<link href="%s" type="text/css" rel="stylesheet">)
          source %(/%s.css)
        }
      })}.freeze

      def initialize
        reset!
      end

      def prefix(value = nil)
        if value.nil?
          @prefix
        else
          @prefix = value
        end
      end

      def define(type, &blk)
        @types[type].define(&blk)
      end

      def reset!
        @types  = ASSET_TYPES.call
        @prefix = nil
      end

      # @api private
      def asset(type)
        @types.fetch(type) { raise UnknownAssetType.new(type) }
      end
    end
  end
end
