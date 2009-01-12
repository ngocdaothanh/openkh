# After running this program, please set sequence of PostgreSQL properly.

# Please edit if neccessary
CONF = {
  :phpbb_adapter      => 'DBI:Mysql',
  :phpbb_db           => 'vcsj',
  :phpbb_table_prefix => 'vcsj_',
  :phpbb_username     => 'root',
  :phpbb_password     => '12345678',

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

RAILS_ROOT = "#{File.dirname(__FILE__)}/.."

def username_to_openid(username)
  username
end

def convert_site(phpbb, openkh)
  openkh.do('delete from site')

  openkh.do('insert into site(template) VALUES (?)',
    File.read("#{RAILS_ROOT}/app/views/layouts/sample_site.html.haml"))
end

def convert_users(phpbb, openkh)
  openkh.do('delete from users')

  phpbb.select_all("select * from #{CONF[:phpbb_table_prefix]}users") do |user|
    openkh.do('insert into users(id, openid, email, password) VALUES (?, ?, ?, ?)',
      user[:user_id], username_to_openid(user[:username]), user[:user_email], user[:user_password])
  end
end

def convert_boxes(phpbb, openkh)
  openkh.do('delete from boxes')

  template = File.read("#{RAILS_ROOT}/app/views/layouts/sample_box.html.haml")
  phpbb.select_all("select * from #{CONF[:phpbb_table_prefix]}bbforums") do |forum|
    begin
      openkh.do('insert into boxes(id, name, path, position, template) VALUES (?, ?, ?, ?, ?)',
        forum[:forum_id], forum[:forum_name], forum[:forum_name], forum[:forum_id], template)
    rescue
    end
  end
end

def convert_articles_and_related(phpbb, openkh)
  openkh.do('delete from articles')
  openkh.do('delete from article_versions')
  openkh.do('delete from articles_boxes')
  openkh.do('delete from comments')

  article_index = 1

  phpbb.select_all("select * from #{CONF[:phpbb_table_prefix]}bbtopics") do |topic|
    begin  # Skip on UTF8 error
      first_post = true  # The first post is the article abstract
      phpbb.select_all("select * from #{CONF[:phpbb_table_prefix]}bbposts where topic_id = #{topic[:topic_id]} order by post_time") do |post|
        phpbb.select_all("select * from #{CONF[:phpbb_table_prefix]}bbposts_text where post_id = #{post[:post_id]}") do |text|
          msg = BBCodeizer.bbcodeize(text[:post_text])
          if first_post
            first_post = false

            openkh.do('insert into articles(id, open, updated_at, views, name, tags, abstract, details, user_id, ip, created_at, version) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
              topic[:topic_id], 1, Time.at(topic[:topic_time]), topic[:topic_views], topic[:topic_title], nil, msg, nil, topic[:topic_poster], '127.0.0.1', Time.at(topic[:topic_time]), 1)

            openkh.do('insert into article_versions(article_id, version, name, tags, abstract, details, user_id, ip, created_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)',
              topic[:topic_id], 1, topic[:topic_title], nil, msg, nil, topic[:topic_poster], '127.0.0.1', Time.at(topic[:topic_time]))

            openkh.do('insert into articles_boxes(article_id, box_id) VALUES(?, ?)',
              topic[:topic_id], topic[:forum_id])
          else
            openkh.do('insert into comments(model_index, model_id, message, user_id, ip, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?)',
              article_index, post[:topic_id], msg, post[:poster_id], post[:poster_ip], Time.at(post[:post_time]), Time.at(post[:post_edit_time] || post[:post_time]))
          end
        end
      end
    rescue
      puts $!
    end
  end
end

#-------------------------------------------------------------------------------

def main
  phpbb  = DBI.connect("#{CONF[:phpbb_adapter]}:#{CONF[:phpbb_db]}", CONF[:phpbb_username], CONF[:phpbb_password])
  openkh = DBI.connect("#{CONF[:openkh_adapter]}:#{CONF[:openkh_db]}", CONF[:openkh_username], CONF[:openkh_password])

  convert_site(phpbb, openkh)
  convert_users(phpbb, openkh)
  convert_boxes(phpbb, openkh)
  convert_articles_and_related(phpbb, openkh)

  phpbb.disconnect
  openkh.disconnect
end
main
