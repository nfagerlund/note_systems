require 'fileutils'
require 'rake/clean'

applescripts = FileList['**/*.applescript.js'].map{|f| f.sub(/\.applescript.js$/, '.scpt')}
shortcuts = FileList['**/*.shortcut.plist'].map{|f| f.sub(/\.plist$/, '')}

bbedit = [
  "garbage_book/Garbage Book - Save page.scpt",
  "garbage_book/Garbage Book - Fix slug.rb",
  "garbage_book/Garbage Book - Tear out page.rb"
]

fastscripts = [
  "garbage_book/Garbage Book - Open.scpt",
  "fmp/FMP - Open lists folder in LaunchBar.scpt",
  "fmp/FMP - Append.scpt",
  "fmp/FMP - Refresh.rb"
]

# Generated files you can clean with `rake clobber`:
CLOBBER.concat(applescripts)
CLOBBER.concat(shortcuts)
CLOBBER << 'airdrop'

desc "Compile and install Mac scripts"
task mac: [:bbedit, :fastscripts]

desc "Compile iOS shortcuts and prep them for install"
task ios: [:shortcuts] do
  FileUtils.mkdir_p('airdrop')
  File.open('airdrop/readme.txt', 'w', encoding: 'utf-8') {|f|
    f.puts("Use AirDrop to send these shortcuts to your iOS device.")
  }
  FileUtils.cp(shortcuts, 'airdrop/')
  puts "To install shortcuts on iOS devices, see the 'airdrop' folder. Opening now..."
  sh "sleep 1"
  sh "open airdrop/"
end

desc "Compile everything, but leave compiled files in-place"
task compile: [:applescripts, :shortcuts]

# Compile OSA scripts
task applescripts: applescripts
# Compile shortcuts for iOS
task shortcuts: shortcuts
# How to compile:
rule '.shortcut' => '.shortcut.plist' do |t|
  FileUtils.cp(t.source, t.name)
  sh %Q{plutil -convert binary1 "#{t.name}"}
end
rule '.scpt' => '.applescript.js' do |t|
  sh %Q{osacompile -o "#{t.name}" -l JavaScript "#{t.source}"}
end

desc "Decompile everything (good for commiting changes after editing shortcuts in iOS)"
task :decompile do |t, args|
  Dir.glob('**/*.shortcut').each do |compiled|
    source = compiled + '.plist'
    FileUtils.cp(compiled, source)
    sh %Q{plutil -convert xml1 "#{source}"}
  end

  Dir.glob('**/*.scpt').each do |compiled|
    source = compiled.sub(/\.scpt$/, '.applescript.js')
    sh %Q{osadecompile "#{compiled}" > "#{source}"}
  end
end

def bullet_list(ary)
  ary.map{|s| "  - #{s}"}.join("\n")
end

# Install relevant scripts to user scripts folder, which may as well always exist
task fastscripts: [:applescripts] do
  dest = File.expand_path('~/Library/Scripts')
  FileUtils.mkdir_p(dest)
  puts "Copying files to #{dest}:\n" << bullet_list(fastscripts)
  FileUtils.cp(fastscripts, dest)
end

# Install relevant scripts to BBEdit scripts folder, which might not exist
task bbedit: [:applescripts] do
  dest_options = [
    '~/Dropbox/Application Support/BBEdit/Scripts',
    '~/Library/Mobile Documents/com~apple~CloudDocs/Application Support/BBEdit/Scripts',
    '~/Library/Application Support/BBEdit/Scripts'
  ].map{|dir| File.expand_path(dir) }

  dest = dest_options.select {|dir|
    File.directory?(dir)
  }.first

  if dest.nil?
    puts "Can't find BBEdit scripts folder in any of the following spots: \n" <<
         bullet_list(dest_options) << "\n" <<
         "Skipping install for:\n" <<
         bullet_list(bbedit)
  else
    puts "Copying files to #{dest}:\n" << bullet_list(bbedit)
    FileUtils.cp(bbedit, dest)
  end
end
