# Please edit if neccessary
CONF = {
  :nuke_adapter      => 'DBI:Mysql',
  :nuke_db           => 'vcsj',
  :nuke_table_prefix => 'vcsj_',
  :nuke_username     => 'root',
  :nuke_password     => '12345678',

  :openkh_adapter  => 'DBI:Pg',
  :openkh_db       => 'openkh',
  :openkh_username => 'openkh',
  :openkh_password => 'openkh'
}

require 'rubygems'
require 'dbi'
require 'DBD/Pg'     # Or DBD/Pg/Pg on some system
require 'DBD/Mysql'
require 'bbcodeizer'

#-------------------------------------------------------------------------------

# Stories of phpNuke
def convert_stories(nuke, openkh)
  nuke.select_all("select * from #{CONF[:nuke_table_prefix]}stories") do |story|
    openkh.do('insert into articles(open, updated_at, views, name, abstract, details, user_id, ip, created_at, version) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
      1, story[:time], story[:counter], story[:title], story[:hometext], story[:bodytext], 2, '127.0.0.1', story[:time], 1)

    openkh.select_all('select * from articles where name like ?', story[:title]) do |article|
      openkh.do('insert into article_versions(article_id, version, name, abstract, details, user_id, ip, created_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?)',
        article[:id], 1, article[:name], article[:abstract], article[:details], article[:user_id], article[:ip], article[:created_at])
      break
    end
  end
end

#-------------------------------------------------------------------------------

def main
  nuke  = DBI.connect("#{CONF[:nuke_adapter]}:#{CONF[:nuke_db]}", CONF[:nuke_username], CONF[:nuke_password])
  openkh = DBI.connect("#{CONF[:openkh_adapter]}:#{CONF[:openkh_db]}", CONF[:openkh_username], CONF[:openkh_password])

  convert_stories(nuke, openkh)

  nuke.disconnect
  openkh.disconnect
end
main
