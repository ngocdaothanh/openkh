module Cmd
  # Run external command and return the result
  def run(command, options = {:desc => '', :get_output_string => false})
    puts options[:desc]
    puts "Executing: #{command}"

    if options[:get_output_string]
      result = `#{command}`
    else
      command << " > /dev/null" if command # Not show output details to stdout
      result = system(command)
    end

    report(result)
  end

  private

  def report(result)
    if result
      puts "[OK]"
    else
      puts "[FAILED]"
    end
    result
  end
end
