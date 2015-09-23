//
//  ViewController.h
//  Playlist test
//
//  Created by David Reese on 9/22/15.
//  Copyright © 2015 David Reese. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface ViewController : UIViewController

@property(strong, nonatomic) AVQueuePlayer *queuePlayer;


@end