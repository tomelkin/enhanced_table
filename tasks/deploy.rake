namespace :macro do |ns|

  task :deploy do
    initialize_script = File.expand_path(File.join(File.dirname(__FILE__), '..', '/init.rb'))
    macro_folder = File.expand_path(File.join(File.dirname(__FILE__), '..', "lib"))
    mingle_plugins_folder = File.join(ENV['MINGLE_LOCATION'], 'vendor', 'plugins', 'enhanced_table')
    FileUtils.cp_r(initialize_script, mingle_plugins_folder)
    FileUtils.cp_r(macro_folder, mingle_plugins_folder)
    puts "#{macro_folder} successfully copied over to #{mingle_plugins_folder}. Restart the Mingle server to start using the macro."
  end

end