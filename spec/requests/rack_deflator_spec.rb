require 'spec_helper'

describe Rack::Deflater do
  it "produces an identical eTag whether content is deflated or not" do
    get "/"
    response.headers["Content-Encoding"].should be_nil
    etag = response.headers["Etag"]
    content_length = response.headers["Content-Length"].to_i
    get "/", {}, { "HTTP_ACCEPT_ENCODING" => "gzip" }
    response.headers["Etag"].should == etag
    response.headers["Content-Length"].to_i.should_not == content_length
    response.headers["Content-Encoding"].should == "gzip"
  end
end
