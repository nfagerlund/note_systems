#!/usr/bin/ruby
# fmp.rb version 1.2
# (c) 2006 Nick Fagerlund; available under the GNU General Public License
# http://www.gnu.org/copyleft/gpl.html
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
# 2. Ruby wants nice, clean Unix line breaks, and will boff up the
# formatting if it doesn't find them. When I first used this on a copy
# of my notes files, they had lived on three different operating
# systems, and the breaks were kind of a mess. So before you start
# using fmp for the first time, it's a good idea to run your files
# through something like Josh Aas's LineBreak.app.

fiendTwigs = ''

File.readlines("#{File.expand_path("~/Lists/fiend.txt")}").each do |theLine|
	if theLine =~ /^\^[Ff][Ii][Ee][Nn][Dd] /
		fiendTwigs << theLine.sub(/^\^[\S]+ /, '')
		# I think I had a bad dream about THIS bit of perverse input.
	elsif theLine =~ /^\^[A-Za-z\d_.\-]+ /
		File.open("#{File.expand_path("~/Lists/#{theLine.split(' ', 2)[0].sub(/\^/, '').chomp}.txt")}", "a") { |leafPile| leafPile.puts(theLine.sub(/^\^[A-Za-z\d_.\-]+ /, '')) }
	else
		fiendTwigs << theLine
	end
end

File.open("#{File.expand_path("~/Lists/fiend.txt")}", "w") { |fiendMain| fiendMain.puts(fiendTwigs) }
