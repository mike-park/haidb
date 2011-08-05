require 'spec_helper'

describe "YAML" do
  it "should parse" do
    y = YAML.load_file(File.expand_path("../../../config/locales/de.yml", __FILE__))
    y["de"]["time"]["formats"]["time"].should == "%H:%M"
  end
end
