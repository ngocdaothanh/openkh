namespace :tiny_mce do
  desc 'Add things in tiny_mce_additionals directory to tiny_mce directory'
  task :add do
    # insercode plugin
    FileUtils.cp_r 'public/javascripts/tiny_mce_additionals/plugins/insertcode', 'public/javascripts/tiny_mce/plugins'
    FileUtils.rm_rf Dir.glob('public/javascripts/tiny_mce/plugins/insertcode/**/.svn')

    # Vietnamese packs for TinyMCE
    FileUtils.cp 'public/javascripts/tiny_mce_additionals/langs/vi/langs/vi.js', 'public/javascripts/tiny_mce/langs/'
    FileUtils.cp 'public/javascripts/tiny_mce_additionals/langs/vi/themes/advanced/langs/vi.js', 'public/javascripts/tiny_mce/themes/advanced/langs'
    FileUtils.cp 'public/javascripts/tiny_mce_additionals/langs/vi/themes/advanced/langs/vi_dlg.js', 'public/javascripts/tiny_mce/themes/advanced/langs'
  end
end
