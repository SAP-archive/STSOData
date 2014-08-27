//
//  ODataStore.h
//  Template
//
//  Created by Stadelman, Stan on 8/20/14.
//  Copyright (c) 2014 Stan Stadelman. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ODataStore <NSObject>

@required
- (void) openStoreWithCompletion:(void(^)(BOOL success))completion;

@optional
- (void) flushAndRefresh:(void(^)(BOOL success))completion;
@end
