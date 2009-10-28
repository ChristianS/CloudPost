//
//  CPStatusViewController.h
//  CloudPost
//
//  Created by Christian Stropp on 26.08.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface CPStatusViewController : NSViewController {
	IBOutlet NSProgressIndicator *progressBar;
	IBOutlet NSTextField *successImage;
	IBOutlet NSTextField *errorImage;
	
	Boolean finishedSuccessfully;
}
@property (readonly) Boolean finishedSuccessfully;

- (void)showProgressBar;
- (void)setProgress:(double)progress;
- (void)finishSuccessful:(BOOL)success;

@end
