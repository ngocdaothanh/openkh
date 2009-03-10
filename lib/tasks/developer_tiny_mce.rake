namespace :developer do
  namespace :tiny_mce do
    desc 'Download and install latest tiny_mce for openkh'
    task :download do
      def extract_link_and_download(doc)
        doc.search("/html/body//a").each do |a|
          href = a.attributes['href']
          if /prdownloads\.sourceforge\.net/ =~ href
            download_cmd = "cd /tmp && rm -rf tinymce* && mkdir tinymce && cd tinymce && wget #{href}"
            # We return here because we only want the first match (which links to latest tiny_mce)
            return run(download_cmd, :desc => 'Download tiny_mce')
          end
        end
      end

      def unzip
        unzip_cmd = "cd /tmp/tinymce && unzip tinymce_*.zip"
        run(unzip_cmd, :desc => 'Unzip downloaded file')
      end

      def copy_to_public
        copy_cmd = "/bin/cp -rf /tmp/tinymce/jscripts/tiny_mce public/javascripts/"
        run(copy_cmd, :desc => 'Copy tiny_mce to openkh')
      end

      require 'hpricot'
      require 'open-uri'
      require 'cmd'; include Cmd # to use method: run

      url = "http://tinymce.moxiecode.com/download.php"

      if extract_link_and_download(Hpricot(open(url))) && unzip && copy_to_public
        puts "Tiny_mce downloaded and installed successfully"
        puts "You may want to delete temp files created in /tmp directory"
      else
        puts "Could not install tiny_mce"
        puts "Make sure wget, unzip commands and hpricot, open-uri gems are installed"
      end
    end

    desc 'Copy things in tiny_mce_additionals directory to tiny_mce directory'
    task :add do
      # Install plugin "insertcode"
      FileUtils.cp_r 'public/javascripts/tiny_mce_additionals/plugins/insertcode', 'public/javascripts/tiny_mce/plugins'
      FileUtils.rm_rf Dir.glob('public/javascripts/tiny_mce/plugins/insertcode/**/.svn')

      # Install Vietnamese language pack
      FileUtils.cp 'public/javascripts/tiny_mce_additionals/langs/vi/langs/vi.js', 'public/javascripts/tiny_mce/langs/'
      FileUtils.cp 'public/javascripts/tiny_mce_additionals/langs/vi/themes/advanced/langs/vi.js', 'public/javascripts/tiny_mce/themes/advanced/langs'
      FileUtils.cp 'public/javascripts/tiny_mce_additionals/langs/vi/themes/advanced/langs/vi_dlg.js', 'public/javascripts/tiny_mce/themes/advanced/langs'
      puts "tiny_mce_additionals added successfully"
    end
  end
end
