//
//  ViewController.m
//  DemoBeaconstac
//
//  Created by Garima Batra on 8/26/14.
//  Copyright (c) 2014 MobStac Inc. All rights reserved.
//

#import "ViewController.h"
#import "VideoAndAudioViewController.h"

@interface ViewController ()
{
    Beaconstac *beaconstac;
    NSString *mediaType;
    NSString *mediaUrl;
    UIView *bgView;
    BOOL wellComeMsg;
    BOOL videoOpened;
    UIScrollView *scrollView;
    UIView *incredientsView;
    UIButton *btnRedChill;
    UIButton *btnCookingOil;
    UIButton *btnPaneer;
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *image = [[UIImageView alloc] init];
    image.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [image setImage:[UIImage imageNamed:@"splash_screen.png"]];
    [self.view addSubview:image];

//    UILabel *lblWelcome = [[UILabel alloc] init];
//    lblWelcome.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
//    lblWelcome.backgroundColor = [UIColor clearColor];
//    lblWelcome.text = @"FreshWorld";
//    lblWelcome.textColor = [UIColor blackColor];
//    lblWelcome.textAlignment = NSTextAlignmentCenter;
//    [self.view addSubview:lblWelcome];
    
//    [self ReceipeOfTheDay];
    
//    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Background.png"]]];
//    self.title = @"Demo Beaconstac";
    
    [[MSLogger sharedInstance]setLoglevel:MSLogLevelVerbose];
    
    // Setup and initialize the Beaconstac SDK
//    BOOL success = [Beaconstac setupOrganizationId:<org_ID_value> userToken:<developer_token_value> beaconUUID:<beaconUUID_value> beaconIdentifier:<com.<company_name_value>.<app_name_value>>];
    
    BOOL success = [Beaconstac setupOrganizationId:81
                                         userToken:@"d62a97ee4b31907880dc3880c5a16271d4aebb38"
                                        beaconUUID:@"B9407F30-F5F8-466E-AFF9-25556B57FE6D"
                                  beaconIdentifier:@"FreshWorld"];
    // Credentials end

    if (success) {
        NSLog(@"DemoApp:Successfully saved credentials.");
    }
    
    beaconstac = [[Beaconstac alloc]init];
    beaconstac.delegate = self;
    
    [beaconstac updateFact:@"female" forKey:@"gender"];

    // Demonstrates Custom Attributes functionality.     [self customAttributeDemo];
}

- (void)viewDidAppear:(BOOL)animated {
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//
// This method explains how to use custom attributes through Beaconstac SDK. You can create a new Custom
// Attribute from Beaconstac developer portal. You can then create (or edit) a rule and add the Custom
// attribute to the rule. Then, you can define an action for the rule you just created (or edited).
// For eg. you created a custom attribute called "gender" of type "string". In the rule, you can add a
// custom attribute, gender matches female and associate an action with the rule, say "Text Alert" saying
// "Gender is female". Now, in the app, you can set the "gender" of the user by updating facts in the SDK.
// The rule gets triggered when the facts you update in the app satisfies the custom attribute condition.
//
- (void)customAttributeDemo
{
    [beaconstac updateFact:@"female" forKey:@"Gender"];
}

#pragma mark - Beaconstac delegate
// Tells the delegate a list of beacons in range.
- (void)beaconsRanged:(NSDictionary *)beaconsDictionary
{
}

// Tells the delegate about the camped on beacon among available beacons.
- (void)campedOnBeacon:(id)beacon amongstAvailableBeacons:(NSDictionary *)beaconsDictionary
{
    NSLog(@"DemoApp:Entered campedOnBeacon");
    NSLog(@"DemoApp:campedOnBeacon: %@, %@", beacon, beaconsDictionary);
    NSLog(@"DemoApp:facts Dict: %@", beaconstac.factsDictionary);
}

// Tells the delegate when the device exits from the camped on beacon range.
- (void)exitedBeacon:(id)beacon
{
    NSLog(@"DemoApp:Entered exitedBeacon");
    NSLog(@"DemoApp:exitedBeacon: %@", beacon);
    
}

// Tells the delegate that a rule is triggered with corresponding list of actions. 
- (void)ruleTriggeredWithRuleName:(NSString *)ruleName actionArray:(NSArray *)actionArray
{
     NSLog(@"DemoApp:Action Array: %@", actionArray);
    //
    // actionArray contains the list of actions to trigger for the rule that matched.
    //
    for (NSDictionary *actionDict in actionArray) {
        //
        // meta.action_type can be "popup", "webpage", "media", or "custom"
        //
        if ([[[actionDict objectForKey:@"meta"]objectForKey:@"action_type"]  isEqual: @"popup"])
        {
            //
            // Show an alert
            //
//            NSLog(@"DemoApp:Text Alert action type");
//            NSString *message = [[[actionDict objectForKey:@"meta"]objectForKey:@"params"]objectForKey:@"text"];
//            [[[UIAlertView alloc] initWithTitle:ruleName message:[NSString stringWithFormat:@"%@",message] delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil] show];
          
            NSString *message = [[[actionDict objectForKey:@"meta"]objectForKey:@"params"]objectForKey:@"text"];
            
            if (videoOpened == NO && [message isEqualToString:@"Welcome to Vegetable section of FreshWorld"])
            {
                UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:@"Cancel", nil];
                alter.tag = 101;
                [alter show];
                videoOpened = YES;
            }
            else if (wellComeMsg == NO && [message isEqualToString:@"You have added paneer to your cart, do you want to buy ingredients"])
            {
                if (videoOpened == YES)
                {
                    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:@"Cancel", nil];
                    alter.tag = 102;
                    [alter show];
                    wellComeMsg = YES;
                }
                else
                {
                    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"" message:@"Do you want buy ingridients" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:@"Cancel", nil];
                    alter.tag = 103;
                    [alter show];
                }
            }
        }
        else if ([[[actionDict objectForKey:@"meta"]objectForKey:@"action_type"]  isEqual: @"webpage"]) {
            //
            // Handle webpage by popping up a WebView
            //
            NSLog(@"DemoApp:Webpage action type");
            CGRect screenRect = [[UIScreen mainScreen] bounds];
            UIWebView *webview=[[UIWebView alloc]initWithFrame:screenRect];
            NSString *url=[[[actionDict objectForKey:@"meta"]objectForKey:@"params"]objectForKey:@"url"];
            NSURL *nsurl=[NSURL URLWithString:url];
            NSURLRequest *nsrequest=[NSURLRequest requestWithURL:nsurl];
            [webview loadRequest:nsrequest];
            
            [self.view addSubview:webview];
            
            // Setting title of the current View Controller
            self.title = @"Webpage action";
            
        }
        else if ([[[actionDict objectForKey:@"meta"]objectForKey:@"action_type"]  isEqual: @"video"]) {
            //
            // Media type - video
            //
            NSLog(@"DemoApp:Media action type video");
            mediaType = @"video";
            mediaUrl = [[[actionDict objectForKey:@"meta"]objectForKey:@"params"]objectForKey:@"url"];
            [self performSegueWithIdentifier:@"AudioAndVideoSegue" sender:self];
            
        }
        else if ([[[actionDict objectForKey:@"meta"]objectForKey:@"action_type"]  isEqual: @"audio"])
        {
            //
            // Media type - audio
            //
            NSLog(@"DemoApp:Media action type audio");
            mediaType = @"audio";
            mediaUrl = [[[actionDict objectForKey:@"meta"]objectForKey:@"params"]objectForKey:@"url"];
            
            [self performSegueWithIdentifier:@"AudioAndVideoSegue" sender:self];
            
        }
        else if ([[[actionDict objectForKey:@"meta"]objectForKey:@"action_type"]  isEqual: @"custom"])
        {
            //
            // Custom JSON converted to NSDictionary - it's up to you how you want to handle it
            //
            NSDictionary *params = [[actionDict objectForKey:@"meta"]objectForKey:@"params"];
            NSLog(@"DemoApp:Received custom action_type: %@", params);
        }
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 101)
    {
        if (buttonIndex == 0)
        {
            [self ReceipeOfTheDay];
        }
        else
        {
            NSLog(@"Alert is canceled");
        }
    }
    else if (alertView.tag == 103 || alertView.tag == 102)
    {
        if (buttonIndex == 0)
        {
            [self incredientsViewOpen];
        }
        else
        {
            NSLog(@"Alert is canceled");
        }
    }
}

-(void)ReceipeOfTheDay
{
    scrollView = [[UIScrollView alloc] init];
    scrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, 0);
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.delegate = self;
    scrollView.scrollEnabled = YES;
    [self.view addSubview:scrollView];
    
    UILabel *lblWelcome = [[UILabel alloc] init];
    lblWelcome.frame = CGRectMake(0, 0, self.view.frame.size.width, 60);
    lblWelcome.backgroundColor = [UIColor colorWithRed:87.0/255.0 green:144.0/255.0 blue:96.0/255.0 alpha:1.0];
    lblWelcome.text = @"Welcome To Vegetable Section Of FreshWorld";
    lblWelcome.textColor = [UIColor whiteColor];
    lblWelcome.textAlignment = NSTextAlignmentCenter;
    lblWelcome.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
    lblWelcome.numberOfLines = 0;
    [scrollView addSubview:lblWelcome];
    
    UILabel *lblReceipe = [[UILabel alloc] init];
    lblReceipe.frame = CGRectMake(0, lblWelcome.frame.origin.y+lblWelcome.frame.size.height, self.view.frame.size.width, 30);
    lblReceipe.backgroundColor = [UIColor clearColor];
    lblReceipe.text = @"Receipe Of The Day ";
    lblReceipe.textColor = [UIColor blackColor];
    lblReceipe.textAlignment = NSTextAlignmentCenter;
    lblReceipe.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
    [scrollView addSubview:lblReceipe];
    
    UILabel *lblReceipeName = [[UILabel alloc] init];
    lblReceipeName.frame = CGRectMake(0, lblReceipe.frame.origin.y+lblReceipe.frame.size.height, self.view.frame.size.width, 30);
    lblReceipeName.backgroundColor = [UIColor clearColor];
    lblReceipeName.text = @"Paneer Khofta";
    lblReceipeName.textColor = [UIColor blackColor];
    lblReceipeName.textAlignment = NSTextAlignmentCenter;
    lblReceipeName.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    [scrollView addSubview:lblReceipeName];
    
    UITextView *txtView = [[UITextView alloc] init];
    txtView.frame = CGRectMake(10, lblReceipeName.frame.origin.y+lblReceipeName.frame.size.height, self.view.frame.size.width-20, 200);
    txtView.backgroundColor = [UIColor clearColor];
    txtView.text = @"                                 INGREDIENTS \n\n100 gms grated paneer \n\n1 1/2 boiled potatoes, mashed \n\n50 gms khoya \n\n2 Tbsp ginger garlic paste \n\n1 1/2 tsp turmeric powder \n\n1 tsp red chili powder \n\nHandful of fresh coriander \n\n1/2 tsp cumin seeds \n\n1/2 tsp coriander seeds \n\n2-3 Tbsp mustard oil \n\n25g ms raisins, chopped \n\n50 gms flour \n\nSalt to taste";
    txtView.textAlignment = NSTextAlignmentLeft;
    txtView.textColor = [UIColor blackColor];
    txtView.font = [UIFont fontWithName:@"Helvetica" size:12];
    txtView.layer.cornerRadius = 5.0f;
    txtView.layer.borderColor = [UIColor blackColor].CGColor;
    txtView.layer.borderWidth = 2.0f;
    [scrollView addSubview:txtView];
    txtView.scrollEnabled = NO;
    txtView.editable = NO;
    
    UIButton *btnLink = [[UIButton alloc] init];
    btnLink.frame = CGRectMake((self.view.frame.size.width-100)/2, txtView.frame.origin.y+txtView.frame.size.height+10, 100, 30);
    btnLink.backgroundColor = [UIColor colorWithRed:87.0/255.0 green:144.0/255.0 blue:96.0/255.0 alpha:1.0];
    [btnLink setTitle:@"Play Video" forState:UIControlStateNormal];
    [btnLink setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnLink addTarget:self action:@selector(btnLinkClicked) forControlEvents:UIControlEventTouchUpInside];
    btnLink.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
    btnLink.layer.cornerRadius = 5.0f;
//    btnLink.layer.borderColor = [UIColor blackColor].CGColor;
//    btnLink.layer.borderWidth = 2.0f;
    [scrollView addSubview:btnLink];
    
    UILabel *lblAddCart = [[UILabel alloc] init];
    lblAddCart.frame = CGRectMake(0, btnLink.frame.origin.y+btnLink.frame.size.height, self.view.frame.size.width, 65);
    lblAddCart.backgroundColor = [UIColor clearColor];
    lblAddCart.text = @"Do you want paneer to your cart?";
    lblAddCart.textAlignment = NSTextAlignmentCenter;
    lblAddCart.textColor = [UIColor blackColor];
    lblAddCart.font = [UIFont fontWithName:@"Helvetica" size:18];
    [scrollView addSubview:lblAddCart];
    
    UIButton *btnAdd = [[UIButton alloc] init];
    btnAdd.frame = CGRectMake(60, lblAddCart.frame.origin.y+lblAddCart.frame.size.height, 75, 30);
    btnAdd.backgroundColor = [UIColor colorWithRed:87.0/255.0 green:144.0/255.0 blue:96.0/255.0 alpha:1.0];
    [btnAdd setTitle:@"Add" forState:UIControlStateNormal];
    [btnAdd setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnAdd addTarget:self action:@selector(btnAddClicked) forControlEvents:UIControlEventTouchUpInside];
    btnAdd.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
    btnAdd.layer.cornerRadius = 5.0f;
//    btnAdd.layer.borderColor = [UIColor blackColor].CGColor;
//    btnAdd.layer.borderWidth = 2.0f;
    [scrollView addSubview:btnAdd];
    
    UIButton *btnCancel = [[UIButton alloc] init];
    btnCancel.frame = CGRectMake(btnAdd.frame.origin.x+btnAdd.frame.size.width+50, lblAddCart.frame.origin.y+lblAddCart.frame.size.height, 75, 30);
    btnCancel.backgroundColor = [UIColor colorWithRed:87.0/255.0 green:144.0/255.0 blue:96.0/255.0 alpha:1.0];
    [btnCancel setTitle:@"Cancel" forState:UIControlStateNormal];
    [btnCancel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnCancel addTarget:self action:@selector(btnCancelClicked) forControlEvents:UIControlEventTouchUpInside];
    btnCancel.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
    btnCancel.layer.cornerRadius = 5.0f;
//    btnCancel.layer.borderColor = [UIColor blackColor].CGColor;
//    btnCancel.layer.borderWidth = 2.0f;
    [scrollView addSubview:btnCancel];
    
    scrollView.contentSize = CGSizeMake(0, btnCancel.frame.origin.y+btnCancel.frame.size.height);
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    scrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}

-(void)btnAddClicked
{
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"" message:@"Paneer has been added to your cart" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alter show];
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"AddCart"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [scrollView removeFromSuperview];
}

-(void)btnCancelClicked
{
    [scrollView removeFromSuperview];
}

-(void)btnLinkClicked
{
    [self OpenWebView];
}

-(void)OpenWebView
{
    bgView = [[UIView alloc] init];
    bgView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    [self.view bringSubviewToFront:bgView];
    
    UIWebView *webView = [[UIWebView alloc] init];
    webView.frame = CGRectMake(0, 30, self.view.frame.size.width, self.view.frame.size.height-30);
    webView.delegate = self;
    webView.backgroundColor = [UIColor whiteColor];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.youtube.com/watch?v=JovbzNHQ5Zk"]]];
    [bgView addSubview:webView];
    
    UIButton *btnClose = [[UIButton alloc] init];
    btnClose.frame = CGRectMake(bgView.frame.size.width-55, 5, 50, 20);
    btnClose.backgroundColor = [UIColor clearColor];
    [btnClose setTitle:@"Cancel" forState:UIControlStateNormal];
    btnClose.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:10];
    [btnClose setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnClose addTarget:self action:@selector(btnCloseClicked) forControlEvents:UIControlEventTouchUpInside];
    btnClose.layer.cornerRadius = 5.0f;
    btnClose.layer.borderColor = [UIColor blackColor].CGColor;
    btnClose.layer.borderWidth = 2.0f;
    [bgView addSubview:btnClose];
    btnClose.userInteractionEnabled = YES;
}

-(void)btnCloseClicked
{
    [bgView removeFromSuperview];
}

-(void)incredientsViewOpen
{
    incredientsView = [[UIView alloc] init];
    incredientsView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    incredientsView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:incredientsView];
    
    NSArray *array = [[NSArray alloc] initWithObjects:@"Red chill powder", @"Cooking oil", @"Termaric powder", nil];
    
    float Xxais = 30;
    
    UILabel *lbling;
    
    for (int i=0; i<array.count; i++)
    {
        lbling = [[UILabel alloc] init];
        lbling.frame = CGRectMake(40, Xxais, 200, 30);
        lbling.backgroundColor = [UIColor clearColor];
        lbling.text = [array objectAtIndex:i];
        lbling.textAlignment = NSTextAlignmentLeft;
        lbling.textColor = [UIColor blackColor];
        lbling.font = [UIFont fontWithName:@"Helvetica" size:20];
        [incredientsView addSubview:lbling];
        
        Xxais = Xxais+50;
    }
    
    btnRedChill = [[UIButton alloc] init];
    btnRedChill.frame = CGRectMake(lbling.frame.origin.x+lbling.frame.size.width+20, 30, 30, 30);
    btnRedChill.backgroundColor = [UIColor whiteColor];
    [btnRedChill setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnRedChill addTarget:self action:@selector(btnIngClicked:) forControlEvents:UIControlEventTouchUpInside];
    btnRedChill.layer.cornerRadius = 5.0f;
    btnRedChill.layer.borderColor = [UIColor blackColor].CGColor;
    btnRedChill.layer.borderWidth = 2.0f;
    btnRedChill.tag = 201;
    [incredientsView addSubview:btnRedChill];
    
    btnCookingOil = [[UIButton alloc] init];
    btnCookingOil.frame = CGRectMake(btnRedChill.frame.origin.x, btnRedChill.frame.origin.y+btnRedChill.frame.size.height+20, 30, 30);
    btnCookingOil.backgroundColor = [UIColor whiteColor];
    [btnCookingOil setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnCookingOil addTarget:self action:@selector(btnIngClicked:) forControlEvents:UIControlEventTouchUpInside];
    btnCookingOil.layer.cornerRadius = 5.0f;
    btnCookingOil.layer.borderColor = [UIColor blackColor].CGColor;
    btnCookingOil.layer.borderWidth = 2.0f;
    btnCookingOil.tag = 202;
    [incredientsView addSubview:btnCookingOil];
    
    btnPaneer = [[UIButton alloc] init];
    btnPaneer.frame = CGRectMake(btnCookingOil.frame.origin.x, btnCookingOil.frame.origin.y+btnCookingOil.frame.size.height+20, 30, 30);
    btnPaneer.backgroundColor = [UIColor whiteColor];
    [btnPaneer setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnPaneer addTarget:self action:@selector(btnIngClicked:) forControlEvents:UIControlEventTouchUpInside];
    btnPaneer.layer.cornerRadius = 5.0f;
    btnPaneer.layer.borderColor = [UIColor blackColor].CGColor;
    btnPaneer.layer.borderWidth = 2.0f;
    btnPaneer.tag = 203;
    [incredientsView addSubview:btnPaneer];
    
    UIButton *btnAdd = [[UIButton alloc] init];
    btnAdd.frame = CGRectMake(60, incredientsView.frame.size.height-100, 75, 30);
    btnAdd.backgroundColor = [UIColor colorWithRed:87.0/255.0 green:144.0/255.0 blue:96.0/255.0 alpha:1.0];
    [btnAdd setTitle:@"Add" forState:UIControlStateNormal];
    [btnAdd setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnAdd addTarget:self action:@selector(btnAddIngClicked) forControlEvents:UIControlEventTouchUpInside];
    btnAdd.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
    btnAdd.layer.cornerRadius = 5.0f;
//    btnAdd.layer.borderColor = [UIColor blackColor].CGColor;
//    btnAdd.layer.borderWidth = 2.0f;
    [incredientsView addSubview:btnAdd];
    
    UIButton *btnCancel = [[UIButton alloc] init];
    btnCancel.frame = CGRectMake(btnAdd.frame.origin.x+btnAdd.frame.size.width+50, btnAdd.frame.origin.y, 75, 30);
    btnCancel.backgroundColor = [UIColor colorWithRed:87.0/255.0 green:144.0/255.0 blue:96.0/255.0 alpha:1.0];
    [btnCancel setTitle:@"Cancel" forState:UIControlStateNormal];
    [btnCancel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnCancel addTarget:self action:@selector(btnCancelIngClicked) forControlEvents:UIControlEventTouchUpInside];
    btnCancel.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
    btnCancel.layer.cornerRadius = 5.0f;
//    btnCancel.layer.borderColor = [UIColor blackColor].CGColor;
//    btnCancel.layer.borderWidth = 2.0f;
    [incredientsView addSubview:btnCancel];
}

-(void)btnIngClicked:(UIButton *)sender
{
    if (sender.tag == 201)
    {
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"AddRedChill"] == NO)
        {
            btnRedChill.backgroundColor = [UIColor colorWithRed:87.0/255.0 green:144.0/255.0 blue:96.0/255.0 alpha:1.0];
            
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"AddRedChill"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        else
        {
            btnRedChill.backgroundColor = [UIColor whiteColor];
            
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"AddRedChill"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
    else if (sender.tag == 202)
    {
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"AddCookingOil"] == NO)
        {
            btnCookingOil.backgroundColor = [UIColor colorWithRed:87.0/255.0 green:144.0/255.0 blue:96.0/255.0 alpha:1.0];
            
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"AddCookingOil"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        else
        {
            btnCookingOil.backgroundColor = [UIColor whiteColor];
            
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"AddCookingOil"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
    else
    {
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"AddTurmeric"] == NO)
        {
            btnPaneer.backgroundColor = [UIColor colorWithRed:87.0/255.0 green:144.0/255.0 blue:96.0/255.0 alpha:1.0];
            
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"AddTurmeric"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        else
        {
            btnPaneer.backgroundColor = [UIColor whiteColor];
            
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"AddTurmeric"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
}

-(void)btnAddIngClicked
{
    [incredientsView removeFromSuperview];
    
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"" message:@"Selected ingredients has been added to your cart" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alter show];
}

-(void)btnCancelIngClicked
{
    [incredientsView removeFromSuperview];
}

//- (void)webViewDidStartLoad:(UIWebView *)webView
//{
//    [SVProgressHUD showWithStatus:@"Please Wait..." maskType:SVProgressHUDMaskTypeClear];
//}
//
//- (void)webViewDidFinishLoad:(UIWebView *)webView
//{
//    [SVProgressHUD dismiss];
//}
//
//- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request
// navigationType:(UIWebViewNavigationType)navigationType
//{
//    NSURL *url = request.URL;
//    
//    NSString *urlString = [NSString stringWithFormat:@"%@", url];
//    
//    if([urlString rangeOfString:@"http"].location != NSNotFound || [urlString rangeOfString:@"https"].location != NSNotFound)
//    {
//
//    }
//    
//    return YES;
//}

// Notifies the view controller that a segue is about to be performed.
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Pass media url and media type to the VideoAndAudioViewController.
    if ([segue.identifier isEqualToString:@"AudioAndVideoSegue"]) {
        VideoAndAudioViewController *videoAndAudioVC = segue.destinationViewController;
        videoAndAudioVC.title = [NSString stringWithFormat:@"%@ action", mediaType];
        videoAndAudioVC.mediaUrl = mediaUrl;
        videoAndAudioVC.mediaType = mediaType;
    }
}

@end
