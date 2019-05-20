//
//  AppDelegate.m
//  Searcher
//
//  Created by Водолазкий В.В. on 20/05/2019.
//  Copyright © 2019 Geomatix Laboratory S.R.O. All rights reserved.
//

#import "AppDelegate.h"
#import "NSWindow+CanBecameKeyWindow.h"

double const StatusItemLength = 280.0;
double const StatusItemHeight = 28.0;

@interface AppDelegate () <NSTextFieldDelegate>
{
	NSStatusItem *statusItem;
	NSTextField *tf;
}

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	
	[self setupStatusBar];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
	// Insert code here to tear down your application
}

#pragma mark -

- (void) setupStatusBar
{
	if (!statusItem) {
		statusItem = [[NSStatusBar systemStatusBar]
		   statusItemWithLength:NSVariableStatusItemLength];
	}
	// Wrapper for statusItem content
	NSView *searchView = [[NSView alloc] initWithFrame:CGRectMake(0, 0, StatusItemLength, StatusItemHeight)];
	NSButton *button = [[NSButton alloc] initWithFrame:CGRectMake(StatusItemLength -  StatusItemHeight, 0, StatusItemHeight-8, StatusItemHeight -8)];
	[button setImage:[NSImage imageNamed:@"ButtonIcon"]];
	[button setTarget:self];
	[button setAction:@selector(processButtonClick:)];
	[searchView addSubview:button];
	
	tf = [[NSTextField alloc] initWithFrame:CGRectMake(0, 2, StatusItemLength -  StatusItemHeight - 7.0, StatusItemHeight-10.0)];
	tf.bezelStyle = NSTextFieldRoundedBezel;
	tf.bezeled = YES;
	tf.backgroundColor = [NSColor whiteColor];
	tf.placeholderString = NSLocalizedString(@"Search in Finder for...",@"");
	tf.delegate = self;
	[searchView addSubview:tf];
	[tf becomeFirstResponder];
	
	statusItem.view = searchView;
}


-(void)controlTextDidEndEditing:(NSNotification *)notification
{
	// See if it was due to a return
	if ( [[[notification userInfo] objectForKey:@"NSTextMovement"] intValue] == NSReturnTextMovement )	{
		[self processButtonClick:nil];
	}
}



- (void) processButtonClick:(id) sender
{
	NSString *stringToSearch = tf.stringValue;
//	NSLog(@"Button clicked -- %@", stringToSearch);

	BOOL opened = [[NSWorkspace sharedWorkspace] showSearchResultsForQueryString:stringToSearch];
//	NSLog(@"opened = %hhd", opened);
//	return;

//	NSString *scriptSourece = [NSString stringWithFormat:@""
//				@"use AppleScript version\"2.4\"\n"
//				@"use framework \"Foundation\"\n"
//				@"use framework \"AppKit\"\n"
//				@"use scripting additions\n"
//				@"set theWord to \"%@\"\n"
//							   @"tell application \"Finder\" to «event aevtspot» theWord\n"
//								  ,stringToSearch];
//	NSLog(@"script - %@", scriptSourece);
//	NSAppleScript *script = [[NSAppleScript alloc] initWithSource:scriptSourece];
//	if (script) {
//		NSDictionary *errorInfo = nil;
//		NSAppleEventDescriptor *success = [script executeAndReturnError:&errorInfo];
//#pragma unused (success)
//		if (errorInfo) {
//			NSLog(@"error - %@",errorInfo);
//		}
//	}
}


@end
