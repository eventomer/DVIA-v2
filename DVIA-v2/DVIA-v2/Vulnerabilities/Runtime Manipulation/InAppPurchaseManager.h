//
//  InAppPurchaseManager.h
//  DVIA-v2
//
//  Created by Tomer Even on 12/06/2022.
//  Copyright © 2022 HighAltitudeHacks. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface InAppPurchaseManager : NSObject
+ (instancetype)sharedManager;
- (BOOL)hasItemBeenPurchased:(NSString *)itemId;
@end

NS_ASSUME_NONNULL_END
