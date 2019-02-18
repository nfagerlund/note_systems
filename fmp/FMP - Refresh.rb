#!/usr/bin/env ruby
# version 2.whatever (hopefully you're installing this automatically by now and
# don't need to watch the version numbers anymore 🤷🏽‍♀️)

# Fast Memo Pencil. Fiendish Master Plan. Free Mashed Potatoes.
# It's a three part system. You need:
# 1. A fast way to append lines to a dump file in the FMP dir.
# 2. This script (and a fast way to run it), which moves any lines starting with
#    ^caret-tag to caret-tag.txt. Caret tags can include letters, numbers,
#    underscores (_), and dashes (-).
# 3. A fast way to open a text file in the FMP dir by name.

# Recent changes (Feb 2019):
# - make this script not be stupidly complicated!
# - periods aren't allowed in ^caret tags now. I never used this.
# - no more magic env vars for configuring paths. just edit the scripts.

require 'pathname'

FMP_DIR = Pathname.new('~/Library/Mobile Documents/com~apple~CloudDocs/Lists').expand_path
FMP_DUMP_TAG = 'fiend'
DUMP_FILE = FMP_DIR + "#{FMP_DUMP_TAG}.txt"

caretnotes = {}

DUMP_FILE.readlines(encoding: 'utf-8').each { |line|
  line.chomp!
  if /^\^([\w\-]+) (.*)$/.match(line)
    tag = $1.downcase
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
