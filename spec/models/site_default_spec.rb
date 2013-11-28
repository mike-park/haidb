require 'spec_helper'

describe SiteDefault do
  let(:sd) { SiteDefault.create!(description: 'desc',
                                 translation_key_attributes: {
                                     key: 'a_key',
                                     translations_attributes: [
                                         {locale: 'en', text: 'english'},
                                         {locale: 'de', text: 'deutsch'}
                                     ]}) }

  before do
    sd
  end
  after do
    SiteDefault.destroy_all
  end

  it "should update translation" do
    I18n.locale = :en
    I18n.translate('a_key').should == 'english'
    sd.translation_key.translations[0].update_attributes(text: 'changed')
    sd.save
    I18n.translate('a_key').should == 'changed'
  end

  context "get" do
    it "should return key value" do
      I18n.locale = :en
      SiteDefault.get('a_key').should == 'english'
      I18n.locale = :de
      SiteDefault.get('a_key').should == 'deutsch'
    end

    it "should return empty values" do
      SiteDefault.create!(description: 'desc',
                          translation_key_attributes: {
                              key: 'empty_key',
                              translations_attributes: [
                                  {locale: 'en', text: ''},
                                  {locale: 'de', text: nil}
                              ]})
      I18n.locale = :en
      SiteDefault.get('empty_key').should == ''
      I18n.locale = :de
      SiteDefault.get('empty_key').should_not be
    end

    it "should return nil for missing keys" do
      SiteDefault.get('a.missing.key').should_not be
    end
  end
end