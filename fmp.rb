#!/usr/bin/env ruby
# fmp.rb version 2.1
# (c) 2006-2019 Nick Fagerlund; available under the GNU General Public License
# http://www.gnu.org/copyleft/gpl.html

# Fast Memo Pencil. Fiendish Master Plan. Free Mashed Potatoes.
# It's a three part system. You need:
# 1. A fast way to append lines to ~/Lists/fiend.txt.
# 2. This script (and a fast way to run it), which moves any lines starting with
# ^caret-tag to ~/Lists/caret-tag.txt. Caret tags can include letters, numbers,
# underscores (_), and dashes (-).
# 3. A fast way to open a text file in ~/Lists by name.

# Changes in 2.0 (Feb 2019):
# - make it not stupidly complicated!
# - periods aren't allowed in ^caret tags now. I never used this.
# - changed behavior of env vars, no one's using those anyway and you need to
#   have those paths scattered across your append and open scripts too, so it's
#   not like you can just--anyway, I changed their names and the file one is just
#   a tag name now, and also your main dump file has to be in the same dir as the
#   other notes files.

require 'pathname'

FMP_DIR = Pathname.new( ENV["FMP_DIR"] || '~/Lists' ).expand_path
FMP_DUMP_TAG = ENV["FMP_DUMP_TAG"] || 'fiend'
DUMP_FILE = FMP_DIR + "#{FMP_DUMP_TAG}.txt"

unless FMP_DIR.directory?
  raise "Not a directory: #{FMP_DIR}"
end

unless DUMP_FILE.exist?
  raise "File does not exist: #{DUMP_FILE}"
end

caretnotes = {}

DUMP_FILE.readlines(encoding: 'utf-8').each { |line|
  line.chomp!
  if /^\^([\w\-]+) (.*)$/.match(line)
    tag = $1
    note = $2
  else
    tag = FMP_DUMP_TAG
    note = line
  end
  (caretnotes[tag] ||= []) << note.gsub(%r{ +// +}, "\n")
}

# Waste the dump file (we'll replace it in a sec)
DUMP_FILE.truncate(0)

# Append to ^caretnote files, including the dump file
caretnotes.each {|tag, notes|
  (FMP_DIR + "#{tag}.txt").open('a') {|f|
    f.puts(notes.join("\n"))
  }
}
