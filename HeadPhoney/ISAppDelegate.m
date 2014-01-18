//
//  ISAppDelegate.m
//  Headphoney. It better be genuine
//
//  Created by Patrick Robertson on 18/01/2014.
//  Copyright (c) 2014 Patrick Robertson. All rights reserved.
//

#import "ISAppDelegate.h"
#import <CoreAudio/CoreAudio.h>

@implementation ISAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    AudioDeviceID defaultDevice = 0;
    UInt32 defaultSize = sizeof(AudioDeviceID);
    
    const AudioObjectPropertyAddress defaultAddr = {
        kAudioHardwarePropertyDefaultOutputDevice,
        kAudioObjectPropertyScopeGlobal,
        kAudioObjectPropertyElementMaster
    };
    
    AudioObjectGetPropertyData(kAudioObjectSystemObject, &defaultAddr, 0, NULL, &defaultSize, &defaultDevice);
    
    AudioObjectPropertyAddress sourceAddr;
    sourceAddr.mSelector = kAudioDevicePropertyDataSource;
    sourceAddr.mScope = kAudioDevicePropertyScopeOutput;
    sourceAddr.mElement = kAudioObjectPropertyElementMaster;
    
    AudioObjectAddPropertyListenerBlock(defaultDevice, &sourceAddr, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(UInt32 inNumberAddresses, const AudioObjectPropertyAddress *inAddresses) {
        UInt32 bDataSourceId = 0;
        UInt32 bDataSourceIdSize = sizeof(UInt32);
        AudioObjectGetPropertyData(defaultDevice, inAddresses, 0, NULL, &bDataSourceIdSize, &bDataSourceId);
        if (bDataSourceId == 'ispk') {
            // Recognized as internal speakers
            NSLog(@"Headphones removed");
        } else if (bDataSourceId == 'hdpn') {
            // Recognized as headphones
            NSLog(@"Headphones inserted");
            
        }
    });
}

@end
