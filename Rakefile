require 'fileutils'
require 'rake/clean'

task default: [:compile]

applescripts = [
  "garbage_book/Garbage Book - save page.scpt",
  "garbage_book/Garbage Book - Open.scpt",
  "fmp/FMP - Append.scpt",
  "fmp/FMP - Open lists folder in LaunchBar.scpt"
]

shortcuts = [
  "garbage_book/New Garbage Book Page.shortcut",
  "fmp/FMP Refresh.shortcut",
  "fmp/FMP append.shortcut",
  "fmp/Open ^file.shortcut"
]

bbedit = [
  "garbage_book/Garbage Book - save page.scpt",
  "garbage_book/Garbage Book - fix slug.rb",
  "garbage_book/Garbage Book - tear out page.rb"
]

fastscripts = [
  "garbage_book/Garbage Book - Open.scpt",
  "fmp/FMP - Open lists folder in LaunchBar.scpt",
  "fmp/FMP - Append.scpt",
  "fmp/fmp.rb"
]

# Generated files you can clean with `rake clobber`:
CLOBBER.concat(applescripts)
CLOBBER.concat(shortcuts)
CLOBBER << 'airdrop'

desc "Compile and install everything"
task install: [:bbedit, :fastscripts, :airdrop] do
  puts "Done! To install shortcuts on iOS devices, see the 'airdrop' folder."
  sh "open airdrop/"
end

desc "Compile everything"
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

# Install relevant scripts to user scripts folder, which may as well always exist
task fastscripts: [:applescripts] do
  dest = File.expand_path('~/Library/Scripts')
  FileUtils.mkdir_p(dest)
  FileUtils.cp(fastscripts, dest)
end

def bullet_list(ary)
  ary.map{|s| "  - #{s}"}.join("\n")
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
    FileUtils.cp(bbedit, dest)
  end
end

# Copy compiled shortcuts to a separate folder for easy airdroppitude
task airdrop: [:shortcuts] do
  FileUtils.mkdir_p('airdrop')
  File.open('airdrop/readme.txt', 'w', encoding: 'utf-8') {|f|
    f.puts("Use AirDrop to send these shortcuts to your iOS device.")
  }
  FileUtils.cp(shortcuts, 'airdrop/')
end
