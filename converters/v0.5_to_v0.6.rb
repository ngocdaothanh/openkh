# You need to edit this program, please read the comments in this short source
# code! This program uses DBI with PostgreSQL driver. You need to edit this
# source code if you use other drivers.
#
# * Remember to create the DB with the new schema for the new version
#   (rake db:migrate) before running this program.
# * Use DBI 0.1.1 if newer versions of DBI cause errors.

# Edit if neccessary
CONF = {
  :adapter  => 'DBI:Pg',
  :username => 'postgres',
  :password => 'openkh',
  :v0_4_9_9 => 'openkh_trunk',
  :v0_5     => 'openkh'
}

require 'rubygems'
require 'yaml'
require 'dbi'
require 'DBD/Pg/Pg'  # DBD/Pg on some system

#-------------------------------------------------------------------------------
# Helpers to play with PostgreSQL sequences.

def currval(seq)
  $new.select_one("SELECT CASE WHEN is_called THEN last_value ELSE last_value-increment_by END from #{seq}")[0]
end

def setval(seq, val)
  $new.select_one("SELECT setval('#{seq}', #{val}, true)")
end

#-------------------------------------------------------------------------------

def convert_users
  last_user_id = nil
  $old.select_all('SELECT * FROM users ORDER BY id') do |user|
    $new.do('INSERT INTO users(id, openid, email) VALUES (?, ?, ?)',
      user[:id], user[:openid], user[:email])
    last_user_id = user[:id]
  end
  setval('users_id_seq', last_user_id)
end

def convert_boxes
  last_box_id = nil
  $old.select_all('SELECT * FROM boxes') do |b|
    $url_conversion_table["/boxes/#{b[:id]}"] = "/categories/#{b[:id]}"
    $new.do('INSERT INTO categories(id, name, path, position) VALUES (?, ?, ?, ?)',
      b[:id], b[:name], b[:path], b[:position])
    last_box_id = b[:id]
  end
  setval('categories_id_seq', last_box_id)
end

def convert_tocs
  last_toc_id = nil
  $old.select_all('SELECT * FROM tocs ORDER BY id') do |t|
    vts = []
    # vt looks like a hash but it is not
    $old.select_all('SELECT * FROM toc_versions WHERE toc_id = ? ORDER BY id', t[:id]) do |vt|
      vts << {:toc_id => vt[:toc_id], :version => vt[:version], :contents => vt[:contents], :user_id => vt[:user_id], :ip => vt[:ip], :created_at => vt[:created_at]}
    end

    # Use the last version of a serie created by one user
    vts[0][:version] = 1
    active_version = (t[:version] <= vts.size)? t[:version] : vts.size
    last_vtoc_created_at = nil
    vts.each_with_index do |vt, i|
      if i < vts.size - 1
        if vt[:user_id] == vts[i + 1][:user_id]
          active_version -= 1 if active_version > vt[:version]
          vts[i + 1][:version] = vt[:version]
          next
        end
        vts[i + 1][:version] = vt[:version] + 1
      end
      $new.do('INSERT INTO node_versions(node_id, version, title, _body, user_id, ip, created_at) VALUES (?, ?, ?, ?, ?, ?, ?)',
        vt[:toc_id], vt[:version], 'Contents', vt[:contents], vt[:user_id], vt[:ip], vt[:created_at])
      last_vtoc_created_at = vt[:created_at]
    end

    $new.do('INSERT INTO nodes(id, open, tags, active_version, type, views, sticky, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?)',
      t[:id], true, nil, active_version, 'Toc', 1, (t[:model_name] == 'Site')? 0 : t[:model_id], last_vtoc_created_at)
    last_toc_id = t[:id]
  end
  setval('nodes_id_seq', last_toc_id)
end

def convert_articles
  $old.select_all('SELECT * FROM articles ORDER BY id') do |a|
    # Save first to get the node id, active version will be updated later
    $new.do('INSERT INTO nodes(open, tags, active_version, type, views, sticky, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?)',
      (a[:open] == 1)? true : false, a[:tags], a[:version], 'Article', a[:views], a[:sticky], a[:updated_at])

    node_id = currval('nodes_id_seq')
    $url_conversion_table["/articles/#{a[:id]}"] = "/nodes/show/#{node_id}"

    vas = []
    # va looks like a hash but it is not
    $old.select_all('SELECT * FROM article_versions WHERE article_id = ? ORDER BY id', a[:id]) do |va|
      vas << {:version => va[:version], :name => va[:name], :abstract => va[:abstract], :details => va[:details], :user_id => va[:user_id], :ip => va[:ip], :created_at => va[:created_at]}
    end

    # Use the last version of a serie created by one user
    vas[0][:version] = 1
    active_version = (a[:version] <= vas.size)? a[:version] : vas.size
    vas.each_with_index do |va, i|
      if i < vas.size - 1
        if va[:user_id] == vas[i + 1][:user_id]
          active_version -= 1 if active_version > va[:version]
          vas[i + 1][:version] = va[:version]
          next
        end
        vas[i + 1][:version] = va[:version] + 1
      end
      $new.do('INSERT INTO node_versions(node_id, version, title, _body, user_id, ip, created_at) VALUES (?, ?, ?, ?, ?, ?, ?)',
        node_id, va[:version], va[:name], [va[:abstract], va[:details]].to_yaml, va[:user_id], va[:ip], va[:created_at])
    end

    # Update active version
    $new.do('UPDATE nodes SET active_version = ? WHERE id = ?', active_version, node_id)
    active_version

    convert_comments('Article', a[:id], node_id)

    $old.select_all('SELECT * FROM articles_boxes WHERE article_id = ?', a[:id]) do |a_b|
      $new.do('INSERT INTO categories_nodes(category_id, node_id) VALUES(?, ?)', a_b[:box_id], node_id)
    end
  end
end

def convert_forums
  $old.select_all('SELECT * FROM forums ORDER BY id') do |f|
    $new.do('INSERT INTO nodes(open, tags, active_version, type, views, sticky, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?)',
      false, f[:tags], 1, 'Forum', f[:views], f[:sticky], f[:updated_at])

    node_id = currval('nodes_id_seq')
    $url_conversion_table["/forums/#{f[:id]}"] = "/nodes/show/#{node_id}"

    $new.do('INSERT INTO node_versions(node_id, version, title, _body, user_id, ip, created_at) VALUES (?, ?, ?, ?, ?, ?, ?)',
      node_id, 1, f[:name], nil, f[:user_id], f[:ip], f[:created_at])

    convert_comments('Forum', f[:id], node_id)

    $old.select_all('SELECT * FROM boxes_forums WHERE forum_id = ?', f[:id]) do |b_f|
      $new.do('INSERT INTO categories_nodes(category_id, node_id) VALUES(?, ?)', node_id, b_f[:box_id])
    end
  end
end

def convert_polls
  $old.select_all('SELECT * FROM polls ORDER BY id') do |p|
    $new.do('INSERT INTO nodes(open, tags, active_version, type, views, sticky, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?)',
      false, p[:tags], 1, 'Poll', 1, p[:sticky], p[:updated_at])

    node_id = currval('nodes_id_seq')
    $url_conversion_table["/polls/#{p[:id]}"] = "/nodes/show/#{node_id}"

    # Convert poll body
    responses = YAML.load(p[:options])
    votes     = p[:votes].split(',').map { |e| e.to_i }
    user_ids  = p[:voters].split(',').map { |e| e.to_i }

    $new.do('INSERT INTO node_versions(node_id, version, title, _body, user_id, ip, created_at) VALUES (?, ?, ?, ?, ?, ?, ?)',
      node_id, 1, p[:name], [responses, votes, user_ids].to_yaml, p[:user_id], p[:ip], p[:created_at])

    convert_comments('Poll', p[:id], node_id)

    $old.select_all('SELECT * FROM boxes_polls WHERE poll_id = ?', p[:id]) do |b_p|
      $new.do('INSERT INTO categories_nodes(category_id, node_id) VALUES(?, ?)', b_p[:box_id], node_id)
    end
  end
end

def convert_comments(model_name, model_id, node_id)
  $old.select_all('SELECT * FROM comments WHERE model_name = ? AND model_id = ? ORDER BY id', model_name, model_id) do |c|
    $new.do('INSERT INTO comments(node_id, message, user_id, ip, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?)',
      node_id, c[:message], c[:user_id], c[:ip], c[:created_at], c[:updated_at])
  end
end

def convert_urls
  $url_conversion_table.each do |k, v|
    puts "#{k} -> #{v}"
  end

  # id => body
  converted_conversion_table = {}
  $new.select_all('SELECT id, _body FROM node_versions') do |vn|
    body = vn[:_body]
    next if body.nil?

    converted = false
    $url_conversion_table.each do |k, v|
      converted = true if body.gsub!(%r{(http://cntt.tv|)#{k}"}, "#{v}\"") != nil
    end
    converted_conversion_table[vn[:id]] = body if converted
  end
  converted_conversion_table.each do |k, v|
    $new.do('UPDATE node_versions SET _body = ? WHERE id = ?', v, k)
  end

  # id => message
  converted_conversion_table = {}
  $new.select_all('SELECT id, message FROM comments') do |c|
    message = c[:message]

    converted = false
    $url_conversion_table.each do |k, v|
      converted = true if message.gsub!(%r{#{k}"}, "#{v}\"") != nil
    end
    converted_conversion_table[c[:id]] = message if converted
  end
  converted_conversion_table.each do |k, v|
    $new.do('UPDATE comments SET message = ? WHERE id = ?', v, k)
  end
end

#-------------------------------------------------------------------------------

# old => new
$url_conversion_table = {}

def main
  $old = DBI.connect("#{CONF[:adapter]}:#{CONF[:v0_4_9_9]}", CONF[:username], CONF[:password])
  $new = DBI.connect("#{CONF[:adapter]}:#{CONF[:v0_5]}", CONF[:username], CONF[:password])

  $new.do('DELETE FROM users');             setval('users_id_seq', 1)
  $new.do('DELETE FROM categories');        setval('categories_id_seq', 1)
  $new.do('DELETE FROM nodes');             setval('nodes_id_seq', 1)
  $new.do('DELETE FROM node_versions');     setval('node_versions_id_seq', 1)
  $new.do('DELETE FROM categories_nodes')
  $new.do('DELETE FROM comments');          setval('comments_id_seq', 1)

  convert_users
  convert_boxes
  convert_tocs
  convert_articles
  convert_forums
  convert_polls
  convert_urls

  $old.disconnect
  $new.disconnect
end
main
