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

desc "Compile everything"
task compile: [:applescripts, :shortcuts]
desc "Compile OSA scripts"
task applescripts: applescripts
desc "Compile shortcuts for iOS"
task shortcuts: shortcuts

# How to compile:
rule '.shortcut' => '.shortcut.plist' do |t|
  FileUtils.cp(t.source, t.name)
  sh %Q{plutil -convert binary1 "#{t.name}"}
end
rule '.scpt' => '.applescript.js' do |t|
  sh %Q{osacompile -o "#{t.name}" -l JavaScript "#{t.source}"}
end

desc "Compile and install everything"
task install: [:bbedit, :fastscripts, :airdrop] do
  puts "Done! To install shortcuts on iOS devices, see the 'airdrop' folder."
end

def check_dir(dir)
  unless File.directory?(dir)
    raise "Can't find scripts dir at #{dir}!"
  end
end

desc "Install relevant scripts to FastScripts scripts folder"
task fastscripts: [:applescripts] do
  dest = File.expand_path('~/Library/Scripts')
  check_dir(dest)

  FileUtils.cp(fastscripts, dest)
end

desc "Install relevant scripts to BBEdit scripts folder"
task bbedit: [:applescripts] do
  dest = [
    '~/Dropbox/Application Support/BBEdit/Scripts',
    '~/Library/Mobile Documents/com~apple~CloudDocs/Application Support/BBEdit/Scripts',
    '~/Library/Application Support/BBEdit/Scripts'
  ].map{|dir|
    File.expand_path(dir)
  }.select {|dir|
    File.directory?(dir)
  }.first
  check_dir(dest)

  FileUtils.cp(bbedit, dest)
end

desc "Copy compiled shortcuts to a separate folder for easy airdroppitude"
task airdrop: [:shortcuts] do
  FileUtils.mkdir_p('airdrop')
  File.open('airdrop/readme.txt', 'w', encoding: 'utf-8') {|f|
    f.puts("Use AirDrop to send these shortcuts to your iOS device.")
  }
  FileUtils.cp(shortcuts, 'airdrop/')
  sh "open airdrop/"
end
