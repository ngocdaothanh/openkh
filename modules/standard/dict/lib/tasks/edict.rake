namespace :edict do
  desc "Download EDICT's Japanese-English dictionary to tmp"
  task :ja_en do
    `cd #{RAILS_ROOT}/tmp && wget http://ftp.monash.edu.au/pub/nihongo/edict.gz && gunzip edict.gz && iconv -f euc-jp -t utf8 edict > edict.utf8 && rm edict`
  end
end
