

//
//  PhotoViewController.m
//  Zju_SmartHome
//
//  Created by chenyufeng on 15/12/12.
//  Copyright © 2015年 GJY. All rights reserved.
//

#import "PhotoViewController.h"

@interface PhotoViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIPopoverControllerDelegate>



@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (strong, nonatomic) UIPopoverController *imagePickerPopover;
@property (nonatomic,assign) BOOL isOpenCameraOrAlbum;

@end

@implementation PhotoViewController

- (void)viewDidLoad {
  [super viewDidLoad];



}


- (void)viewWillAppear:(BOOL)animated{

  [super viewWillAppear:animated];

  if (!self.isOpenCameraOrAlbum) {
    if ([self.imagePickerPopover isPopoverVisible]) {
      [self.imagePickerPopover dismissPopoverAnimated:YES];
      self.imagePickerPopover = nil;
      return;
    }

    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.editing = YES;
    imagePicker.delegate = self;
    //这里可以设置是否允许编辑图片；
    imagePicker.allowsEditing = false;

    imagePicker.sourceType = self.openType;

    //创建UIPopoverController对象前先检查当前设备是不是ipad
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
      self.imagePickerPopover = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
      self.imagePickerPopover.delegate = self;
    }
    else{
      [self presentViewController:imagePicker animated:YES completion:nil];
    }
    self.isOpenCameraOrAlbum = !self.isOpenCameraOrAlbum;
  }

}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{

  UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];

  //将照片放入UIImageView对象中；
  self.imageView.image = image;

  UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);


  //判断UIPopoverController对象是否存在
  if (self.imagePickerPopover) {
    [self.imagePickerPopover dismissPopoverAnimated:YES];
    self.imagePickerPopover = nil;
  }
  else
  {
    //关闭以模态形式显示的UIImagePickerController
    [self dismissViewControllerAnimated:YES completion:nil];
  }
}

#pragma mark 图片保存完毕的回调
- (void) image: (UIImage *) image didFinishSavingWithError:(NSError *) error contextInfo: (void *)contextInf{
  
}

@end
