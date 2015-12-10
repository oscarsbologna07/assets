require 'test_helper'

describe Lotus::Assets::Configuration do
  before do
    @configuration = Lotus::Assets::Configuration.new
  end

  after do
    @configuration.reset!
  end

  describe '#sources' do
    it "is empty by default" do
      @configuration.sources.must_be_empty
    end

    it "allows to add paths" do
      @configuration.sources << __dir__

      assert @configuration.sources == [__dir__],
        "Expected @configuration.sources to eq [#{ __dir__ }], got #{ @configuration.sources.inspect }"
    end

    it "removes duplicates and nil sources" do
      @configuration.sources << __dir__
      @configuration.sources << __dir__
      @configuration.sources << nil

      assert @configuration.sources == [__dir__],
        "Expected @configuration.sources to eq [#{ __dir__ }], got #{ @configuration.sources.inspect }"
    end
  end

  describe '#prefix' do
    it 'returns "/assets" value default' do
      @configuration.prefix.must_be_kind_of(Lotus::Utils::PathPrefix)
      @configuration.prefix.must_equal "/assets"
    end

    it 'allows to set a value' do
      @configuration.prefix            'application-prefix'
      @configuration.prefix.must_equal 'application-prefix'
    end
  end

  describe '#destination' do
    it 'defaults to "public/" on current directory' do
      expected = Pathname.new(Dir.pwd + '/public')
      @configuration.destination.must_equal(expected)
    end

    it 'allows to set a custom location' do
      dest = __dir__ + '/../tmp'
      @configuration.destination(dest)
      @configuration.destination.must_equal(Pathname.new(File.expand_path(dest)))
    end
  end

  describe '#manifest' do
    it 'defaults to "assets.json"' do
      @configuration.manifest.must_equal 'assets.json'
    end

    it 'allows to set a relative path' do
      @configuration.manifest            'manifest.json'
      @configuration.manifest.must_equal 'manifest.json'
    end
  end

  describe '#manifest_path' do
    it 'joins #manifest with #destination' do
      expected = @configuration.destination.join(@configuration.manifest)
      @configuration.manifest_path.must_equal expected
    end

    it 'returns absolute path, if #manifest is absolute path' do
      @configuration.manifest expected = __dir__ + '/manifest.json'
      @configuration.manifest_path.must_equal Pathname.new(expected)
    end
  end

  describe '#asset' do
    it 'returns an asset definition' do
      asset_type = @configuration.asset(:javascript)
      asset_type.must_be_kind_of(Lotus::Assets::Config::AssetType)
      asset_type.ext.must_equal '.js'
    end

    it 'returns anonymous asset type' do
      asset_type = @configuration.asset('logo.png')
      asset_type.must_be_kind_of(Lotus::Assets::Config::AssetType)
      asset_type.ext.must_equal '.png'
    end
  end

  describe '#reset!' do
    before do
      @configuration.prefix 'prfx'
      @configuration.manifest 'assets.json'
      @configuration.destination(Dir.pwd + '/tmp')

      @configuration.reset!
    end

    it 'sets default value for destination' do
      @configuration.destination.must_equal(Pathname.new(Dir.pwd + '/public'))
    end

    it 'sets default value for prefix' do
      @configuration.prefix.must_be_kind_of(Lotus::Utils::PathPrefix)
      @configuration.prefix.must_equal '/assets'
    end

    it 'sets default value for manifest' do
      @configuration.manifest.must_equal('assets.json')
    end

    it 'removes custom defined asset types' do
      asset_type = @configuration.asset(:cuztom)
      asset_type.must_be_kind_of(Lotus::Assets::Config::AssetType)
      asset_type.ext.must_equal ""
    end

    it 'sets default value for predefined asset type' do
      asset = @configuration.asset(:stylesheet)
      asset.tag.must_equal    %(<link href="%s" type="text/css" rel="stylesheet">)
      asset.ext.must_equal    %(.css)
      asset.prefix.must_equal %(/assets)
    end
  end

  describe '#duplicate' do
    before do
      @configuration.reset!
      @configuration.compile     true
      @configuration.prefix      '/foo'
      @configuration.manifest    'm.json'
      @configuration.root        __dir__
      @configuration.destination __dir__
      @configuration.sources << __dir__ + '/fixtures/javascripts'

      @config = @configuration.duplicate
    end

    it 'returns a copy of the configuration' do
      @config.compile.must_equal      true
      @config.prefix.must_equal      '/foo'
      @config.manifest.must_equal    'm.json'
      @config.root.must_equal        Pathname.new(__dir__)
      @config.destination.must_equal Pathname.new(__dir__)
      assert @config.sources == [__dir__ + '/fixtures/javascripts'],
        "Expected #{ @config.sources } to eq [#{ __dir__ }/fixtures/javascripts'], found: #{ @config.sources.inspect }"
    end

    it "doesn't affect the original configuration" do
      @config.compile     false
      @config.prefix      '/bar'
      @config.manifest    'a.json'
      @config.root        __dir__ + '/fixtures'
      @config.destination __dir__ + '/fixtures'
      @config.sources <<  __dir__ + '/fixtures/stylesheets'

      @config.compile.must_equal      false
      @config.prefix.must_equal      '/bar'
      @config.manifest.must_equal    'a.json'
      @config.root.must_equal        Pathname.new(__dir__ + '/fixtures')
      @config.destination.must_equal Pathname.new(__dir__ + '/fixtures')
      assert @config.sources == [__dir__ + '/fixtures/javascripts', __dir__ + '/fixtures/stylesheets'],
        "Expected @config.sources to eq [#{ __dir__ }/fixtures/javascripts', #{ __dir__ }/fixtures/stylesheets'], found: #{ @config.sources.inspect }"

      @configuration.compile.must_equal      true
      @configuration.prefix.must_equal      '/foo'
      @configuration.manifest.must_equal    'm.json'
      @configuration.root.must_equal        Pathname.new(__dir__)
      @configuration.destination.must_equal Pathname.new(__dir__)
      assert @configuration.sources == [__dir__ + '/fixtures/javascripts'],
        "Expected @config.sources to eq [#{ __dir__ }/fixtures/javascripts'], found: #{ @config.sources.inspect }"
    end
  end
end
