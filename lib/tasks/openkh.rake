namespace :openkh do
  desc 'Prepare release package for openkh (tool for developer; tested in Unix only)'
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

  desc 'Install OpenKH'
  task :install do
    ['public/modules', 'public/themes'].each do |dir|
      unless File.directory?(dir)
        puts "Create #{dir}..."
        FileUtils.mkdir_p(dir)
      end
    end

    puts 'Create basic data tables...'
    Rake::Task['db:migrate'].invoke

    puts 'Create data tables for modules...'
    Rake::Task['openkh:db:migrate:modules'].invoke

    puts 'Update Javascripts for JRails...'
    Rake::Task['jrails:update:javascripts'].invoke

    puts 'Add source code plugin for TinyMCE...'
    Rake::Task['tiny_mce:add'].invoke

    puts 'OpenKH installed, run rake openkh:demo if you want a demo site'
  end

  # This task should not be broken into each module's migration because of
  # their interrelation.
  desc 'Add demo data'
  task :demo => :environment do
    require 'faker'

    puts 'Add admin account with user name "admin" password "admin"...'
    admin = UnpUser.create(
      :user_name             => 'admin',
      :email                 => 'admin@example.com',
      :password              => 'admin',
      :password_confirmation => 'admin')

    puts 'Add some articles and comments...'
    15.times do |i|
      t = Time.now
      b = Article.create(
        :views        => rand(1000) + 1,
        :updated_at   => t,
        :title        => "Article #{i}",
        :introduction => '<p>' + Faker::Lorem.paragraph + '</p>',
        :body         => '<p>' + Faker::Lorem.paragraph + '</p>',
        :user_id      => admin.id,
        :ip           => '127.0.0.1',
        :created_at   => t)

      rand(15).times do |j|
        Comment.create(
          :model_type => 'Article',
          :model_id   => b.id,
          :user_id    => admin.id,
          :message    => '<p>' + Faker::Lorem.paragraph + '</p>',
          :ip         => '127.0.0.1')
      end
    end

    puts 'Add some Q/As and comments...'
    15.times do |i|
      t = Time.now
      q = Qa.create(
        :views      => rand(1000) + 1,
        :updated_at => t,
        :title      => "Q/A #{i}",
        :message    => '<p>' + Faker::Lorem.paragraph + '</p>',
        :user_id    => admin.id,
        :ip         => '127.0.0.1',
        :created_at => t)

      rand(15).times do |j|
        Comment.create(
          :model_type => 'Qa',
          :model_id   => q.id,
          :user_id    => admin.id,
          :message    => '<p>' + Faker::Lorem.paragraph + '</p>',
          :ip         => '127.0.0.1')
      end
    end

    puts 'Add some polls and comments...'
    15.times do |i|
      t = Time.now
      p = Poll.create(
        :title     => "Poll #{i}?",
        :responses => ['Response 1', 'Response 2', 'Response 3'],
        :votes     => [rand(10), rand(10), rand(10)],
        :voters    => [],
        :user_id   => admin.id,
        :ip        => '127.0.0.1')

      rand(15).times do |j|
        Comment.create(
          :model_type => 'Poll',
          :model_id   => p.id,
          :user_id    => admin.id,
          :message    => '<p>' + Faker::Lorem.paragraph + '</p>',
          :ip         => '127.0.0.1')
      end
    end

    puts 'Add Kosen map...'
    google_map_block_id = GoogleMapBlock.create(
      :region   => 0,
      :position => 1,
      :title    => 'Kosen map',
      :width    => '450px',
      :height   => '300px')
    [
      ['函館工業高等専門学校', 41.783993, 140.80194],
      ['苫小牧工業高等専門学校', 42.623728, 141.49631],
      ['釧路工業高等専門学校', 43.01618, 144.26111],
      ['旭川工業高等専門学校', 43.813442, 142.353694],
      ['札幌市立高等専門学校（市立）', 42.945146, 141.340656],
      ['八戸工業高等専門学校', 40.491495, 141.44803],
      ['一関工業高等専門学校', 38.924795, 141.107497],
      ['宮城工業高等専門学校', 38.167765, 140.864789],
      ['仙台電波工業高等専門学校（電波高専）', 38.276614, 140.751729],
      ['秋田工業高等専門学校', 39.772609, 140.077829],
      ['鶴岡工業高等専門学校', 38.709826, 139.797356],
      ['福島工業高等専門学校', 37.033066, 140.88835],
      ['茨城工業高等専門学校', 36.400474, 140.550692],
      ['小山工業高等専門学校', 36.319033, 139.842074],
      ['群馬工業高等専門学校', 36.37693, 139.023163],
      ['木更津工業高等専門学校', 35.384572, 139.954534],
      ['東京工業高等専門学校（国立）', 35.639424, 139.299109],
      ['東京都立産業技術高等専門学校（都立）', 35.735226, 139.809587],
      ['サレジオ工業高等専門学校（私立）', 37.433074, 138.888774],
      ['長岡工業高等専門学校', 36.678986, 138.233907],
      ['長野工業高等専門学校', 36.65112, 137.244065],
      ['富山工業高等専門学校', 36.65112, 137.244065],
      ['富山商船高等専門学校（商船高専）', 36.759052, 137.158856],
      ['石川工業高等専門学校', 36.662894, 136.739552],
      ['金沢工業高等専門学校（私立）', 36.533364, 136.629238],
      ['福井工業高等専門学校', 35.936981, 136.170859],
      ['岐阜工業高等専門学校', 35.446914, 136.672411],
      ['沼津工業高等専門学校', 35.136002, 138.883817],
      ['豊田工業高等専門学校', 35.103848, 137.148471],
      ['鳥羽商船高等専門学校（商船高専）', 34.482399, 136.824846],
      ['鈴鹿工業高等専門学校', 34.849488, 136.581473],
      ['近畿大学工業高等専門学校（私立）', 33.881122, 136.076767],
      ['舞鶴工業高等専門学校', 35.496334, 135.439711],
      ['大阪府立工業高等専門学校（府立）', 34.771177, 135.629075],
      ['明石工業高等専門学校', 34.695279, 134.90211],
      ['神戸市立工業高等専門学校（市立）', 34.68007, 135.067527],
      ['奈良工業高等専門学校', 34.648055, 135.758593],
      ['和歌山工業高等専門学校', 33.834098, 135.177755],
      ['米子工業高等専門学校', 35.455409, 133.289738],
      ['松江工業高等専門学校', 35.496439, 133.025765],
      ['津山工業高等専門学校', 35.081743, 134.013762],
      ['広島商船高等専門学校（商船高専）', 34.253598, 132.9041],
      ['呉工業高等専門学校', 34.233146, 132.601848],
      ['徳山工業高等専門学校', 34.052126, 131.846473],
      ['宇部工業高等専門学校', 33.955464, 131.274776],
      ['大島商船高等専門学校（商船高専）', 33.937112, 132.19074],
      ['阿南工業高等専門学校', 33.898169, 134.667277],
      ['高松工業高等専門学校', 34.311344, 134.010372],
      ['詫間電波工業高等専門学校（電波高専）', 34.23469, 133.636472],
      ['新居浜工業高等専門学校', 33.961106, 133.293064],
      ['弓削商船高等専門学校（商船高専）', 34.252304, 133.207383],
      ['高知工業高等専門学校', 33.549353, 133.681147],
      ['久留米工業高等専門学校', 33.334652, 130.510776],
      ['有明工業高等専門学校', 33.003949, 130.473804],
      ['北九州工業高等専門学校', 33.816433, 130.872295],
      ['佐世保工業高等専門学校', 33.15002, 129.748149],
      ['熊本電波工業高等専門学校（電波高専）', 32.87683, 130.748527],
      ['八代工業高等専門学校', 32.87683, 130.748527],
      ['大分工業高等専門学校', 33.232872, 131.651058],
      ['都城工業高等専門学校', 31.761122, 131.07964],
      ['鹿児島工業高等専門学校', 31.731507, 130.72885],
      ['沖縄工業高等専門学校', 26.526321, 128.03117]].each do |title, latitude, longitude|
      GoogleMapMarker.create(
        :google_map_block_id => google_map_block_id,
        :title               => title,
        :latitude            => latitude,
        :longitude           => longitude)
    end

    # Assume that theme "qwilm" is used
    puts 'Add some blocks...'

    # Region "content"
    RecentContentsBlock.create(
      :region   => 0,
      :position => 2,  # Kosen map block has position 1
      :title    => '',
      :mode     => 'preview')

    # Region "sidebar1"
    SearchBlock.create(
      :region   => 1,
      :position => 1)
    DictBlock.create(
      :region   => 1,
      :position => 2)
    ContentTypesBlock.create(
      :region   => 1,
      :position => 3)
    RecentContentsBlock.create(
      :region   => 1,
      :position => 3,
      :mode     => 'title')
    RemoteFeedBlock.create(
      :region   => 1,
      :position => 4)

    # Region "sidebar2"
    CurrentUserBlock.create(
      :region   => 2,
      :position => 1)
    ChatBlock.create(
      :region   => 2,
      :position => 2)
    video_width, video_height = 170.to_s, 152.to_s
    StaticBlock.create(
      :region   => 2,
      :position => 3,
      :title    => 'Funny video',
      :body     => '<object width="' + video_width + '" height="' + video_height + '"><param name="movie" value="http://www.youtube.com/v/dpfYAghuNtU&hl=en&fs=1"></param><param name="allowFullScreen" value="true"></param><embed src="http://www.youtube.com/v/dpfYAghuNtU&hl=en&fs=1" type="application/x-shockwave-flash" allowfullscreen="true" width="' + video_width + '" height="' + video_height + '"></embed></object>')
    PagesBlock.create(
      :region   => 2,
      :position => 4)
    ['Hardware', 'Software', 'Network', 'Graphics Design'].each do |name|
      Category.create(
        :name     => name,
        :slug     => name.downcase.gsub(/ /, '-'))
    end
    CategoriesBlock.create(
      :region   => 2,
      :position => 5)
  end
end
