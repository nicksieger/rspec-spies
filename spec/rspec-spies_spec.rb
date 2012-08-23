require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "[object.should] have_received(method, *args)" do

  before do
    @object = String.new("HI!")
    @object.stub!(:slice)
  end

  it "does match if method is called with correct args" do
    @object.slice(5)

    have_received(:slice).with(5).matches?(@object).should be_true
  end

  it "does not match if method is called with incorrect args" do
    @object.slice(3)

    have_received(:slice).with(5).matches?(@object).should be_false
  end

  it "does not match if method is not called" do
    have_received(:slice).with(5).matches?(@object).should be_false
  end

  it "correctly lists expects arguments for should" do
    matcher  = have_received(:slice).with(5, 3)
    matcher.matches?(@object).should be_false
    message = matcher.failure_message_for_should
    message.should =~ /\(HI!\).slice\(5, 3\).*expected: 1 time.*received: 0 times/m
  end

  it "correctly lists expects arguments for should_not" do
    @object.slice(1,2)

    matcher  = have_received(:slice).with(1, 2)
    matcher.matches?(@object).should be_true
    message = matcher.failure_message_for_should_not
    message.should =~ /\(HI!\).slice\(1, 2\).*unexpected match/m
  end

  it "allows omitting argument matchers" do
    @object.slice(5)

    have_received(:slice).matches?(@object).should be_true
  end


  it "allows specifying counts" do
    @object.slice(5)

    have_received(:slice).at_least(:twice).matches?(@object).should be_false
  end

  it "allows using args matchers" do
    m = double.as_null_object
    m.validate = true

    have_received(:validate=).with(boolean).matches?(m).should be_true
  end

end


