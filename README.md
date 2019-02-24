# FMP and Garbage Book are for Taking Notes

This README describes a pair of unpopular plain-text-based note-taking systems, which I've been using continuously for like ten-plus years:

- [**FMP**](#fmp) is for remembering stuff. It lets you add a line at a time to any number of named text files.

    I use it for gift ideas, keeping track of the books I read, abnormal shopping lists (like, "wtf was I supposed to look for at Ikea?"), serial numbers, stuff I've loaned out to people, etc.
- [**Garbage Book**](#garbage-book) is for working on stuff. It acts sort of like Apple Notes, except that it uses my favorite text editor(s) instead of a separate app that I don't like as much.

    I use it for drafting blog posts, journaling, and basically anything else where I just need to put some text on a blank page and be able to find it later.

Both of these systems have a quality that I like to call "elegance through stupidity." You might or might not be looking for that.

## Installation

**You'll want to build your own versions of these anyway!** I assembled FMP and Garbage Book out of apps I was already using and a handful of scripts, and replaced a bunch of parts over the years; really the whole appeal was that I'd keep using what I already liked, and I assume you'll want to do the same.

The scripts in this repo are mostly presented as a source of ideas, a starting point; I don't expect anyone to use my exact setup. _That said,_ here's how to get that exact setup working.

First, check out a local copy of this repo.

### Installing the Mac Stuff

1. Get [FastScripts](https://red-sweater.com/fastscripts/), [LaunchBar](https://www.obdev.at/products/launchbar/), and [BBEdit](https://www.barebones.com/products/bbedit/).
    - Launch BBEdit at least once so it has a chance to make its Application Support directory.
1. Make two new folders in iCloud Drive:
    - `Lists`
    - `Garbage Book`
1. Run `rake mac` in your working copy of this repo. This installs everything.
1. In BBEdit's "Menus & Shortcuts" preferences, choose good keyboard shortcuts for the following scripts:
    - [Garbage Book - Save page](./garbage_book/Garbage%20Book%20-%20Save%20page.applescript.js)
    - [Garbage Book - Fix slug](./garbage_book/Garbage%20Book%20-%20Fix%20slug.rb)
    - [Garbage Book - Tear out page](./garbage_book/Garbage%20Book%20-%20Tear%20out%20page.rb)
1. In FastScripts's preferences, choose good **global** keyboard shortcuts for the following scripts:
    - [Garbage Book - Open](./garbage_book/Garbage%20Book%20-%20Open.applescript.js)
    - [FMP - Append](./fmp/FMP%20-%20Append.applescript.js)
        - and/or [FMP - Direct append](./fmp/FMP%20-%20Direct%20append.applescript.js)
    - [FMP - Refresh](./fmp/FMP%20-%20Refresh.rb)
    - [FMP - Open lists folder in LaunchBar](./fmp/FMP%20-%20Open%20lists%20folder%20in%20LaunchBar.applescript.js)

Good to go!

### Installing the iOS Stuff

1. Get [Shortcuts](https://itunes.apple.com/us/app/shortcuts/id915249334) and [iA Writer](https://itunes.apple.com/us/app/ia-writer/id775737172).
1. Add Shortcuts to the "Today" view.
    - (Swipe left from notifications or the home screen, and tap "Edit" at the bottom.)
1. In iA Writer, add the "Lists" and "Garbage Book" folders to the Library.
    - Go to the main "Library" screen, tap "Edit" in the upper right, tap "Add Location" at the bottom of the "Locations" list, and follow the instructions in the pop-up.
1. In iA Writer, enable URL commands and get your auth token.
    - Go to the main "Library" screen, tap the gear in the upper left, go to "URL Commands", turn the switch on, and copy the token.
1. On your Mac, run `rake ios` in your working copy of this repo.
    - This compiles all the shortcuts and reveals them in a Finder window.
1. AirDrop the shortcuts to your iOS device.
    1. Open a second Finder window, go to "AirDrop" in the sidebar, and wake up your iOS device.
    1. One by one, drag each shortcut to your device's AirDrop target; on your device, confirm installation. Some of them will ask for your iA Writer auth token.

Done! You can use these shortcuts from the widget, plus you can use the system share menu for the ones that append to text files.

### Not Installing Anything

1. Just mess around with whatever you want from this repo and make some better scripts and shortcuts of your own!
1. Before that, though, maybe run `rake compile` to convert the shortcuts and the "Javascript For Automation" scripts into formats that Shortcuts and Script Editor.app can handle.
1. AirDrop is probably the best way to get shortcuts back into iOS so you can check them out in the normal Shortcuts editor, but maybe you can email them too, idk.

-----

## FMP

FMP lets you quickly add notes to named buckets of notes. You don't have to set up your buckets ahead of time, you can just start using new ones as you need them.

### What It Is

- A flat folder of plain text files, synced across all your devices.
- One designated "dump file" in that folder. (I use `fiend.txt`.)
- A _very fast_ way to append a line to the end of the dump file at any time, regardless of what you're currently doing.
- Something that moves any lines beginning with `^caret-tag` out of the dump file and into `caret-tag.txt`.
    - Caret tags can include letters, numbers, underscores (`_`), and hyphens (`-`). They end at the next space character.
    - `caret-tag.txt` doesn't need to exist yet. It'll get created when it's needed.
    - When moving lines, replace any occurrences of two slashes surrounded by spaces (`like // this`) with a line break. (Technically optional, but you'll use it all the time.)
- A _very fast_ way to open any file from the lists folder by name.

![the quick-append window from the FMP scripts, asking for a line of text.](./fmp.png)

### How to Use It

Append a note whenever you need to remember something, using the first `^caret-tag` name that occurs to you. For example, if someone tells me about a book I should read, I'll append something like:

```
^seekbook Ann Leckie - Ancillary Justice
```

... and later I'll check `seekbook.txt` when I'm wondering what to read next.

Feel free to append things without a `^caret-tag`; they can stay in the dump file until you think of something to do with them.

Before checking a list file, or just whenever you feel like it, run the refresh script.

### wtf?

See also [What's the Deal w/ FMP](./WHY.md#whats-the-deal-w-fmp).

-----

## Garbage Book

Garbage Book acts like a spiral notebook. Turn to a blank page, do whatever I need to do, turn to a new blank page. If I need a page later, flip backwards until I find it. Tear a page out if I want to move it somewhere else.

### What It Is

- A folder of plain text files, synced across all your devices. (You can move older files into subfolders to keep things clean.)
- A scriptable text editor with a really good folder-browsing view.
- A script to save the current text buffer to the Garbage Book folder with an auto-generated filename.
    - Timestamp first (I like `"%Y.%m.%d (%H%M)"`), then the first line of the buffer (truncated if necessary, with any iffy-in-a-filename characters removed).
- Optionally, a global hotkey to open the folder in your editor's browser view.

![screenshot of a browser view in my editor](./garbage_book.png)

### How to Use It

Open a new text editor window and type for a while. When you remember you're in an unsaved buffer, hit the hotkey to save it in Garbage Book and then keep working.

When you need to go back to something you were working on, open the Garbage Book folder in your editor's browser view. Look back to around the time when you were working on Thing, then use the first-line summaries to find the page you need.

When you need to do something else with a page (move it into a Git repo, email it to someone, etc.), just drag it to wherever, maybe rename it, your call.

### wtf?

See also [What's the Deal w/ Garbage Book](./WHY.md#whats-the-deal-w-garbage-book).
