#!/usr/bin/ruby
# fmp.rb version 0.9
# (c) Nick Fagerlund; available under the GNU General Public License
# <GPL URL>
# Implements the Fiendish Master Plan capture-sorting system, which
# is really not so complicated that it deserves its own name, but is
# called so anyway for Historical Reasons.

# Use case: You have one file that's almost always open for catching notes as you think of them. When you have a note that belongs in a separate file, you put it on one line that begins with the sequence ^nameoffile. When you run fmp.rb to sort the main file, it puts any lines starting with ^variousfilenames at the end of their appropriate files. The beauty of this system is that it does the right thing even if ^thatfile doesn't exist yet, so you can create new collections of notes at whim without having to do anything different. 

# Caveats and gotchas:
# 1. File names used in start-of-line caret tags can't have any spaces in them. Any other filesystem-legal character ought to be fine. You're in charge of figuring out what's filesystem-legal around your system, and I'm not sure yet what happens when it's fed something perverse.
# 2. Ruby wants nice, clean Unix line breaks, and will boff up the formatting if it doesn't find them. When I first used this on a copy of my notes files, they had lived on three different operating systems, and the breaks were kind of a mess. So before you start using fmp for the first time, it's a good idea to run your files through something like Josh Aas's LineBreak.app.

fiendTwigs = ''

File.readlines("/Users/nick/Lists/fiend.txt").each do |theLine|
	if theLine =~ /^\^[Ff][Ii][Ee][Nn][Dd] /
		fiendTwigs << theLine.sub(/^\^[\S]+ /, '')
	elsif theLine =~ /^\^[\S]+ /
		File.open("/Users/nick/Lists/#{theLine.split(' ', 2)[0].sub(/\^/, '').chomp}.txt", "a") do |leafPile|
			leafPile.puts(theLine.sub(/^\^[\S]+ /, ''))
		end
	else
		fiendTwigs << theLine
	end
end

File.open("/Users/nick/Lists/fiend.txt", "w") do |fiendMain|
	fiendMain.puts(fiendTwigs)
end
