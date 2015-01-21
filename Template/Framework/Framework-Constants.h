//
//  Framework-Constants.h
//  Template
//
//  Created by Stadelman, Stan on 8/19/14.
//  Copyright (c) 2014 Stan Stadelman. All rights reserved.
//

#ifndef Template_Framework_Constants_h
#define Template_Framework_Constants_h

/*
 Internal
 */
#define kStoreOpenFinished          @"com.sap.sdk.store.open.finished"
#define kStoreOpenDelegateFinished  @"com.sap.sdk.store.open.delegate.finished"
#define kStoreOpenDelegateFailed    @"com.sap.sdk.store.open.delegate.failed"
#define kRequestFinished            @"com.sap.sdk.request.finished"
#define kRequestDelegateFinished    @"com.sap.sdk.request.delegate.finished"
#define kRequestDelegateFailed      @"com.sap.sdk.request.delegate.failed"
#define kLogonFinished              @"com.sap.sdk.logon.finished"

#define kOnlineStoreConfigured      @"com.sap.sdk.store.online.configured"
#define kOfflineStoreConfigured     @"com.sap.sdk.store.offline.configured"
#define kStoreConfigured            @"com.sap.sdk.store.configured"

#define kFlushDelegateFinished      @"com.sap.sdk.store.flush.delegate.finished"
#define kRefreshDelegateFinished    @"com.sap.sdk.store.refresh.delegate.finished"
#define kFlushDelegateFailed        @"com.sap.sdk.store.flush.delegate.failed"
#define kRefreshDelegateFailed      @"com.sap.sdk.store.refresh.delegate.failed"

/*
 notification for SODataOfflineStore flush & refresh state change:
 recommended for user-facing UI
 */
#define kSODataOfflineStoreFlushRefreshStateChange   @"com.sap.sdk.store.offline.flushRefreshChange"

#define kSODataOfflineStoreFlushStartedText     @"Uploading local changes to server"
#define kSODataOfflineStoreFlushFinishedText    @"Finished uploading local changes"
#define kSODataOfflineStoreRefreshStartedText   @"Downloading updates from server"
#define kSODataOfflineStoreRefreshFinishedText  @"Finished downloading updates"

/*
 Logger constants may be reused, or added-to
 */
#pragma mark - Logger Constants
#define LOG_ONLINESTORE     @"com.sap.sdk.log.store.online"
#define LOG_OFFLINESTORE    @"com.sap.sdk.log.store.offline"
#define LOG_ODATAREQUEST    @"com.sap.sdk.log.sodatarequest"
#define LOG_LOGUPLOAD       @"com.sap.sdk.log.logupload"

/*
 Internal
 */
typedef NS_ENUM(NSInteger, WorkingModes) {
    WorkingModeUnset,
    WorkingModeOnline,
    WorkingModeOffline,
    WorkingModeMixed
};

#endif
