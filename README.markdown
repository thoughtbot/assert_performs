# Assert Performs

This is a single Test::Unit assertion written to test performance of 
a Rails action. Meant to be run on staging before production deploys.

## Usage

    class PerformanceTest < Test::Unit::TestCase
      self.performance_server = "staging.example.com"
      context "a GET to users/1" do
        should "be performant" do
          assert_performs :get, user_path, :rate        => 3,
                                           :timeout     => 5
                                           :id          => 1  # extra params
        end
      end
    end

assert_performs takes the following arguments:

* an HTTP verb
* a path
* a threshold request rate (req/s)
* a timeout (in seconds)

    assert_performs :get, '/', :rate => 3, :timeout => 5

## Requirements

* httperf
* web server

