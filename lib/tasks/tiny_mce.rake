namespace :tiny_mce do
  desc 'Get latest version of tiny_mce for openkh'
  task :download do
    def report_ok
      puts "OK"
      true
    end

    def extract_link_and_download(doc)
      puts "Download begin..."
      doc.search("/html/body//a").each do |a|
        href = a.attributes['href']
        # first match give link to the latest main package
        if /prdownloads\.sourceforge\.net/ =~ href
          download_cmd = "cd /tmp && rm -f tinymce_*.zip && wget #{href}"
          return(external_command(download_cmd)) && report_ok
        end
      end
    end

    def unzip
      puts "Unzip begin..."
      unzip_cmd = "cd /tmp && rm -rf tinymce && unzip tinymce_*.zip"
      external_command(unzip_cmd) && report_ok
    end

    def copy_to_public
      puts "Copy begin..."
      copy_cmd = "/bin/cp -rf /tmp/tinymce/jscripts/tiny_mce public/javascripts/"
      external_command(copy_cmd) && report_ok
    end

    require 'hpricot'
    require 'open-uri'
    require 'functions'; include Functions # to use method external_command

    url = "http://tinymce.moxiecode.com/download.php"

    if extract_link_and_download(Hpricot(open(url))) && unzip && copy_to_public
      puts "Tiny_mce downloaded and installed successfully"
      puts "You may want to delete temp files created in /tmp directory"
    else
      puts "Could not install tiny_mce"
      puts "Make sure wget,unzip and gems hpricot,open-uri are installed"
    end
  end

  desc 'Add things in tiny_mce_additionals directory to tiny_mce directory'
  task :add do
    tiny_mce_path = 'public/javascripts/tiny_mce'

    # download and install tiny_mce if not exists
    unless File.directory?(tiny_mce_path) 
      # TODO make tiny_mce:download compatible with Windows
      Rake::Task['tiny_mce:download'].invoke
    end

    # insercode plugin
    FileUtils.cp_r 'public/javascripts/tiny_mce_additionals/plugins/insertcode', 'public/javascripts/tiny_mce/plugins'
    FileUtils.rm_rf Dir.glob('public/javascripts/tiny_mce/plugins/insertcode/**/.svn')

    # Vietnamese packs for TinyMCE
    FileUtils.cp 'public/javascripts/tiny_mce_additionals/langs/vi/langs/vi.js', 'public/javascripts/tiny_mce/langs/'
    FileUtils.cp 'public/javascripts/tiny_mce_additionals/langs/vi/themes/advanced/langs/vi.js', 'public/javascripts/tiny_mce/themes/advanced/langs'
    FileUtils.cp 'public/javascripts/tiny_mce_additionals/langs/vi/themes/advanced/langs/vi_dlg.js', 'public/javascripts/tiny_mce/themes/advanced/langs'
    puts "tiny_mce_additionals added successfully"
  end
end
