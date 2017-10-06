//
//  OtherBankViewController.m
//  Simobi
//
//  Created by Ravi on 10/15/13.
//  Copyright (c) 2013 Mfino. All rights reserved.
//

#import "OtherBankViewController.h"
#import "BankDetailCell.h"
#import "TransferDetailsViewController.h"
#import "Reachability.h"


static NSString * const kCellIdentifier = @"BankCell";

@interface OtherBankViewController ()
@property (nonatomic,retain)NSArray *dataArray;
@end

@implementation OtherBankViewController
@synthesize dataArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    [self subtitle:@"Bank List"];
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    float y_Pos = 0.0f;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        y_Pos = 130.0f;
    } else {
        y_Pos = 75.0f;
    }
    self.bankTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, y_Pos, 320.0, screenSize.height - y_Pos - 10) style:UITableViewStylePlain];
    self.bankTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.bankTableView.backgroundColor = [UIColor clearColor];
    self.bankTableView.delegate = self;
    self.bankTableView.dataSource = self;
    
    [self.bankTableView registerNib:[UINib nibWithNibName:@"BankDetailCell" bundle:nil] forCellReuseIdentifier:kCellIdentifier];
    [self.view addSubview:self.bankTableView];
    
    
    [self loadBankDataFromService];
    [self.bankTableView setUserInteractionEnabled:YES];
    
    [self removeTapGesture];
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self showBackButton];
    [self showHomeButton];
    if ([[[SimobiManager shareInstance] language] isEqualToString:SIMOBI_LANGUAGE_ENGLISH]) {
        [self title:@"Other Bank List"];
    } else {
       [self title:@"Daftar Bank Lain"];
    }
    

}

- (void)viewDidUnload
{
    
    self.dataArray        = nil;
    self.bankTableView = nil;

    [super viewDidUnload];
}
- (void)loadBankDataFromService
{
    
    Reachability *rechability = [Reachability reachabilityWithHostname:@"www.google.com"];
    
    if ([rechability currentReachabilityStatus] == NotReachable) {
        
        [self noNetworkAlert];
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [ProgressHUD displayWithMessage:@"Loading"];

    });
    [SimobiServiceModel connectJSONURL:SIMOBI_BANKCODE_DATA_URL successBlock:^(NSData *responseData) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [ProgressHUD hide];
            id JSON = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:nil];
            
            NSDictionary *dataDict = [NSDictionary dictionary];
            if ( [NSJSONSerialization isValidJSONObject:JSON ] )
            {
                dataDict  = (NSDictionary *)JSON;
                
            }
            
            self.dataArray = [dataDict objectForKey:@"bankData"];
            

            //CONDITIONLOG(DEBUG_MODE,@"Data:%@",dataArray);
            [self.bankTableView reloadData];
        });

    } failureBlock:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [ProgressHUD hide];
            
            NSDictionary *textDict = [[SimobiManager shareInstance] textDataForLanguage];
            [SimobiAlert showAlertWithMessage:[textDict objectForKey:REQUEST_TIME_OUT_ERROR]];
            
            /*if (error.code == NSURLErrorTimedOut) {
                // Handle time out here
                NSDictionary *textDict = [[SimobiManager shareInstance] textDataForLanguage];
                [SimobiAlert showAlertWithMessage:[textDict objectForKey:REQUEST_TIME_OUT_ERROR_FINANCE]];
            }else{
                [SimobiAlert showAlertWithMessage:error.localizedDescription];
            }*/
        });
        
        
    }];
        
 //   };
}

/*
 *Remove Tap gesture
 */
- (void)removeTapGesture
{
    NSArray *gestures = [self.view gestureRecognizers];
    [gestures enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        if ([[gestures objectAtIndex:idx] isKindOfClass:[UITapGestureRecognizer class]]) {
        
            [self.view removeGestureRecognizer:(UIGestureRecognizer *) [gestures objectAtIndex:idx]];
            *stop = YES;
        }
     }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableviewDataSourceMethods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 41.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BankDetailCell *cell = (BankDetailCell *)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier];

    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    cell.backgroundColor = [UIColor clearColor];

    NSDictionary *d = [self.dataArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [d objectForKey:@"name"];
    return cell;

}



#pragma mark - UITableviewDelegateMethods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TransferDetailsViewController *detailsVC = [[TransferDetailsViewController alloc] initWithTranferType:TRANSFER_TYPE_OTHERBANK];
    NSDictionary *d = [self.dataArray objectAtIndex:indexPath.row];

    detailsVC.bankName = [d objectForKey:@"name"];
    
    [[[SimobiManager shareInstance] responseData] removeAllObjects];
    [[[SimobiManager shareInstance] responseData] setObject:[[d objectForKey:@"code"] stringByReplacingOccurrencesOfString:@" " withString:@""] forKey:@"destBankCode"];
    
    [self.navigationController pushViewController:detailsVC animated:YES];

}



@end
