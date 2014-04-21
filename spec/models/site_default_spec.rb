require 'spec_helper'

describe SiteDefault do
  before do
    SiteDefault.create!(description: 'desc',
                        translation_key_attributes: {
                            key: 'a_key',
                            translations_attributes: [
                                {locale: 'en', text: 'english'},
                                {locale: 'de', text: 'deutsch'}
                            ]})
  end

  context "get" do
    it "should return en value" do
      I18n.locale = :en
      SiteDefault.get('a_key').should == 'english'
    end

    it "should return de value" do
      I18n.locale = :de
      SiteDefault.get('a_key').should == 'deutsch'
    end

    it "should return nil values" do
      TranslationText.update_all(text: nil)
      expect(SiteDefault.get('a_key')).to be_nil
    end

    it "should return blank values" do
      TranslationText.update_all(text: '')
      expect(SiteDefault.get('a_key')).to eq('')
    end

    it "should return nil for missing keys" do
      expect(SiteDefault.get('a.missing.key')).to be_nil
    end

    it "should return html unchanged" do
      TranslationText.update_all(text: '<h1>Title</h1>')
      expect(SiteDefault.get('a_key')).to eq('<h1>Title</h1>')
    end
  end
end