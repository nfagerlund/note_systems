-- Configuration details:

tell application "Finder" to set tilde to home as text
set gbook_folder to tilde & "Library:Mobile Documents:com~apple~CloudDocs:Garbage Book:" -- Change this to reflect the directory you want to keep your notebook in. I'm not testing for existence, so create it first.
set gbook_prefix to "" -- in case you want to prefix every page with "gbook" or something. (Which I _thought_ I did, but decided I didn't. Maybe you will, though.)
set gbook_stamp to (do shell script "date +\"%Y.%m.%d (%H%M)\"") as text
set suffix_length to 25 -- The number of characters from the file to append.

-- Setup for cleaning the suffix:
property illegalCharacters : {"\\", "/", ":", "*", "?", "\"", "<", ">", "|", "#", "%", "$", ";", "?", "
"} Â
	-- this is the list of characters to substitute from inside the filename
property substituteCharacter : "_" -- this is the character to substitute for the illegal characters
property illegalEnds : {" ", "_", "."} -- this is the list of characters to remove from the start or end of the file


tell application "BBEdit"
	-- Generate the unique suffix so that we can have more than one file a day without using seconds in the date call. (Because that's ugly, and tells me nothing about the contents of the file.)
	if (count of characters of line 1 of text document 1) < suffix_length then
		set gbook_suffix to text of line 1 of text document 1 as text
	else
		set gbook_suffix to characters 1 thru suffix_length of line 1 of text document 1 as text
	end if
	set gbook_suffix to my fixCharacters(gbook_suffix)
	set gbook_suffix to my fixLast(gbook_suffix)
	
	save text document 1 to file (gbook_folder & gbook_prefix & gbook_stamp & " " & gbook_suffix & ".txt") without saving as stationery
end tell



--These routines all came from http://www.macosxhints.com/dlfiles/fix_illegal_names_scpt.txt. Thanks, author whose name isn't in the file and whose identity it is too much trouble to track down! That saves me hella time.

on fixEnds(theName)
	set theName to my fixFirst(theName) -- fix the start of the name
	set theName to my fixLast(theName) -- fix the end of the name
	return theName -- pass back the (un)changed name
end fixEnds

on fixCharacters(theName)
	repeat with x from 1 to (count illegalCharacters) -- loop through the list of illegal characters
		if theName contains (item x of illegalCharacters) then -- if this character is in the filename
			set oldDelims to AppleScript's text item delimiters -- store the current delimiters
			set AppleScript's text item delimiters to (item x of illegalCharacters) -- set the delimiter to the illegal character
			set theTextItems to text items of theName -- extract the text without the illegal character as a list of strings
			set AppleScript's text item delimiters to substituteCharacter -- set the delimiter to be the substitute character
			set theName to theTextItems as text -- change the list of strings back into a single string
			set AppleScript's text item delimiters to oldDelims -- change the delimiters back to what they were originally
		end if
	end repeat
	return theName -- pass back the (un)changed name
end fixCharacters

on fixFirst(theName)
	set theFirst to first character of theName -- check the first character of the item name
	if theFirst is in illegalEnds then -- if the first character is in the illegal list
		set theName to text 2 thru -1 of theName -- remove the first character of the name
		set theName to my fixFirst(theName) -- make sure we haven't uncovered any more illegals
	end if
	return theName -- pass back the (un)changed name
end fixFirst

on fixLast(theName)
	set theLast to last character of theName -- check the last character of the item name
	if theLast is in illegalEnds then -- if the last character is in the illegal list
		set theName to text 1 thru -2 of theName -- remove the last character of the name
		set theName to my fixLast(theName) -- make sure we haven't uncovered any more illegals
	end if
	return theName -- pass back the (un)changed name
end fixLast

