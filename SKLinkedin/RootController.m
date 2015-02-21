//
//  ViewController.m
//  SKLinkedin
//
//  Created by Adit Hasan on 2/15/15.
//  Copyright (c) 2015 Adit Hasan. All rights reserved.
//

#import "RootController.h"

@interface RootController ()

@property (weak, nonatomic) IBOutlet UILabel *HeadLine;
@property (weak, nonatomic) IBOutlet UILabel *nameField;
@property (weak, nonatomic) IBOutlet UILabel *connectionlabel;
@property (weak, nonatomic) IBOutlet UIImageView *LinkedinPhoto;
@property (weak, nonatomic) IBOutlet UILabel *FullName;

@end

@implementation RootController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Linkedin";
    self.navigationController.navigationBar.translucent = NO;
}

-(void)viewDidAppear:(BOOL)animated{


  
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)SKLinkedinAction:(id)sender {
    
    
    
    [[SKLinkedinAPI ShareInstance] requestMeWithToken:^(NSDictionary *responsedata) {
        NSDictionary *response = [responsedata valueForKey:@"data"];

        NSLog(@"SKLinkedin API Response - %@",response);
        self.HeadLine.text = [response valueForKey:@"headline"];
        self.nameField.text = [NSString stringWithFormat:@"%@ %@",[response valueForKey:@"firstName"],[response valueForKey:@"lastName"]];
        
    } failure:^(NSDictionary *response) {
        
        
    }];
    
    
 

}

 

-(void)setAsynchronousPhoto:(NSString*)url{


    dispatch_queue_t imageQueue = dispatch_queue_create("ImageQueue", NULL);
    
    dispatch_async(imageQueue, ^{
        
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.LinkedinPhoto.image=[UIImage imageWithData:imageData];
            
        });
        
        
    });
}

- (IBAction)SubmitAction:(id)sender {


    [[SKLinkedinAPI ShareInstance] requestProfileDetailWithToken:^(NSDictionary *responsedata) {
        
        NSDictionary *response = [responsedata valueForKey:@"data"];
        self.connectionlabel.text = [NSString stringWithFormat:@"Total %@ Connections",[response valueForKey:@"numConnections"]];
        [self setAsynchronousPhoto:[response valueForKey:@"pictureUrl"]];
        
    } failure:^(NSDictionary *response) {
        
        
    }];
 
    
}
- (IBAction)LinkedinPortfolio:(id)sender {
    
    
    
    [[SKLinkedinAPI ShareInstance] requestAllInfoWithToken:^(NSDictionary *responsedata) {
        
        NSDictionary *response = [responsedata valueForKey:@"data"];
        NSLog(@"Portfolio - %@",response);
        
    } failure:^(NSDictionary *response) {
        
        
    }];
}

- (IBAction)LinkedinShare:(id)sender {
    
    
    //Share post to linkedin
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:
                            [[NSDictionary alloc] initWithObjectsAndKeys: @"anyone",@"code",nil],  @"visibility",
                            @"Linkedin Share API from iOS Apps", @"comment", [[NSDictionary alloc] initWithObjectsAndKeys:@"description share", @"description",
                                                                              @"https://g.twimg.com/", @"submitted-url",
                                                                              @"title share",@"title",
                                                                              @"https://g.twimg.com/Twitter_logo_blue.png",@"submitted-image-url",nil],
                            @"content",nil];
    
    [[SKLinkedinAPI ShareInstance] SharePostToLinkedin:params completion:^(NSDictionary *response) {
        
        NSLog(@"Share post Response - %@",response);
        
        [[[UIAlertView alloc] initWithTitle:@"Successful!" message:@"Your feed successfully posted to Linkedin." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
        
    }
                                               failure:^(NSDictionary *response) {
                                                   
                                                   
                                               }];

    
}
 



@end
