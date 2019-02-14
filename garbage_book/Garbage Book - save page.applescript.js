// Wow, even as gross as this is, it's like 0.03x as gross as the AppleScript version
var slug_length = 25;
var gbook_dir = $('~/Library/Mobile Documents/com~apple~CloudDocs/Garbage Book').stringByExpandingTildeInPath.js;
var annoying_characters = /[\\:\/\*\?"<>\|#%\$;\?\n]/g;

var bb = Application('BBEdit');
var frontDocument = bb.textDocuments[0]

var firstLine = frontDocument.text.lines[0].contents();
var slug = firstLine.substring(0, slug_length).replace(annoying_characters, '_').replace(/[ _\.]+$/, '');

var now = new Date();
var year = now.getFullYear().toString(); // can't has strftime??
var month = (now.getMonth() + 1).toString().padStart(2, '0'); // WHY WOULD YOU ZERO-INDEX MONTH
var day = now.getDate().toString().padStart(2, '0'); // obviously getDay is weekday, obviously
var hour = now.getHours().toString().padStart(2, '0');
var minute = now.getMinutes().toString().padStart(2, '0');
var timestamp = year + '.' + month + '.' + day + ' (' + hour + minute + ')';

var newName = gbook_dir + '/' + timestamp + ' ' + slug + '.txt';

bb.save(frontDocument, {to: Path(newName)}); // JS scripts get to avoid the whole file/alias/POSIX path chaos and just use Path(/posix-y/path).