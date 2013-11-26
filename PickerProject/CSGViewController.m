//
//  CSGViewController.m
//  PickerProject
//
//  Created by Christina Green on 11/6/13.
//  Copyright (c) 2013 Greenster. All rights reserved.
//

#import "CSGViewController.h"
#import <Social/Social.h>
#import <MessageUI/MessageUI.h>

@interface CSGViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, MFMailComposeViewControllerDelegate>

@property UIImage *filteredImage;

@end


@implementation CSGViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIImagePickerController

- (IBAction)choosePhoto:(id)sender

{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Use Camera?"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Yes, Take Photo", @"No, use saved photo", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
    actionSheet.destructiveButtonIndex = 1;
    [actionSheet showInView:self.view];
    // [actionSheet release];
}

- (void)applyFilterToImage:(UIImage *)image
{
    // filter the image
    CIContext *context = [CIContext contextWithOptions:nil];
    
    CIImage *ciImage = [CIImage imageWithCGImage:image.CGImage];
    
    CIFilter *filter = [CIFilter filterWithName:@"CIColorInvert"];
    
    [filter setValue:ciImage forKey:kCIInputImageKey];
    
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    
    CGRect extent = [result extent];
    
    CGImageRef cgImage = [context createCGImage:result fromRect:extent];
    
    //    UIImage *filteredImage = [UIImage imageWithCGImage:cgImage];
    _filteredImage = [UIImage imageWithCGImage:cgImage];
    
    // show the image to the user
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
    [imageView setImage:_filteredImage];
    [self.view addSubview:imageView];
    
    // save the image to the photos album
    UIImageWriteToSavedPhotosAlbum(_filteredImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)takePhotoWithCamera:(UIImagePickerController *)picker
{
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    [picker setDelegate:self];
    
    if (buttonIndex == 0)
    {
        //        [self takePhotoWithCamera];
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            [picker setSourceType:UIImagePickerControllerSourceTypeCamera];
        else
        {
            [picker setSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
        }
        [picker setAllowsEditing:YES];
        [self presentViewController:picker animated:YES completion:^{
            NSLog(@"Showing Camera");
        }];
        //added in class 11/7
        UIView *overlayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 300)];
        overlayView.layer.borderColor = [[UIColor redColor] CGColor];
        overlayView.layer.borderWidth = 5.0f;
        
        // makes a red frame on view
        
        UIButton *overlayButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200, 60)];
        overlayButton.center = overlayView.center;
        overlayButton.backgroundColor = [UIColor blueColor];
        
        [overlayButton setTitle:@"close picker" forState:UIControlStateNormal];
        
        // have to call method
        
        //not working :(
        //button made programatically
        [overlayButton addTarget:self
                          action:@selector(overlayButtonTapped)
                forControlEvents:UIControlEventTouchUpInside];
        [overlayView addSubview: overlayButton];
        picker.cameraOverlayView = overlayView;
    }
    else if (buttonIndex == 1)
    {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum])
            [picker setSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
        else
        {
            NSLog(@"Nada");
        }
        [picker setAllowsEditing:YES];
        [self presentViewController:picker animated:YES completion:^{
            NSLog(@"Showing Saved Photos");
        }];
    }
    
    else if (buttonIndex == 2)
    {
        NSLog(@"cancel");
    }
}
// added in class 11/7
-(void)overlayButtonTapped
{
    [self dismissViewControllerAnimated:TRUE completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    [self dismissViewControllerAnimated:YES completion:^{
        UIImage *pickedImage = [info objectForKey:UIImagePickerControllerEditedImage];
        
        [self applyFilterToImage:pickedImage];
        
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"User cancelled image selection");
}

- (void)image: (UIImage *)image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    if (error) {
        NSLog(@"Unable to save photo to camera roll");
    } else {
        NSLog(@"Saved Image To Camera Roll");
    }
}
- (IBAction)shareAction:(UIBarButtonItem *)sender
{
    SLComposeViewController *shareViewController;
    
    switch (sender.tag) {
        case 0: // Facebook
            shareViewController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
            [shareViewController setInitialText:@"Check out my Social.framework on Facebook"];
            [shareViewController addImage:filteredImage.images];
            [shareViewController addURL:[NSURL URLWithString:@"http://facebook.com/mydemoapp"]];
            [self presentViewController:shareViewController animated:YES completion:nil];
            break;
        case 1: // Twitter
            shareViewController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
            [shareViewController setInitialText:@"Check out my Social.framework on Twitter"];
            [shareViewController addImage:_filteredImage.images];
            [shareViewController addURL:[NSURL URLWithString:@"http://twitter.com/mydemoapp"]];
            [self presentViewController:shareViewController animated:YES completion:nil];
            break;
        case 2: // Activity
            
            break;
    }
    
}
- (IBAction)showMailPicker:(id)sender
{
    // You must check that the current device can send email messages before you
    // attempt to create an instance of MFMailComposeViewController.  If the
    // device can not send email messages,
    // [[MFMailComposeViewController alloc] init] will return nil.  Your app
    // will crash when it calls -presentViewController:animated:completion: with
    // a nil view controller.
    if ([MFMailComposeViewController canSendMail])
        // The device can send email.
    {
        [self displayMailComposerSheet];
    }
    else
        // The device can not send email.
    {
        self.feedbackMsg.hidden = NO;
		self.feedbackMsg.text = @"Device not configured to send mail.";
    }
}
- (void)displayMailComposerSheet
{
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;
	
	[picker setSubject:@"Look what I made!"];
	
	NSString *path = [[NSBundle mainBundle] pathForResource:@"rainy" ofType:@"jpg"];
	NSData *myData = [NSData dataWithContentsOfFile:path];
	[picker addAttachmentData:myData mimeType:@"image/jpeg" fileName:@"rainy"];
	
	NSString *emailBody = @"I wrote an awesome app to make edgy photos. Jealous?";
	[picker setMessageBody:emailBody isHTML:NO];
	
	[self presentViewController:picker animated:YES completion:NULL];
}


@end
