require 'rspec'
require 'spec_helper'


describe Sourceninja do

  describe "process_bundle_info" do

    it "should return an array of hashes" do
      Sourceninja.process_bundle_info.class.should == Array
      Sourceninja.process_bundle_info.all?(&Hash.method(:===)).should == true
      Sourceninja.process_bundle_info.each { |e|
        e.include?(:package_name).should == true
        e.include?(:package_version).should == true
        e.include?(:direct_requirement).should == true
      }
    end

    it "check for direct and our named indirect deps" do
      direct_gems = ["rspec", "sourceninja"]
      indirect_gems = ["httparty", "json"]

      direct_gems.each do |d|
        bundle_info = Sourceninja.process_bundle_info
        rcov_result = bundle_info.select { |e| e[:package_name] == d }
        rcov_result.count.should == 1
        rcov_result.first[:package_name].should == d
        rcov_result.first[:direct_requirement].should == true
      end

      indirect_gems.each do |d|
        bundle_info = Sourceninja.process_bundle_info
        rcov_result = bundle_info.select { |e| e[:package_name] == d }
        rcov_result.count.should == 1
        rcov_result.first[:package_name].should == d
        rcov_result.first[:direct_requirement].should == false
      end
    end
  end

  it "make sure the list of hashes is being submitted to SN" do
    data = [{:package_name => "bundler", :package_version => "1.1.3", :direct_requirement => false},
            {:package_name => "sourceninja", :package_version => "0.0.8", :direct_requirement => true}]

    response = mock(HTTParty::Response)
    response.stub!(:code).and_return(200)
    HTTParty.stub(:post).with("https://app.sourceninja.com/rubygems/1_0",
                              {:body => { :id => "product_id",
                                  :token => "token",
                                  :package_info => { :package_details => data }.to_json }}).and_return(response)

    Sourceninja.send_package_info(data,
                                  :token => "token",
                                  :product_id => "product_id").should == true
  end

  it "make sure invalid URLs don't crash the app" do
    data = [{:package_name => "bundler", :package_version => "1.1.3", :direct_requirement => false},
            {:package_name => "sourceninja", :package_version => "0.0.8", :direct_requirement => true}]

    Sourceninja.send_package_info(data,
                                  :url => "blargl",
                                  :token => "token",
                                  :product_id => "product_id").should == false
  end

end
