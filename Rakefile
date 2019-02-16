require 'fileutils'
require 'rake/clean'
require 'ostruct'

# applescripts = [
#   "garbage_book/Garbage Book - save page.scpt",
#   "garbage_book/Garbage Book - Open.scpt",
#   "fmp/FMP - Append.scpt",
#   "fmp/FMP - Open lists folder in LaunchBar.scpt"
# ]
#
# shortcuts = [
#   "garbage_book/New Garbage Book Page.shortcut",
#   "fmp/FMP Refresh.shortcut",
#   "fmp/FMP append.shortcut",
#   "fmp/Open ^file.shortcut"
# ]

# applescripts = source_applescripts.map {|f| f.dup.sub(/\.applescript\.js$/, '.scpt') }
# shortcuts = source_shortcuts.map {|f| f.dup.sub(/\.shortcut\.plist$/, '.shortcut') }

shortcuts_to_compile = Dir.glob('**/*.shortcut.plist').map{|f|
  OpenStruct.new(
    {
      source: f,
      dest: f.sub(/\.plist$/, '')
    }
  )
}
applescripts_to_compile = Dir.glob('**/*.applescript.js').map{|f|
  OpenStruct.new(
    {
      source: f,
      dest: f.sub(/\.applescript.js$/, '.scpt')
    }
  )
}
shortcuts_to_decompile = Dir.glob('**/*.shortcut').map{|f|
  OpenStruct.new(
    {
      source: f,
      dest: f + '.plist'
    }
  )
}
applescripts_to_decompile = Dir.glob('**/*.scpt').map{|f|
  OpenStruct.new(
    {
      source: f,
      dest: f.sub(/\.scpt$/, '.applescript.js')
    }
  )
}



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
# CLOBBER.concat(compiled_applescripts)
# CLOBBER.concat(compiled_shortcuts)
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

# task decompile: [:decompile_applescripts, :decompile_shortcuts]

# Compile OSA scripts
task applescripts: applescripts_to_compile.map{|s| s.dest}
# Compile shortcuts for iOS
task shortcuts: shortcuts_to_compile.map{|s| s.dest}
# Decompile OSA scripts
# task decompile_applescripts: compiled_applescripts.map {|f| f.dup.sub(/\.scpt$/, '.applescript.js') }
# Decompile shortcuts for iOS
# task decompile_shortcuts: compiled_shortcuts.map {|f| f.dup.sub(/\.shortcut$/, '.shortcut.plist') }

# How to compile:
shortcuts_to_compile.each do |s|
  file s.dest => [s.source] do |t|
    FileUtils.cp(t.prerequisites.first, t.name)
    sh %Q{plutil -convert binary1 "#{t.name}"}
  end
end
applescripts_to_compile.each do |s|
  file s.dest => [s.source] do |t|
    sh %Q{osacompile -o "#{t.name}" -l JavaScript "#{t.prerequisites.first}"}
  end
end
# How to decompile:
shortcuts_to_decompile.each do |s|
  file s.dest => [s.source] do |t|
    FileUtils.cp(t.prerequisites.first, t.name)
    sh %Q{plutil -convert xml1 "#{t.name}"}
  end
end
applescripts_to_decompile.each do |s|
  file s.dest => [s.source] do |t|
    sh %Q{osadecompile "#{t.prerequisites.first}" > "#{t.name}"}
  end
end

# rule '.shortcut' => '.shortcut.plist' do |t|
#   FileUtils.cp(t.source, t.name)
#   sh %Q{plutil -convert binary1 "#{t.name}"}
# end
# rule '.scpt' => '.applescript.js' do |t|
#   sh %Q{osacompile -o "#{t.name}" -l JavaScript "#{t.source}"}
# end
# rule '.shortcut.plist' => '.shortcut' do |t|
#   FileUtils.cp(t.source, t.name)
#   sh %Q{plutil -convert xml1 "#{t.name}"}
# end
# rule '.applescript.js' => '.scpt' do |t|
#   sh %Q{osadecompile "#{t.source}" > "#{t.name}"}
# end

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
