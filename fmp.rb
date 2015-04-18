#!/usr/bin/ruby

fiendTwigs = ''
$fiendDir = ENV["HOME"] + "/Lists"
fiendFile = "fiend.txt"
fiendPath = $fiendDir + "/" + fiendFile

Dir.mkdir($fiendDir) unless File.exists?($fiendDir)

fstat = File.stat($fiendDir)
unless fstat.directory?
	print "Not a directory: #{$fiendDir}\n"
	exit 1
end

unless (File.exists?(fiendPath))
	print "File does not exist: #{fiendPath}\n"
	exit 1
end

puts "FMP fiend.txt file:"
puts fiendPath

class Category
	def initialize(name)
		@pathname = $fiendDir + "/" + name + ".txt"
		@entries = []
	end

	def barf()
		print "\n"
		puts @pathname
		puts @entries.join("\n")
	end
	
	def entries(entry)
		@entries << entry
	end

	def write()
		File.open(@pathname, "a") { |leafFile|
			leafFile.puts(@entries.join("\n"))
		}
#		print "\n", @pathname, "\n", @entries.join("\n"), "\n"
	end
end

leaves = Hash.new

File.readlines(fiendPath).each { |line|
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
		when "\^fiend"
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

puts "---Here's what would get written to fiend.txt:---"
puts fiendTwigs
puts "---leaf files and their append-to contents:---"
leaves.each { |key, val|
	leaves[key].barf
}