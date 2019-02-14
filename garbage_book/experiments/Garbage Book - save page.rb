#!/usr/bin/env ruby
# Save current buffer as a garbage book page
# This works... but it's hideously slow.

ARGF.set_encoding('utf-8')
gbook_dir = File.expand_path("~/Library/Mobile\ Documents/com~apple~CloudDocs/Garbage\ Book")
slug_length = 25

annoying_characters = %r{[\\/:\*\?"<>\|#%$;?\n\r]}
timestamp = Time.now.strftime('%Y.%m.%d (%H%M)')
slug = ARGF.gets.chomp[0..slug_length].gsub(annoying_characters, '_').sub(/[ _\.]+$/, '')
new_name = File.join(gbook_dir, "#{timestamp} #{slug}.txt")

script = <<EOT
tell application "BBEdit"
  save text document 1 to POSIX file "#{new_name}" without saving as stationery
end tell
EOT

IO.popen(['/usr/bin/osascript', '-'], 'w') {|osa|
  osa.puts(script)
}
