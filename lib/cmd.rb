module Cmd
  def create_dir_if_not_exists(dir)
    return if dir.blank?
    dir = dir.to_s # accept symbol

    unless File.directory?(dir)
      puts "Create #{dir}"
      FileUtils.mkdir_p(dir)
    end
  end

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
