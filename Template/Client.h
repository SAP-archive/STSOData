//
//  Client.h
//  Usage Prototype
//
//  Created by Stadelman, Stan on 3/7/14.
//  Copyright (c) 2014 Stan Stadelman. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OnlineStore;


@interface Client : NSObject

@property (nonatomic, strong) OnlineStore *onlineStore;

+(instancetype)sharedClient;


@end
