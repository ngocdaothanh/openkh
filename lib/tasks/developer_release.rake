namespace :developer do
  desc 'Create release package'
  task :release do
    release_path = File.join(File.dirname(RAILS_ROOT), 'release')
    FileUtils.mkdir(release_path) unless File.directory?(release_path)
    base_name = 'openkh'
    target = File.join(release_path, base_name)

    sync_cmd = "rsync -avz --delete-excluded --exclude=.git* --exclude-from=.gitignore . #{target}"
    zip_cmd = "cd #{release_path} && rm -f #{base_name}.zip && zip -ry #{base_name}.zip #{base_name}" # option -y will preserve symlinks

    require 'cmd'; include Cmd # to use method run
    if run(sync_cmd) && run(zip_cmd)
      puts "Release package created successfully at: #{target}.zip"
    else
      puts "Failed to create package"
    end
  end
end
