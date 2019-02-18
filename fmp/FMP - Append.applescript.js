var app = Application.currentApplication(); // Should be FastScripts
app.includeStandardAdditions = true;

var fiend = $('~/Library/Mobile Documents/com~apple~CloudDocs/Lists/fiend.txt').stringByExpandingTildeInPath; // this is an NSString; have to access its .js property to get a javascript string.

var result = app.displayDialog("Append text to " + fiend.js, {defaultAnswer: '', withTitle: 'Enter some text', buttons: ["Cancel", "Append and open", "Append"], defaultButton: "Append"}); // If you cancel, execution stops here.

var fh = $.NSFileHandle.fileHandleForWritingAtPath(fiend);
fh.seekToEndOfFile;
fh.writeData( $( result.textReturned + "\n" ).dataUsingEncoding($.NSUTF8StringEncoding) ); // writeData requires an NSData object, so we have to convert text to an NSString with $() and then convert it to NSData (which needs a specified encoding, accessible by name as a constant in the objc runtime).
fh.closeFile;

if (result.buttonReturned == 'Append and open') {
	var bb = Application('BBEdit');
	bb.activate();
	bb.open(fiend.js);
}
