require File.dirname(__FILE__) + '/../spec_helper'

describe ActiveAdmin::ResourceController do
  
  [:index, :show].each do |page|
    describe "#{page} config" do
      before do
        Admin::PostsController.send(:"reset_#{page}_config!")
      end

      it "should be set" do
        Admin::PostsController.send(page)
        Admin::PostsController.send(:"#{page}_config").should be_an_instance_of(ActiveAdmin::PageConfig)
      end

      it "should store the block" do
        block = Proc.new {}
        Admin::PostsController.send(:"#{page}", &block)
        Admin::PostsController.send(:"#{page}_config").block.should == block
      end

      it "should be reset" do
        Admin::PostsController.send(:"reset_#{page}_config!")
        Admin::PostsController.send(:"#{page}_config").should == nil
      end
    end
  end

  describe "setting the current tab" do
    let(:controller) { ActiveAdmin::ResourceController.new }
    before do 
      controller.stub!(:active_admin_config => resource)
      controller.send :set_current_tab # Run the before filter
    end
    subject{ controller.instance_variable_get(:@current_tab) }

    context "when menu item name is 'Resources' without a parent menu item" do
      let(:resource){ mock(:menu_item_name => "Resources", :parent_menu_item_name => nil) }
      it { should == "Resources" }
    end

    context "when there is a parent menu item of 'Admin'" do
      let(:resource){ mock(:parent_menu_item_name => "Admin") }
      it { should == "Admin" }
    end
  end
  
  describe "setting whether to use admin notes" do
    let(:controller) { Admin::PostsController }
    
    it "should set the admin notes on active admin config" do
      controller.active_admin_config.admin_notes = false
      controller.admin_notes true
      controller.active_admin_config.admin_notes?.should be_true
    end
    
    
  end

end
