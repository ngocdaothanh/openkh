module Functions
  # Method to call external commands
  def external_command(command, output = false)
    if output
      `#{command}`
    else
      command << " > /dev/null" if command
      system(command)
    end
  end
end
