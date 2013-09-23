require 'spec_helper'

describe SiteDefault do
  it "should update translation" do
    sd = SiteDefault.create!(description: 'desc', translation_key_attributes: { key: 'a_key', translations_attributes: [{locale: 'en', text: 'english'}]})
    I18n.translate('a_key').should == 'english'
    sd.translation_key.translations[0].update_attributes(text: 'changed')
    sd.save
    I18n.translate('a_key').should == 'changed'
  end
end