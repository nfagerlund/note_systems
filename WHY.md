# Miscellany and Appendices

## What's the Deal w/ FMP?

I made FMP in 2006.

### That Name

The name stands for, uh,

- Fast Memo Pencil
- Fiendish Master Plan
- Free Mashed Potatoes
- Fragmentary Mental Process
- Folder of Messy Piles

Well, tbh there used to be a file on my desktop that I kept all my crap in, and it was called "my fiendish master plan.rtf" because I was 22 and thought that was hilarious, and now I'm kind of stuck with it. 🤷🏽‍♀️ "Folder of Messy Piles" is a better name, imo.

### Finding Things in Reverse

I can't remember where I set objects down, and I learned to compensate by predicting where my future self will try to look for something and just setting it down _there._ This is all the way ass-backwards, but it _does_ actually work (whereas remembering doesn't).

I wasn't thinking about that when I made FMP, but I'm pretty sure I'm using it the exact same way — just guess which text file I'll check first, and put it _there._ (And if that's _not_ how you've been avoiding disaster for three decades plus, FMP probably sounds like fucking chaos and it's giving you anxiety just reading about it.)

BTW, I think that finally explains why it's so important to silently create files when I use a new ^caret-tag!! Since I'm thinking like my future self, I'm expecting those files to already exist, and having to explicitly create them always felt like having to repeat myself when everyone heard me just fine the first time. (I always considered that the most important part of the whole thing, but never knew why I was so fixated on it. Live and learn.)

### The Dump File and the Refresh Script

It's probably smarter to have your append script write directly to the caret-tag files instead of the dump file, and then you never actually need the refresh script. So I eventually made some "direct append" scripts that do exactly that ([Mac](./fmp/FMP%20-%20Direct%20append.applescript.js), [iOS](./fmp/Append%20to%20%5Efile.shortcut.plist)).

But even though the original design came from being lazy and bad at scripting, it turns out I really like a couple things about it:

- I can open the dump file and add a whole bunch of unrelated notes in a row.
- It's easy to go back and tag a bunch of orphaned notes in the dump file later, if I suddenly think of a good place for them.
- ...uh, running the refresh script feels kinda good. I can't really explain it, it's just really satisfying. 😑 Sorry.

### Cowpaths

For the most part, I got FMP's design exactly how I wanted it on the first try and then left it alone. The only real addition in 13 years was that `first line // second line` trick for line breaks. I just found myself already doing it all the time — I'd want to put two things in the didread file but was too lazy to open the append field twice, so I'd leave some slashes to remind me later where the break was supposed to go.

Come to think of it, that's how the ^caret-tags started, too — I started using them to remember context for otherwise cryptic notes in my dump file long before I had any way to sift them out. Then eventually I got frustrated by how bullshit it was to sort them out by hand, and here we are.

### To-Dos

You can do whatever what you want, but I humbly suggest not using FMP for to-dos or reminders. It's tempting when you first think of it, but I've found it's good for things you're motivated to remember and bad for things you're reluctant to remember.

One thing that does work OK is catching tasks before you forget them and then moving them into your real to-do list later.

### Ancient History

FMP originally relied on Quicksilver for appending! (Remember Quicksilver?) I abandoned QS once it was abandoned, but while LaunchBar is nicer for some things, it isn't as nice for appending text, so I eventually (years later!!!) gave up and wrote that append script.

I sent FMP in to 43 Folders back in the day, and Merlin Mann linked it from his linkblog and I actually got like three or four emails about it plus a code contribution. ✨Memories✨ lol

-----

## What's the Deal w/ Garbage Book?

I made Garbage Book in 2008.

### Spiral-ness

What I really wanted was something where:

- The pages stay in the order they were created and don't move around, so it's easy to "flip back" to find something.
- You can tell at a glance what's in a page without having to open the file.
- "Turning to a blank page" is as close to a single action as possible; you shouldn't have to repeat your intent multiple times by specifying which folder to save it in or choosing a filename.

There were already apps that (mostly) worked like this in 2007! I think Notational Velocity was the first one I used, but the iOS (and, later, Mac) Notes app is also close. But I already had a text editor I really liked ([BBEdit](https://www.barebones.com/products/bbedit/), don't @ me), and the editing interface in those single-purpose notebook apps felt rinky-dink and annoying to me. Plus they all saved their pages in a database or some other weird format instead of just using normal-ass UTF-8 .txt files — what if I need to cat something I'm working on into a shell script, huh??? _What then??????_

Anyway, I barely had to do anything to roll my own replacement. The only hard part was doing text manipulation in AppleScript, which is less of a problem now that you can use JavaScript instead.

### Slugs

The iOS version does things in the opposite order from the Mac version, because I couldn't convince Shortcuts to _rename_ an iCloud Drive file. So it gives you the option of typing a first line before creating the file; if you do, it uses that as the slug, and otherwise the slug is empty.

### Tweaks

There were a few extra tools I eventually added:

- The "tear out page" script reverses the elements of the filename, which takes a page out of the timeline and moves it to the end of the list. Useful if one particular page is the most important thing you're working on for a week.
- The "fix slug" script leaves a page in the timeline, but updates its slug to match the current first line. Useful when the slug doesn't match the content anymore, or if you've been using the iOS shortcut.

Mac-only, because of the automated file renames.

-----

## Apps

- There's probably other iOS text editors that could replace iA Writer in these shortcuts. You need something that can get persistent access to an arbitrary folder from the Files app, and can use `x-callback-url` actions to do scripted reading/writing/creation of files in that folder. But I like iA Writer quite a bit, so I'm not really on the hunt.
- FastScripts is an app that does almost nothing, and I love the heck out of it.

-----

## OSA Scripts

AppleScript, man. What a smoldering coal seam of a language. I've converted all the stuff in this repo to "JavaScript for Automation" over the years, but if you wanna huff some noxious fumes, compare [the original Garbage Book save script](garbage_book/errata/Garbage%20Book%20-%20save%20page.applescript) to the current one. The spine-breaking contortions it takes to do even the most basic text replacements!

That said, while JXA at least acts like a normal programming language some of the time, it is both heinously underdocumented and dubiously maintained. For example, `.whose({"_and": [...]})` clauses are just 100% broken in at least Mojave (`error -1700 can't convert types`) and I can't seem to find any information about wtf is up with that. And any StackOverflow question about JXA is immediately taken over by one specific axe-grinding weirdo. (Although their comments did actually help me understand what's going on with "element arrays" under the hood, so good on them for that.) TBH everything about application scripting on the Mac seems to be rotting right now, and maybe it was a bad idea to begin with, except that it's just so _useful_ sometimes, ugh.

Regardless which language you're using, OSA scripts need to be compiled before use, and even though the compiled files retain the source code, they're saved as binary blobs that you don't want in your Git repo. Usually you'd use Script Editor.app to convert between text-only and compiled versions of a script, but there's no way to indicate that a text file is in JavaScript and still have Script Editor open it, which makes that even more of a pain than usual.

Anyway, `osacompile` and `osadecompile` are what you want for that.

-----

## Shortcuts

You edit shortcuts with a graphical drag-and-drop interface, and ever since I got this stuff working I've been living in terror that I was gonna fumble something important and be unable to get it working again. I've gotten too used to modern version control!

Well, it took me until I was writing this whole thing up, but I _did_ eventually learn how to version-control your shortcuts.

You can get a shortcut off your phone by opening the editor, hitting share, choosing "Share as File", and putting it somewhere your Mac can get to (like iCloud Drive or Dropbox or AirDrop). That gets you a `.shortcut` file, which is a "binary plist" with a different file extension. `plutil` can cleanly round-trip between the binary and XML plist formats, and the XML format plays nicely with Git.

Once the XML is in Git, other people can install the shortcuts by converting them back to binary and airdropping them. And on your end, you can make changes as needed in the Shortcuts app and check those changes into version control by sending the updated file over and using it to overwrite the old XML. (That's what the `rake decompile` task here is for. Also, if some of your shortcuts have user-specific info you don't want to check in, this might be a good time to discover `git add -p`.)

Be cool if you could convert a shortcut on-phone and check it in with Working Copy or something, but I have a suspicion that's gonna be a no-go. (Update: whoa, [that might not be a no-go](https://routinehub.co/shortcut/1486). 😯 I'm going to keep doing the commits on a computer, but I definitely adopted the snippet that dumps all your shortcuts to an iCloud Drive folder as xml plists.)

-----

## Notes in General

Notes. Notes notes notes notes notes. 📝📝📝📝📝📝📝📝📝📝📝📝📝📝📝📝📝

Everyone has their own little system for taking notes, and the only exceptions are the people with ten or twenty little systems for taking notes. Some people use bullet journals, some people use receipts and gum wrappers wadded up at the bottom of their purse, a LOT of people use the built-in Notes app on their telephones, and about thirteen years ago there was even a baffling (yet somehow enticing) vogue for using a stack of index cards with a binder clip. There's only one common thread: no matter who you are or what fucked-up thing you're doing, everyone else's note-taking system sounds impossible to use without going the whole rest of the way around the bend. Why can't they just be sensible and do it your way? I mean _HONESTLY._
