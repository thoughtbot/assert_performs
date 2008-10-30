class Test::Unit::TestCase

  # httperf --server jobs.local 
  #         --method=GET 
  #         --uri="/naturejobs/science" 
  #         --timeout 1 
  #         --num-conns=10

  cattr_accessor :performance_server

  # Example:
  #   assert_performs :get, user_path, :rate        => 2,
  #                                    :timeout     => 5
  #                                    :id          => 1  # extra params
  def assert_performs(method, uri, params = {})
    timeout = params.delete(:timeout)
    rate    = params.delete(:rate)

    query = "?#{params.to_query}"

    args = []
    args << "--server=#{Test::Unit::TestCase.performance_server}"
    args << "--method=#{method.to_s.upcase}"
    args << "--uri='#{uri}#{query}'"
    args << "--timeout=#{timeout}"
    args << "--num-conns=3"

    command = "httperf #{args.join(' ')}"
    output = `#{command}`
    result = parse_httperf_output(output)

    assert_equal 0, result[:errors],
                 "One or more connections failed or timed out"
    assert result[:rate] >= rate,
           "Expected at least #{rate} req/s, but got #{result[:rate]}"
  end

  def parse_httperf_output(output)
    result = {}
    
    match = output.match(%r{Request rate: ([\d.]+) req/s})
    result[:rate] = match[1].to_f

    match = output.match(%r{Errors: total ([\d]+)})
    result[:errors] = match[1].to_i

    result
  end

end
