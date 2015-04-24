#!/usr/bin/env ruby
# (c) 2006 Nick Fagerlund; available under the GNU General Public License
# http://www.gnu.org/copyleft/gpl.html
#
# Modifications by David Douthitt
#
# Implements the Fiendish Master Plan capture-sorting system, which
# is really not so sophisticated that it deserves its own name, but
# which has one anyway.

# Use case: ~/Lists/fiend.txt is a text file that I use for catching
# notes as I think of them. When I have a note that belongs in a
# separate file, I can put it on one line that begins with the sequence
# ^nameoffile. When fmp.rb runs, it removes any lines starting with
# ^variousfilenames and puts them at the end of their appropriate
# files.

# Why I like this:
# -I can append to any file in my Lists folder, but I only have to keep
# one file open. By combining this with Quicksilver's append triggers,
# I've got a pretty powerful note-sorting system.
# -If ^somefile doesn't exist yet, fmp creates it without any fuss, so I
# can create new collections of notes at whim without having to do
# anything different.
# -I can import any collection of notes into the system simply by
# dumping the file into ~/Lists and naming it
# some_filename_sans_spaces.txt.

# Caveats and gotchas:
# 1. File names used in start-of-line caret tags can't have any spaces
# in them. The only allowed characters are alphanumerics, -, ., and _.

require 'pathname'

fiendTwigs = ''

$fiendDir = Pathname.new( ENV["FMPROOT"] || "~/Lists" ).expand_path
fiendPath = Pathname.new( ENV["FMPFILE"] || $fiendDir + "fiend.txt" ).expand_path
fiendFile = fiendPath.basename(".*")


$fiendDir.mkdir unless $fiendDir.exist?

unless $fiendDir.directory?
  print "Not a directory: #{$fiendDir}\n"
  exit 1
end

unless fiendPath.exist?
  print "File does not exist: #{fiendPath}\n"
  exit 1
end

class Category
  def initialize(name)
    @pathname = $fiendDir + "#{name}.txt"
    @entries = []
  end

  def entries(entry)
    @entries << entry
  end

  def write()
    @pathname.open("a") { |leafFile|
      leafFile.puts(@entries.join("\n"))
    }
  end
end

leaves = Hash.new

fiendPath.readlines(:encoding => 'utf-8').each { |line|
  line.chomp!
  tag = ""
  entry = ""

  if ((line =~ /^(\^[\S]+) (.*)$/) != nil)
    tag = $1.downcase
    entry = $2
  end

  case tag
  when /^#/, "", /^;/, /^\/\//
    fiendTwigs << line + "\n"
    # David assures me that this is worth doing.
  when "\^#{fiendFile}"
    fiendTwigs << entry + "\n"
    # I think I had a bad dream about THIS bit of perverse input.
  when /^\^([\w.\-]+)$/

    xtag = $1
    leaves[xtag] = Category.new(xtag) unless leaves.member?(xtag)
    leaves[xtag].entries(entry)
  else
    fiendTwigs << line + "\n"
  end
}

# Rewrite fiend file...
fiendPath.open("w") { |f|
  f.puts(fiendTwigs)
}

# Append to leaf files...
leaves.each { |key, val|
  val.write
}
