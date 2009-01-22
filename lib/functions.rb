module Functions
  # Method to call external commands
  def external_command(command, output = false)
    if output
      `#{command}`
    else
      system(command)
    end
  end
end
