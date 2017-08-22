//
//  CNBaseViewController.m
//  ClearNote
//
//  Created by Jitendra Agarwal on 27/11/15.
//  Copyright © 2015 Jitendra Agarwal. All rights reserved.
//

#import "CNBaseViewController.h"

@interface CNBaseViewController ()
{
    UIAlertController * alert1;
    MBProgressHUD *hud;
    ProgressHUD *progressHUD;
    UIAlertView *alert2;
    RTSpinKitView *spinner;
}

@end

@implementation CNBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- validate email
- (BOOL)validateEmail: (NSString *) candidate
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
return [emailTest evaluateWithObject:candidate];
}
#pragma mark- Remove Space
-(NSString*)trim:(NSString*)string
{
    return [string stringByTrimmingCharactersInSet:[NSCharacterSet  whitespaceAndNewlineCharacterSet]];
}
#pragma mark- Aleart
-(void) showMessage:(NSString*)message withTitle:(NSString *)title
{
    [self loderStop:self.view];
    alert1=   [UIAlertController
               alertControllerWithTitle:title
               message:message
               preferredStyle:UIAlertControllerStyleAlert];
    
    
    
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 
                                 [alert1 dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
    
    [alert1 addAction:cancel];
    
    [self presentViewController:alert1 animated:YES completion:nil];
    
}
#pragma mark- alert witout actions auto dissmiss
-(void)showMessgeWithAutoDismiss:(NSString*)message withTitle:(NSString *)title
{
    alert2 = [[UIAlertView alloc]initWithTitle:title
                                       message:message
                                      delegate:nil
                             cancelButtonTitle:nil
                             otherButtonTitles:nil];
    [alert2 show];
    [self timedAlert];
    
}
-(void)timedAlert
{
    [self performSelector:@selector(dismissAlert:) withObject:alert2 afterDelay:1];
}
-(void)dismissAlert:(UIAlertView *) alertView
{
    [alertView dismissWithClickedButtonIndex:nil animated:YES];
}
//#pragma  working on loder
//-(void)loderStart:(UIView *)tergetView strLbl:(NSString *)strLbl
//{
//    hud = [MBProgressHUD showHUDAddedTo:tergetView animated:YES];
//  //  hud.mode = MBProgressHUDModeAnnularDeterminate;
//    hud.backgroundColor = [UIColor whiteColor];
//    hud.labelText = strLbl;
//   
//   
//}
-(void)loderStart:(UIView *)tergetView strLbl:(NSString *)strLbl
{

    spinner = [[RTSpinKitView alloc] initWithStyle:RTSpinKitViewStyleCircle];
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    //CGFloat screenWidth = CGRectGetWidth(screenBounds);
     spinner.center = CGPointMake(CGRectGetMidX(screenBounds), CGRectGetMidY(screenBounds)-60);
  //  spinner.spinnerSize = 50.0;
   // [spinner sizeToFit];
    [tergetView addSubview:spinner];
 
    
    

   // [spinner startAnimating
    
}
-(void)loderStop:(UIView *)tergetView
{
  [spinner stopAnimating];
}


#pragma  working on loder





@end
