#import "ownioscam.h"
#import "ownioscamController.h"

@implementation ownioscamController
{
 CGFloat _lastScale;
}


- (void)willAnimateRotationToInterfaceOrientation:
(UIInterfaceOrientation)toInterfaceOrientation
                                         duration:(NSTimeInterval)duration
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Test Message"
                                                    message:@"This is a sample"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}
// Entry point method
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Instantiate the UIImagePickerController instance
        self.picker = [[UIImagePickerController alloc] init];
        
        self.picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        self.picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
        self.picker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        self.picker.showsCameraControls = NO;
        
        // Make us the delegate for the UIImagePickerController
        self.picker.delegate = self;
        
        // Set the frames to be full screen
        CGRect screenFrame = CGRectMake(0, 0, 1024, 2049);
        self.view.frame = screenFrame;
        self.picker.view.frame = screenFrame;
         self.picker.cameraViewTransform = CGAffineTransformMakeScale(1.0, 1.03);
        
        // Set this VC's view as the overlay view for the UIImagePickerController
        self.picker.cameraOverlayView = self.view;
    self.picker.cameraOverlayView.backgroundColor=[UIColor clearColor];
        _lastScale = 1.;
    }
    return self;
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return toInterfaceOrientation == UIInterfaceOrientationPortrait;
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

-(void) doPinch:(UIPinchGestureRecognizer *) sender
{

    if([sender state] == UIGestureRecognizerStateEnded)
    {
        _lastScale = 1.0;
        return;
    }
    
    CGFloat scale = 1.0 - (_lastScale - sender.scale); // sender.scale gives current distance of fingers compared to initial distance. We want a value to scale the current transform with, so diff between previous scale and new scale is what must be used to stretch the current transform
    
    
    CGAffineTransform currentTransform = self.picker.cameraViewTransform;
    CGAffineTransform newTransform = CGAffineTransformScale (currentTransform, scale, scale); // stretch current transform by amount given by sender
    
    newTransform.a = MAX(newTransform.a, 1.); // it should be impossible to make preview smaller than screen (or initial size)
    newTransform.d = MAX(newTransform.d, 1.);
    
    self.picker.cameraViewTransform = newTransform;
    _lastScale = sender.scale;
}

// Action method.  This is like an event callback in JavaScript.
-(IBAction) takePhotoButtonPressed:(id)sender forEvent:(UIEvent*)event {
    // Call the takePicture method on the UIImagePickerController to capture the image.
    [self.picker takePicture];
    
}

-(NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(nullable UIWindow *)window
{

if([self.view.window.rootViewController.presentedViewController isKindOfClass:[ownioscamController class]])
{
    return UIInterfaceOrientationPortrait;
}
else return UIInterfaceOrientationPortrait;
}

-(IBAction) cancel:(id)sender forEvent:(UIEvent*)event {
    // Call the takePicture method on the UIImagePickerController to capture the image.
   NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    
    NSString * imgarray = [defaults objectForKey:@"k1"];
      NSString * imgarray1 = [defaults objectForKey:@"k2"];
    
    imgarray = [imgarray stringByAppendingString:@";;" ];
    imgarray = [imgarray stringByAppendingString:imgarray1 ];
    
    
    [self.plugin capturedImageWithPath:imgarray];
    [defaults removeObjectForKey:@"k1"];
      [defaults removeObjectForKey:@"k2"];
   
}
-(NSString*)generateRandomString:(int)num {
    NSMutableString* string = [NSMutableString stringWithCapacity:num];
    for (int i = 0; i < num; i++) {
        [string appendFormat:@"%C", (unichar)('a' + arc4random_uniform(25))];
    }
    return string;
}



- (UIImage *)resizeImage:(UIImage*)image newSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

// Delegate method.  UIImagePickerController will call this method as soon as the image captured above is ready to be processed.  This is also like an event callback in JavaScript.
-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    // Get a reference to the captured image
    UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    self.ImageView.image = image;
    
     NSString* string = [self generateRandomString:5];
      NSString* compresed_string = [self generateRandomString:5];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    NSString * s1 = @".jpg";
    string = [string stringByAppendingString:s1 ];
     compresed_string = [compresed_string stringByAppendingString:s1 ];
    NSString* filename = string;
     NSString* compressed_filename = compresed_string;
    
    
    NSString* imagePath = [documentsDirectory stringByAppendingPathComponent:filename];
     NSString* compressed_imagePath = [documentsDirectory stringByAppendingPathComponent:compressed_filename];
    
    // Get the image data (blocking; around 1 second)
 //   NSData* imageData = UIImageJPEGRepresentation(image, 1.0);
 //   [imageData writeToFile:imagePath atomically:YES];
    
    
    UIImage *newImage=image;
    CGFloat height = newImage.size.height;
    CGFloat width = newImage.size.width;
    CGFloat tempheight ;
    CGFloat tempwidth ;
  //  CGSize size;
    
    if(height > width)
    {
    //portrait
      
        if(height > 960 )
        {
            tempheight = 960;
            // size=CGSizeMake(110,110);
        }
        else
        {
            tempheight = height;
       
        }
        
        if(width > 720 )
        {
          
            tempwidth = 720;
        }
        else
        {
          
            tempwidth = width;
        }
      
        
    }
    
    if(width > height)
    {
        //landscape
        if(height > 720 )
        {
            tempheight  = 720;
        }
        else
        {
            tempheight = height;
            
        }
        
        if(width > 960 )
        {
            tempwidth = 960;
        }
        else
        {
            tempwidth = width;
            
        }

    }
    
    CGFloat ht = tempheight;
    CGFloat wt = tempwidth;
    
 // CGSize size=CGSizeMake(110,110);
    CGSize size = CGSizeMake(tempwidth, tempheight);
   
    newImage=[self resizeImage:newImage newSize:size];
    
     NSData* imageData1 = UIImageJPEGRepresentation(newImage, 1.0);
    NSData* compressed_imageData = UIImageJPEGRepresentation(newImage, 0.5);
    [compressed_imageData writeToFile:compressed_imagePath atomically:YES];
    [imageData1 writeToFile:imagePath atomically:YES];
    
    
    NSString * str5 = [defaults objectForKey:@"k1"];
    //UIImage *img = [UIImage imageWithContentsOfFile:imagePath];
    // UIImageWriteToSavedPhotosAlbum(img,nil,nil,nil);
    if([str5 length] == 0)
    {
        [defaults setObject:imagePath forKey:@"k1"];
        
        [defaults setObject:compressed_imagePath forKey:@"k2"];
        
        
    }
    if([str5 length] != 0)
    {
        NSString * _sbuffer =   [defaults objectForKey:@"k1"];
        _sbuffer = [_sbuffer stringByAppendingString:@","];
        
        _sbuffer = [_sbuffer stringByAppendingString:imagePath];
        [defaults setObject:_sbuffer forKey:@"k1"];
        
        
        NSString * _sbufferc =   [defaults objectForKey:@"k2"];
        _sbufferc = [_sbufferc stringByAppendingString:@","];
        
        _sbufferc = [_sbufferc stringByAppendingString:compressed_imagePath];
        [defaults setObject:_sbufferc forKey:@"k2"];
        
        
        
    }
}

@end
