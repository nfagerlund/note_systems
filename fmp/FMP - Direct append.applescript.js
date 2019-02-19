var app = Application.currentApplication(); // Should be FastScripts
app.includeStandardAdditions = true;

var fmpDir = $("~/Library/Mobile Documents/com~apple~CloudDocs/Lists").stringByExpandingTildeInPath.js; // $(string) makes an NSString; have to access its .js property to get a javascript string.
var dumpTag = "fiend";

var result = app.displayDialog("Append text to FMP; use ^caret-tags to choose a file", {defaultAnswer: "", withTitle: "Enter some text", buttons: ["Cancel", "Append and open", "Append"], defaultButton: "Append"}); // If you cancel, execution stops here.

var caretNote = result.textReturned.match(/^\^([\w\-]+) (.*)$/);
if (caretNote) {
	var tag = caretNote[1].toLowerCase();
	var note = caretNote[2];
}
else {
	var tag = dumpTag;
	var note = result.textReturned;
}
var file = fmpDir + '/' + tag + '.txt';

// Create empty file if it doesn't exist:
var fm = $.NSFileManager.defaultManager;
if (!( fm.fileExistsAtPath( $(file) ) )) {
	fm.createFileAtPathContentsAttributes( $(file), $(), $() ); // $() with no arguments makes a nil object.
}

// Write text to file:
var fh = $.NSFileHandle.fileHandleForWritingAtPath( $(file) );
fh.seekToEndOfFile;
fh.writeData( $( note.replace(/ +\/\/ +/g, "\n") + "\n" ).dataUsingEncoding($.NSUTF8StringEncoding) ); // writeData requires an NSData object, so we have to convert text to an NSString with $() and then convert it to NSData (which needs a specified encoding, accessible by name as a constant in the objc runtime).
fh.closeFile;

if (result.buttonReturned == "Append and open") {
	var bb = Application("BBEdit");
	bb.activate();
	bb.open(file);
}

