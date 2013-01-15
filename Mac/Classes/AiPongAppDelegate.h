//
//  AiPongAppDelegate.h
//  AiPong
//
//  Created by Jussi Enroos on 12.1.2013.
//  Copyright __MyCompanyName__ 2013. All rights reserved.
//

#import "cocos2d.h"

@interface AiPongAppDelegate : NSObject <NSApplicationDelegate>
{
	NSWindow	*window_;
	MacGLView	*glView_;
}

@property (assign) IBOutlet NSWindow	*window;
@property (assign) IBOutlet MacGLView	*glView;

- (IBAction)toggleFullScreen:(id)sender;

@end
