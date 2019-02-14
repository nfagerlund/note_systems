var gbook_dir = $('~/Library/Mobile Documents/com~apple~CloudDocs/Garbage Book').stringByExpandingTildeInPath.js;
bb = Application('BBEdit');
bb.activate();
bb.open(Path(gbook_dir));
