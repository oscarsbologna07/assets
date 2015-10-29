require 'test_helper'

describe 'Digest mode' do
  before do
    dest.rmtree if dest.exist?
    dest.mkpath

    load __dir__ + '/../fixtures/bookshelf/config/environment.rb'
    Lotus::Assets.deploy

    frameworks = [Web::Assets, Admin::Assets]
    frameworks.each do |framework|
      framework.configure do
        digest true
      end.load!
    end
  end

  let(:dest) { TMP.join('bookshelf', 'public') }

  it "uses digest relative urls" do
    rendered = Web::Views::Books::Show.render(format: :html)
    rendered.must_match %(<script src="/assets/jquery-05277a4edea56b7f82a4c1442159e183.js" type="text/javascript"></script>)
    rendered.must_match %(<script src="/assets/application-d1829dc353b734e3adc24855693b70f9.js" type="text/javascript"></script>)
  end
end
