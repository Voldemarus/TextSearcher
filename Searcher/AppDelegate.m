//
//  AppDelegate.m
//  Searcher
//
//  Created by Водолазкий В.В. on 20/05/2019.
//  Copyright © 2019 Geomatix Laboratory S.R.O. All rights reserved.
//

#import "AppDelegate.h"
#import "NSWindow+CanBecameKeyWindow.h"

#import "Definitions.h"

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
	[NSApp setActivationPolicy: NSApplicationActivationPolicyAccessory];
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

	
	BOOL themeIsLight = [self appearanceIsDark];
	NSColor *placeHolderColor = (themeIsLight ?  [NSColor colorWithRed:0.4 green:0.4 blue:1.0 alpha:1.0] :
								 [NSColor colorWithRed:0.8 green:0.8 blue:1.0 alpha:1.0] );
	
	[[tf cell] setBackgroundColor:[NSColor clearColor]];
	tf.drawsBackground = NO;
	CALayer *l = tf.layer;
	NSColor *backColor = (themeIsLight ? LIGHT_THEME_TEXTFIELD_BACKGROUND : DARK_THEME_TEXTFIELD_BACKGROUND);
	[l setBackgroundColor:backColor.CGColor];
	NSDictionary *blueDict = @{
							   NSForegroundColorAttributeName : placeHolderColor,
							   };
	NSAttributedString *blueString = [[NSAttributedString alloc]
		initWithString: NSLocalizedString(@"Search in Finder for...",@"")
									   attributes: blueDict];
	[[tf cell] setPlaceholderAttributedString: blueString];
	
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

#ifdef PERSCENTAGE_PROCESSING
	stringToSearch  = [stringToSearch stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet alphanumericCharacterSet]];
#endif
	
	BOOL opened = [[NSWorkspace sharedWorkspace] showSearchResultsForQueryString:stringToSearch];
#pragma unused (opened)
}

#pragma mark - Theme mode support

- (BOOL) appearanceIsDark
{
	NSAppearance *appearance = NSAppearance.currentAppearance;
	if (@available(macOS 10.14, *)) {
		NSString *basicAppearance =
			[appearance bestMatchFromAppearancesWithNames:@[
							NSAppearanceNameAqua,
							NSAppearanceNameDarkAqua
		]];
		return [basicAppearance isEqualToString:NSAppearanceNameDarkAqua];
	} else {
		return NO;
	}
}

@end
