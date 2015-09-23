# Playlist-test

Testing local-file and remote .m3u8 playlists on iOS9.

1. Build and run on an iOS9 device or simulator
2. Click the buttons and follow the debug console

Both playlists play fine on iOS8; on iOS9, the "Play remote playlist" streams the playlist correctly, but "Play local playlist" button will cause an AVPlayerItemStatusFailed AVPlayerItem status, and throw this error:

    Error Domain=AVFoundationErrorDomain Code=-11800 "The operation could not be completed"
    UserInfo={NSUnderlyingError=0x7ff63900d120 {Error Domain=NSOSStatusErrorDomain Code=-16910 
    "(null)"}, NSLocalizedFailureReason=An unknown error occurred (-16910), 
    NSLocalizedDescription=The operation could not be completed}
