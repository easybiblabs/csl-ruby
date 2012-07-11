require 'spec_helper'

module CSL
	
	describe Node do

    it { should_not be nil }
    it { should_not have_children }
    it { should_not have_attributes }
		
		describe 'given a FooBarNode with attributes :foo and :bar and a TestNode without defined attributes' do
      before(:all) do
        class FooBarNode < Node
          attr_struct :foo, :bar
        end
        class TestNode < Node
        end
      end
      
      it 'creates FooBarNode::Attributes' do
        FooBarNode.const_defined?(:Attributes).should be_true
      end
      
      it 'does not create TestNode::Attributes' do
        TestNode.const_defined?(:Attributes).should_not be_true
      end
		  
		  it 'TestNode attributes are a regular Hash' do
		    TestNode.new.attributes.should be_a(Hash)
		  end

		  it 'FooBarNode attributes are a Struct' do
		    FooBarNode.new.attributes.should be_a(Struct)
		  end
		  
  		describe '#values_at' do
  		  it 'FooBarNode accepts attribute names' do
  		    FooBarNode.new(:foo => 'Foo', :bar => 'Bar').values_at(:bar, :foo).should == %w{ Bar Foo }
  		  end
  		  
  		  it 'TestNode accepts attribute names' do
  		    TestNode.new(:foo => 'Foo', :bar => 'Bar').values_at(:bar, :foo).should == %w{ Bar Foo }
  		  end
      end
      
      describe '#to_a' do
        it 'returns an empty list by default' do
          Node.new.attributes.to_a.should == []
        end

        it 'TestNode returns an empty list by default' do
          TestNode.new.attributes.to_a.should == []
        end
        
        # it 'TestNode returns a list of all key/value pairs' do
        #   TestNode.new(:foo => 'Foo', :bar => 'Bar').attributes.to_a.map(&:last).sort.should == %w{ Bar Foo }
        # end

        # it 'FooBarNode returns an empty list by default' do
        #   FooBarNode.new.attributes.to_a.should == []
        # end
  		  
        # it 'FooBarNode returns a list of all key/value pairs' do
        #   FooBarNode.new(:foo => 'Foo', :bar => 'Bar').attributes.to_a.map(&:last).sort.should == %w{ Bar Foo }
        # end
      end
      
      describe 'attributes.keys' do
        it 'returns all attribute names as symbols' do
          TestNode.new.attributes.keys.should be_empty
          FooBarNode.new.attributes.keys.should == [:foo, :bar]
        end
      end
    end
	end

  describe TextNode do
    
    it { should_not be nil }
    it { should_not have_children }
    it { should_not have_attributes }
    
    describe '.new' do
      it 'accepts a hash of attributes' do
        TextNode.new(:foo => 'bar').should have_attributes
      end
      
      it 'yields itself to the optional block' do
        TextNode.new { |n| n.text = 'foo' }.text.should == 'foo'
      end
      
      it 'accepts hash and yields itself to the optional block' do
        TextNode.new(:foo => 'bar') { |n| n.text = 'foo' }.to_xml.should == '<text-node foo="bar">foo</text-node>'
      end
    end
    
    describe '#pretty_print' do
      TextNode.new(:foo => 'bar') { |n| n.text = 'foo' }.pretty_print.should == '<text-node foo="bar">foo</text-node>'
    end
  end
  
end