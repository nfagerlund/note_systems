// Save the front BBEdit document with an auto-generated filename
var slugLength = 25;
var gbookDir = $("~/Library/Mobile Documents/com~apple~CloudDocs/Garbage Book").stringByExpandingTildeInPath.js;
var annoyingCharacters = /[\\:\/\*\?"<>\|#%\$;\n\r]+/g;
var trailingJunk = /[ _\.]+$/;

var bb = Application("BBEdit");
var frontDocument = bb.textDocuments[0];

var firstLine = frontDocument.text.lines[0].contents();
var slug = firstLine.replace(annoyingCharacters, "_").substring(0, slugLength).replace(trailingJunk, "");

var timestamp = (() => {
	let now = new Date();
	let year = now.getFullYear().toString(); // can't has strftime??
	let month = (now.getMonth() + 1).toString().padStart(2, "0"); // WHY WOULD YOU ZERO-INDEX MONTH
	let day = now.getDate().toString().padStart(2, "0"); // obviously getDay is weekday, obviously
	let hour = now.getHours().toString().padStart(2, "0");
	let minute = now.getMinutes().toString().padStart(2, "0");

	return `${year}.${month}.${day} (${hour}${minute})`;
})();

var newName = `${gbookDir}/${timestamp} ${slug}.txt`;

bb.save(frontDocument, {to: Path(newName)}); // JS scripts get to avoid the whole file/alias/POSIX path chaos and just use Path(/posix-y/path).
