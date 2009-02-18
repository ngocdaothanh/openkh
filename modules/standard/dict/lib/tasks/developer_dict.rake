namespace :developer do
  namespace :dict do
    desc "Download EDICT's Japanese-English dictionary to tmp"
    task :ja_en do
      require 'cmd'; include Cmd # to use methods: run, create_dir_if_not_exists
      tmp_dir = "#{RAILS_ROOT}/tmp"
      create_dir_if_not_exists(tmp_dir)
      run "cd #{tmp_dir} && wget http://ftp.monash.edu.au/pub/nihongo/edict.gz && gunzip edict.gz && iconv -f euc-jp -t utf8 edict > edict.utf8 && rm edict"
    end
  end
end
