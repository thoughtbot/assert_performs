require 'test/unit'
require 'rubygems'
require 'shoulda'
require 'erb'
require 'active_support'
require 'active_support/core_ext'

$: << File.join(File.dirname(__FILE__), '..', 'lib')
require 'assert_performs'

class AssertPerformsTest < Test::Unit::TestCase
  
  def setup
    @command = 'NO COMMAND WAS RUN'
  end

  def `(command)
    @command = command
    @output
  end

  context "when setting the performance server" do
    setup do
      @old_value = Test::Unit::TestCase.performance_server
      @new_value = 'test.local'
      Test::Unit::TestCase.performance_server = @new_value
    end

    teardown do
      Test::Unit::TestCase.performance_server = @old_value
    end

    should "return the new value" do
      assert_equal @new_value, Test::Unit::TestCase.performance_server
    end
  end

  context "when asserting with valid arguments" do
    setup do
      @old_performance_server = Test::Unit::TestCase.performance_server
      Test::Unit::TestCase.performance_server = 'test.local'

      @request_rate = 100
      @errors       = 0
      @output       = httperf_output
      assert_performs :get, '/whatever', :rate => 2, :timeout => 2, :id => 1
    end

    teardown do
      Test::Unit::TestCase.performance_server = @old_performance_server
    end

    should "Use the correct performance server in the generated command" do
      assert_match /--server=test\.local/, @command
    end

    should "use the specified HTTP method in the generated command" do
      assert_match /--method=GET/, @command
    end

    should "use the specified URI in the generated command" do
      assert_match /--uri='\/whatever?[^']*'/, @command
    end

    should "append parameters to the URI in the generated command" do
      assert_match /\?id=1/, @command
    end

    should "use the specified timeout in the generated command" do
      assert_match /--timeout=2/, @command
    end

    should "use the correct number of connections in the generated command" do
      assert_match /--num-conns=3/, @command
    end
  end

  context "when a request causes an error" do
    setup do
      @request_rate = 100
      @errors       = 1
      @output       = httperf_output
    end

    should "fail" do
      assert_raise(Test::Unit::AssertionFailedError) do
        assert_performs :get, '/', :rate => @request_rate - 1, :timeout => 2
      end
    end
  end

  context "with an unacceptable request rate and no errors" do
    setup do
      @request_rate = 0
      @errors       = 0
      @output       = httperf_output
    end

    should "fail" do
      assert_raise(Test::Unit::AssertionFailedError) do
        assert_performs :get, '/', :rate => @request_rate + 1, :timeout => 2
      end
    end
  end

  context "with an acceptable request rate and no errors" do
    setup do
      @request_rate = 100
      @errors       = 0
      @output       = httperf_output
    end

    should "pass" do
      assert_nothing_raised do
        assert_performs :get, '/', :rate => @request_rate - 1, :timeout => 2
      end
    end
  end

  def httperf_output
    output_file = File.join(File.dirname(__FILE__), 'httperf_output.erb')
    template    = File.read(output_file)
    ERB.new(template).result(binding)
  end
end
