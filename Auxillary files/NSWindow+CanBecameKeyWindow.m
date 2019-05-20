//
//  NSWindow+CanBecameKeyWindow.m
//  Searcher
//
//  Created by Водолазкий В.В. on 20/05/2019.
//  Copyright © 2019 Geomatix Laboratory S.R.O. All rights reserved.
//

#import "NSWindow+CanBecameKeyWindow.h"

@implementation NSWindow (canBecomeKeyWindow)

//This is to fix a bug with 10.7 where an NSPopover with a text field cannot be edited if its parent window won't become key
//The pragma statements disable the corresponding warning for overriding an already-implemented method
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"
- (BOOL)canBecomeKeyWindow
{
	return YES;
}
#pragma clang diagnostic pop

@end
