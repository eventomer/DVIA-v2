//
//  InAppPurchaseManager.m
//  DVIA-v2
//
//  Created by Tomer Even on 12/06/2022.
//  Copyright © 2022 HighAltitudeHacks. All rights reserved.
//

#import "InAppPurchaseManager.h"

@interface InAppPurchaseManager()
@property (nonatomic, strong) NSString *base64Secret;
@end

@implementation InAppPurchaseManager

+ (instancetype)sharedManager {
    static InAppPurchaseManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [self new];
    });
    return sharedMyManager;
}

- (instancetype)init {
  if (self = [super init]) {
      _base64Secret = @"c2VjcmV0LXVubG9jay1jb2Rl";
  }
  return self;
}

- (BOOL)hasItemBeenPurchased:(NSString *)itemId {
    NSString *unlockCode = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"webos.products.%@", itemId]] ?: @"";
    NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:self.base64Secret options:0];
    NSString *decodedString = [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];
    return [decodedString isEqualToString:unlockCode];
}

@end
