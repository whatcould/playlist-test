//
//  ViewController.m
//  Playlist test
//
//  Created by David Reese on 9/22/15.
//  Copyright © 2015 David Reese. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

  @synthesize queuePlayer;


- (void)viewDidLoad {
  [super viewDidLoad];
  [self initPlayer];
}

- (void) initPlayer {
  // set up the audio player
  // Set AudioSession
  NSError *sessionError = nil;
  [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&sessionError];
 
  queuePlayer = [[AVQueuePlayer alloc] init];
  queuePlayer.actionAtItemEnd = AVPlayerActionAtItemEndAdvance; // Seems to be the default
  
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (IBAction)playLocalPlaylist:(id)sender {

  // Write a playlist file to disk; this string is identical to the remote version referenced below
  NSString *playlistString = @"#EXTM3U\n\
#EXT-X-STREAM-INF:PROGRAM-ID=1, BANDWIDTH=200000\n\
http://devimages.apple.com/iphone/samples/bipbop/gear1/prog_index.m3u8\n\
#EXT-X-STREAM-INF:PROGRAM-ID=1, BANDWIDTH=311111\n\
http://devimages.apple.com/iphone/samples/bipbop/gear2/prog_index.m3u8\n\
#EXT-X-STREAM-INF:PROGRAM-ID=1, BANDWIDTH=484444\n\
http://devimages.apple.com/iphone/samples/bipbop/gear3/prog_index.m3u8\n\
#EXT-X-STREAM-INF:PROGRAM-ID=1, BANDWIDTH=737777\n\
http://devimages.apple.com/iphone/samples/bipbop/gear4/prog_index.m3u8";
  
  NSLog(playlistString);
  NSError *error = nil;
  [[playlistString dataUsingEncoding:NSUTF8StringEncoding] writeToFile:self.playlistFilename options:NSDataWritingFileProtectionNone error:&error];
  if(queuePlayer.items.count != 0) {
    [queuePlayer pause];
    AVPlayerItem *currentPlayerItem = queuePlayer.items.firstObject;
    [currentPlayerItem removeObserver:self forKeyPath:@"status" context:nil];
    [queuePlayer removeAllItems];
  }
  AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:[NSURL fileURLWithPath:self.playlistFilename]];
  [playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:nil];
  
  dispatch_async(dispatch_get_main_queue(), ^{
    [queuePlayer insertItem:playerItem afterItem:nil];
  });

}



- (NSString*) documentsDirectory {
  // Documents directory
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  return [paths objectAtIndex:0];
}

- (NSString *)playlistFilename {
  NSString *playlistFile = [NSString stringWithFormat:@"%@/bipbopall.m3u8", self.documentsDirectory];
  return playlistFile;
}

- (IBAction)playRemotePlaylist:(id)sender {
  
  if(queuePlayer.items.count == 0) {
     NSURL *url = [NSURL URLWithString:@"http://whatcould.com/playlists/bipbopall.m3u8"];
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:url];
    [playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:nil];
    
    dispatch_async(dispatch_get_main_queue(), ^{
      [queuePlayer insertItem:playerItem afterItem:nil];
    });
  }
  else {
    NSLog(@"Already playing...");
  }

}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                        change:(NSDictionary *)change context:(void *)context {

  AVPlayerStatus status = [[change objectForKey:NSKeyValueChangeNewKey] integerValue];

  switch (status) {
      /* Indicates that the status of the player is not yet known because
       it has not tried to load new media resources for playback */
    case AVPlayerItemStatusUnknown:
    {
      NSLog(@"Player item status unknown");
    }
      break;
      
    case AVPlayerItemStatusReadyToPlay:
    {
      NSLog(@"Player item status readyToPlay");
      dispatch_async(dispatch_get_main_queue(), ^{
        [queuePlayer play];
      });
    }
      break;
      
    case AVPlayerItemStatusFailed:
    {
      AVPlayerItem *thePlayerItem = (AVPlayerItem *) object;
      NSLog(@"AVPlayerStatusFailed... %@, %@", thePlayerItem, thePlayerItem.error);
      [thePlayerItem removeObserver:self forKeyPath:@"status" context:nil];
    }
      break;
  }
}@end
