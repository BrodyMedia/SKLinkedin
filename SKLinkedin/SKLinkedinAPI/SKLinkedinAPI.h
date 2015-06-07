//
//  SKLinkedinAPI.h
//  SKLinkedin
//
//  Created by Adit Hasan on 2/17/15.
//  Copyright (c) 2015 Adit Hasan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface SKLinkedinAPI : UIViewController

typedef void(^validAccessToken)(NSString *token);
typedef void(^completionLinkedinBlock)(NSDictionary *response);
typedef void(^failureLinkedinBlock) (NSDictionary *response);


+ (SKLinkedinAPI*) ShareInstance;
- (void)requestMeWithToken:(completionLinkedinBlock)handler failure:(failureLinkedinBlock)failhandle;
- (void)requestProfileDetailWithToken:(completionLinkedinBlock)handler failure:(failureLinkedinBlock)failhandle;
- (void)requestAllInfoWithToken:(completionLinkedinBlock)handler failure:(failureLinkedinBlock)failhandle;
- (void)requestAllConnectionsWithToken:(completionLinkedinBlock)handler failure:(failureLinkedinBlock)failhandle;
- (void)SharePostToLinkedin:(NSDictionary*)parameter completion:(completionLinkedinBlock)handler failure:(failureLinkedinBlock)failhandle;
@end
