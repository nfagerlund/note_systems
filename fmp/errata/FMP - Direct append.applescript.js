var app = Application.currentApplication(); // Should be FastScripts
app.includeStandardAdditions = true;

var fmp_dir = $('~/Library/Mobile Documents/com~apple~CloudDocs/Lists').stringByExpandingTildeInPath.js; // $(string) makes an NSString; have to access its .js property to get a javascript string.
var dump_tag = 'fiend';

var result = app.displayDialog("Append text to FMP; use ^caret-tags to choose a file", {defaultAnswer: '', withTitle: 'Enter some text', buttons: ["Cancel", "Append and open", "Append"], defaultButton: "Append"});

if (result.buttonReturned == 'Append' || result.buttonReturned == 'Append and open') {
	var caretNote = result.textReturned.match(/^\^([\w\-]+) (.*)$/);
	if (caretNote) {
		var tag = caretNote[1];
		var note = caretNote[2];
	}
	else {
		var tag = dump_tag;
		var note = result.textReturned;
	}
	var file = fmp_dir + '/' + tag + '.txt';
	
	var fm = $.NSFileManager.defaultManager;
	
	if (!( fm.fileExistsAtPath( $(file) ) )) {
		fm.createFileAtPathContentsAttributes( $(file), $(), $() ); // $() with no arguments makes a nil object.
	}
	
	var fh = $.NSFileHandle.fileHandleForWritingAtPath( $(file) );
	fh.seekToEndOfFile;
	fh.writeData( $( note.replace(/ +\/\/ +/g, "\n") + "\n" ).dataUsingEncoding($.NSUTF8StringEncoding) ); // writeData requires an NSData object, so we have to convert text to an NSString with $() and then convert it to NSData (which needs a specified encoding, accessible by name as a constant in the objc runtime).
	fh.closeFile;
}

if (result.buttonReturned == 'Append and open') {
	var bb = Application('BBEdit');
	bb.activate();
	bb.open(file);
}

