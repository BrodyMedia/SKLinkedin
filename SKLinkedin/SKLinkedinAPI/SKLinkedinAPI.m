//
//  SKLinkedinAPI.m
//  SKLinkedin
//
//  Created by Adit Hasan on 2/17/15.
//  Copyright (c) 2015 Adit Hasan. All rights reserved.
//

#import "SKLinkedinAPI.h"
#import "AppDelegate.h"
#import "AFHTTPRequestOperation.h"
#import "LIALinkedInHttpClient.h"
#import "LIALinkedInApplication.h"

#import "APIKeyHeader.h"




@implementation SKLinkedinAPI


+ (SKLinkedinAPI*) ShareInstance{

    static SKLinkedinAPI *shareobj = nil;
    static dispatch_once_t once;
    
  
   dispatch_once(&once,^{
 
        shareobj = [[SKLinkedinAPI alloc]init];
       
    });

    return shareobj;
}

-(void)getAccessToken:(validAccessToken)handler{
    static NSString *accessToken = nil;
    
    @synchronized(accessToken){
    
  
    if(accessToken!=nil){
    
     handler(accessToken);
        
    } else {
    
        [self.client getAuthorizationCode:^(NSString *code) {
        
        
        [self.client getAccessToken:code success:^(NSDictionary *accessTokenData) {
            
            accessToken = [accessTokenData objectForKey:@"access_token"];
            
            handler(accessToken);
            
        }
        failure:^(NSError *error) {
        
            NSLog(@"Quering accessToken failed %@", error);
        }];
    
        } cancel:^{
        NSLog(@"Authorization was cancelled by user");
    }                     failure:^(NSError *error) {
        NSLog(@"Authorization failed %@", error);
    }];
    
}
    
          }
}
- (void)requestMeWithToken:(completionLinkedinBlock)handler failure:(failureLinkedinBlock)failhandle{
    // _client = [self client];
    [self getAccessToken:^(NSString *token) {
  
       
    NSOperationQueue *networkQueue = [[NSOperationQueue alloc] init];
    networkQueue.maxConcurrentOperationCount = 5;
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.linkedin.com/v1/people/~?format=json&oauth2_access_token=%@", token]];

    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:NULL];
        
       
        
        handler([NSDictionary dictionaryWithObjectsAndKeys:@"1",@"success",dictionary,@"data", nil]);
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%s: AFHTTPRequestOperation error: %@", __FUNCTION__, error);
         failhandle([NSDictionary dictionaryWithObjectsAndKeys:@"0",@"success", nil]);
    }];
    [networkQueue addOperation:operation];
    
        
}];
}


- (void)requestProfileDetailWithToken:(completionLinkedinBlock)handler failure:(failureLinkedinBlock)failhandle{
    
    [self getAccessToken:^(NSString *token) {
         
    NSOperationQueue *networkQueue = [[NSOperationQueue alloc] init];
    networkQueue.maxConcurrentOperationCount = 5;
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.linkedin.com/v1/people/~:(id,num-connections,picture-url)?format=json&oauth2_access_token=%@", token]];
    
    NSLog(@"%@",url);
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:NULL];
        //NSLog(@"%@", dictionary);
        
              handler([NSDictionary dictionaryWithObjectsAndKeys:@"1",@"success",dictionary,@"data", nil]);
        
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    NSLog(@"%s: AFHTTPRequestOperation error: %@", __FUNCTION__, error);
         failhandle([NSDictionary dictionaryWithObjectsAndKeys:@"0",@"success", nil]);
    }];
    [networkQueue addOperation:operation];
         
         
    }];
    
}

//Retrive different type of Information from profile

- (void)requestAllInfoWithToken:(completionLinkedinBlock)handler failure:(failureLinkedinBlock)failhandle{
    
     [self getAccessToken:^(NSString *token) {
    
    NSOperationQueue *networkQueue = [[NSOperationQueue alloc] init];
    networkQueue.maxConcurrentOperationCount = 5;
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.linkedin.com/v1/people/~:(id,first-name,skills,educations,languages,twitter-accounts)?format=json&oauth2_access_token=%@", token]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:NULL];
      
        handler([NSDictionary dictionaryWithObjectsAndKeys:@"1",@"success",dictionary,@"data", nil]);
        
        
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
   
        NSLog(@"%s: AFHTTPRequestOperation error: %@", __FUNCTION__, error);
     failhandle([NSDictionary dictionaryWithObjectsAndKeys:@"0",@"success", nil]);
    }];
         
    [networkQueue addOperation:operation];
    
     }];
    
}

//Share Post To your Home
- (void)SharePostToLinkedin:(NSDictionary*)parameter completion:(completionLinkedinBlock)handler failure:(failureLinkedinBlock)failhandle {
    
    [self getAccessToken:^(NSString *token) {
    
    NSString *url = [NSString stringWithFormat:@"https://api.linkedin.com/v1/people/~/shares?format=json&oauth2_access_token=%@",token];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    
    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [requestSerializer setValue:@"json" forHTTPHeaderField:@"x-li-format"];
    
    manager.requestSerializer = requestSerializer;
    

    
    
    [manager POST:url parameters:parameter
          success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"JSON: %@", responseObject);
         
         NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:NULL];
         
             handler([NSDictionary dictionaryWithObjectsAndKeys:@"1",@"success",dictionary,@"data", nil]);
         
     }
          failure:
     ^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"Error: %@", error);
         
         failhandle([NSDictionary dictionaryWithObjectsAndKeys:@"0",@"success", nil]);
     }];
    
    }];
}




- (void)requestAllConnectionsWithToken:(completionLinkedinBlock)handler failure:(failureLinkedinBlock)failhandle{
    
    [self getAccessToken:^(NSString *token) {
        
        NSOperationQueue *networkQueue = [[NSOperationQueue alloc] init];
        networkQueue.maxConcurrentOperationCount = 5;
        

        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.linkedin.com/v1/people/~/connections:(id,first-name,last-name,headline,maiden-name,picture-url,formatted-name,location,positions,public-profile-url,specialties,num-connections,industry)?format=json&oauth2_access_token=%@",token]];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:NULL];
            
            NSLog(@"%@",dictionary);
            
            
            handler([NSDictionary dictionaryWithObjectsAndKeys:@"1",@"success",dictionary,@"data", nil]);
            
            
        }
        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                             
        NSLog(@"%s: AFHTTPRequestOperation error: %@", __FUNCTION__, error);
        failhandle([NSDictionary dictionaryWithObjectsAndKeys:@"0",@"success", nil]);
        
        }];
        
        [networkQueue addOperation:operation];
        
    }];
    
}



///////////////////////
- (LIALinkedInHttpClient *)client {
    LIALinkedInApplication *application = [LIALinkedInApplication applicationWithRedirectURL:RedirectURL
                                                                                    clientId:APIKey
                                                                                clientSecret:APISecretKey
                                                                                       state:@"DCEEFWF45453sdffef424"
                                                                               grantedAccess:@[@"r_fullprofile",@"w_share", @"r_network",@"r_basicprofile",@"r_contactinfo"]];
    return [LIALinkedInHttpClient clientForApplication:application presentingViewController:nil];
}


@end
