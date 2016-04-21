//
//  GifEditorViewController.m
//  GifMaker_ObjC
//
//  Created by Gabrielle Miller-Messner on 3/4/16.
//  Copyright © 2016 Gabrielle Miller-Messner. All rights reserved.
//

#import "GifEditorViewController.h"
#import "GifPreviewViewController.h"

@interface GifEditorViewController ()
@property (weak, nonatomic) IBOutlet UITextField *captionTextField;

@end

@implementation GifEditorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated {
    self.captionTextField.delegate = self;
    self.gifImageView.image = self.gif.gifImage;
    
    UIBarButtonItem *nextButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Next"
                                   style:UIBarButtonItemStylePlain
                                   target:self
                                   action:@selector(presentPreview)];
    self.navigationItem.rightBarButtonItem = nextButton;
    [self subscribeToKeyboardNotifications];

}

-(void)viewDidDisappear:(BOOL)animated {
    [self unsubscribeFromKeyboardNotifications];
}

#pragma mark - UITextFieldDelegate methods

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return true;
}

#pragma mark - Observe Keyboard notifications
-(void)subscribeToKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)unsubscribeFromKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

-(void)keyboardWillShow:(NSNotification*)notification {
    CGRect rect = self.view.frame;
    rect.origin.y -= [self getKeyboardHeight:notification];
    self.view.frame = rect;
}

-(void)keyboardWillHide:(NSNotification*)notification {
    CGRect rect = self.view.frame;
    rect.origin.y += [self getKeyboardHeight:notification];
    self.view.frame = rect;
}

-(CGFloat)getKeyboardHeight:(NSNotification*)notification {
    NSDictionary *userInfo = notification.userInfo;
    NSValue *keyboardFrameEnd = [userInfo valueForKey: UIKeyboardFrameEndUserInfoKey]; // of CGRect
    CGRect keyboardFrameEndRect = [keyboardFrameEnd CGRectValue];
    return keyboardFrameEndRect.size.height;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    textField.placeholder = nil;
}

# pragma mark - Preview gif
-(void)presentPreview {
    GifPreviewViewController *previewVC = [self.storyboard instantiateViewControllerWithIdentifier:@"GifPreviewViewController"];
    self.gif.caption = self.captionTextField.text;
    previewVC.gif = self.gif;
    [self.navigationController pushViewController:previewVC animated:true];
}

@end
