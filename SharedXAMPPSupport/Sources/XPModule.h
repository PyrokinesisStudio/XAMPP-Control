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

#import <Cocoa/Cocoa.h>
#import "XPStatus.h"

@interface XPModule : NSObject {
	NSTimer *checkTimer;
	NSString *pidFile;
	XPStatus status;
	bool working;
	
	int watchDirFD;
	int watchPID;
}

// The Name of the Module
- (NSString*) name;

- (NSString*) pidFile;
- (void) setPidFile:(NSString*)aPidFile;

// The method is called on an seperate thread
// returns an NSError or nil if no error happens
- (NSError*) start;
- (NSError*) stop;
- (NSError*) reload;

- (XPStatus) status;
- (void) setStatus:(XPStatus) aStatus;

- (void) checkFixRightsAndRunIfNeeded;

- (void) refreshStatusCheck;
- (void) removeStatusCheck;
- (void) setupStatusCheck;

@end
