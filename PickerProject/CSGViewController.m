//
//  CSGViewController.m
//  PickerProject
//
//  Created by Christina Green on 11/6/13.
//  Copyright (c) 2013 Greenster. All rights reserved.
//

#import "CSGViewController.h"

@interface CSGViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>

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
   
//    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
//    [picker setDelegate:self];
//
//    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
//        [picker setSourceType:UIImagePickerControllerSourceTypeCamera];
//    else
//    {
//        [picker setSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
//    }
//    [picker setAllowsEditing:YES];
//    [self presentViewController:picker animated:YES completion:^{
//        NSLog(@"Showing Camera");
//    }];
    
    
    
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
    
    UIImage *filteredImage = [UIImage imageWithCGImage:cgImage];
    
    // show the image to the user
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
    [imageView setImage:filteredImage];
    [self.view addSubview:imageView];
    
    // save the image to the photos album
    UIImageWriteToSavedPhotosAlbum(filteredImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)takePhotoWithCamera:(UIImagePickerController *)picker
{
//    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
//        [picker setSourceType:UIImagePickerControllerSourceTypeCamera];
//    else
//    {
//        [picker setSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
//    }
//    [picker setAllowsEditing:YES];
//    [self presentViewController:picker animated:YES completion:^{
//        NSLog(@"Showing Camera");
//    }];
}
//- (void)selectPhotoFromLibrary:(UIImagePickerController *)picker
//{
//}

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
    
//    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
//    [picker setDelegate:self];
//    
//    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
//        [picker setSourceType:UIImagePickerControllerSourceTypeCamera];
//    else
//    {
//        [picker setSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
//    }
//    [picker setAllowsEditing:YES];
//    [self presentViewController:picker animated:YES completion:^{
//        NSLog(@"Showing Camera");
//    }];
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

@end
