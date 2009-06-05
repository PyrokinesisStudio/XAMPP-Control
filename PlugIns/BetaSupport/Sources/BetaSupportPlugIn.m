/*
 
 XAMPP
 Copyright (C) 2009 by Apache Friends
 
 Authors of this file:
 - Christian Speich <kleinweby@apachefriends>
 
 This file is part of XAMPP.
 
 XAMPP is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.
 
 XAMPP is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with XAMPP.  If not, see <http://www.gnu.org/licenses/>.
 
 */

#import "BetaSupportPlugIn.h"
#import "BetaFeedbackController.h"
#import <XAMPP Control/XAMPP Control.h>

@interface BetaSupportPlugIn(PRIVAT)

- (void) setFeedbackController:(BetaFeedbackController*)controller;
- (BetaFeedbackController*) feedbackController;

- (void) costumizeMainMenu;
- (void) costumizeAboutWindow:(NSDictionary*)dict;
- (void) costumizeControlsWindow:(NSDictionary*)dict;

@end


@implementation BetaSupportPlugIn

- (id) init
{
	self = [super init];
	if (self != nil) {
		[self setFeedbackController:[[BetaFeedbackController new] autorelease]];
	}
	return self;
}

- (void) dealloc
{
	[self setFeedbackController:Nil];
	
	[super dealloc];
}

- (void) setFeedbackController:(BetaFeedbackController*)controller
{
	if ([controller isEqualTo:_feedbackController])
		return;
	
	[_feedbackController release];
	_feedbackController = [controller retain];
}

- (BetaFeedbackController*) feedbackController
{
	return _feedbackController;
}

- (BOOL) setupError:(NSError**)anError
{
	PlugInRegistry* reg = [[PlugInManager sharedPlugInManager] registry];
	
	[reg registerTarget:self 
		   withSelector:@selector(costumizeControlsWindow:) 
				forHook:ControlsWindowDidLoadHook];
	[reg registerTarget:self 
		   withSelector:@selector(costumizeAboutWindow:) 
				forHook:AboutWindowSetupHook];
	
	[self costumizeMainMenu];
	
	return YES;
}

- (void) costumizeControlsWindow:(NSDictionary*)dict
{
	id superview = [[[dict objectForKey:HookWindowKey] standardWindowButton:NSWindowCloseButton] superview];
	NSRect frame;
	NSButton* betaButton = [[NSButton alloc] initWithFrame:NSMakeRect(0.f, 0.f, 50.f, 17.f)];
	
	[betaButton setButtonType:NSMomentaryPushInButton];
	//[betaButton setImagePosition:NSNoImage];
	//[betaButton setBordered:YES];
	[betaButton setShowsBorderOnlyWhileMouseInside:YES];
	[[betaButton cell] setControlSize:NSSmallControlSize];
	[betaButton setBezelStyle:NSRecessedBezelStyle];
	[betaButton setTitle:@"Beta!"];
	
	[betaButton setTarget:[self feedbackController]];
	[betaButton setAction:@selector(showWindow:)];
	
	frame.size = [betaButton frame].size;
	frame.origin.y = NSHeight([superview frame]) - NSHeight(frame) - 4.f;
	frame.origin.x = NSMaxX([superview frame]) - frame.size.width - 5.f;
	[betaButton setFrame:frame];
	[betaButton setToolTip:@"You have an Beta Version of XAMPP. Please send us Feedback."];
	[superview addSubview:betaButton];
	
	NSLog(@"%@", [betaButton attributedTitle]);
	
	NSMutableAttributedString* string = [[betaButton attributedTitle] mutableCopy];
	[string addAttributes:[NSDictionary dictionaryWithObject:[NSColor colorWithCalibratedRed:1.f green:50.f/255.f blue:0.f alpha:1.f] forKey:@"NSColor"]
					range:NSMakeRange(0, [string length])];
//	[string addAttributes:[NSDictionary dictionaryWithObject:[NSFont boldSystemFontOfSize:[NSFont systemFontSizeForControlSize:NSSmallControlSize]] forKey:@"NSFont"]
//					range:NSMakeRange(0, [string length])];
	[betaButton setAttributedTitle:string];
	NSLog(@"%@", [betaButton attributedTitle]);
	
	NSLog(@"frame %@ betaButton %@", NSStringFromRect(frame), betaButton);
	NSLog(@"frame %@", NSStringFromRect([superview frame]));
}

- (void) costumizeAboutWindow:(NSDictionary*)dict
{
	NSMutableAttributedString* XAMPPLabel = [dict objectForKey:HookXAMPPLabelKey];
	NSMutableAttributedString* BetaPart = [[NSMutableAttributedString alloc] initWithString:@"Beta"];

	[BetaPart addAttribute:NSForegroundColorAttributeName 
					 value:[NSColor redColor] 
					 range:NSMakeRange(0, [BetaPart length])];
	[BetaPart addAttribute:NSObliquenessAttributeName 
					 value:[NSNumber numberWithFloat:0.3] 
					 range:NSMakeRange(0, [BetaPart length])];
	[BetaPart addAttribute:NSFontAttributeName 
					 value:[NSFont boldSystemFontOfSize:12.f] 
					 range:NSMakeRange(0, [BetaPart length])];
 
	[XAMPPLabel appendAttributedString:BetaPart];
	
	[BetaPart release];
}

- (void) costumizeMainMenu
{
	NSMenu *helpMenu;
	NSMenuItem *menuItem;
	
	helpMenu = [[[NSApp mainMenu] itemWithTag:6] submenu];
	
	if (!helpMenu) {
		NSLog(@"Can't find the Help Menu!");
	}
		
	menuItem = [helpMenu itemWithTag:3];
	[menuItem setTarget:[self feedbackController]];
	[menuItem setAction:@selector(showWindow:)];
}

@end
