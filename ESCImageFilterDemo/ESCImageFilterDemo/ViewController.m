//
//  ViewController.m
//  ESCImageFilterDemo
//
//  Created by xiang on 2019/4/12.
//  Copyright © 2019 xiang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *oldImageView;

@property (weak, nonatomic) IBOutlet UIImageView *filterImageView;

@property(nonatomic,strong)UIImage* oldImage;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.oldImageView.layer.borderWidth = 1;
    self.filterImageView.layer.borderWidth = 1;
    
    self.oldImage = [UIImage imageNamed:@"test2"];
    self.oldImageView.image = self.oldImage;
    
    [self filterTest];
    
    [self testRotate];
  
}

- (void)filterTest {
    double startTime = CFAbsoluteTimeGetCurrent();

    CGImageRef imageRef = self.oldImage.CGImage;
    
    CIImage *ciimage = [CIImage imageWithCGImage:imageRef];
    CIFilter *filter = [CIFilter filterWithName:@"CIBoxBlur"];
    
    // 这里我们使用的是KVC的方式给filter设置属性
    [filter setValue:ciimage forKey:kCIInputImageKey];
    //    3.有一个CIContext的对象去合并原图和滤镜效果
    CIImage *outputImage = filter.outputImage;
    //      创建一个图像操作的上下文
    CIContext *context = [CIContext contextWithOptions:nil];
    //      把原图和滤镜合并起来  包含原图和滤镜效果的图像
    /**
     *  Image :   合成之后的图像
     *  fromRect:  合成之后图像的尺寸： 图像.extent
     */
    CGImageRef imageRefr = [context createCGImage:outputImage fromRect:outputImage.extent];
    double endTime = CFAbsoluteTimeGetCurrent();
    double time = endTime - startTime;
    NSLog(@"%f",time);
    
    
//    self.filterImageView.image = [UIImage imageWithCGImage:imageRefr];
}

- (void)testRotate {
    double startTime = CFAbsoluteTimeGetCurrent();
    
        CGImageRef imageRef = self.oldImage.CGImage;
    
    CGAffineTransform d3d = CGAffineTransformIdentity;
    d3d = CGAffineTransformRotate(d3d, M_PI / 4 );
    d3d = CGAffineTransformScale(d3d, 0.3, 0.3);
    CIImage *outputImage = [CIImage imageWithCGImage:imageRef];
    
    outputImage = [outputImage imageByApplyingTransform:d3d];
    //      创建一个图像操作的上下文
    CIContext *context = [CIContext contextWithOptions:nil];
    //      把原图和滤镜合并起来  包含原图和滤镜效果的图像
    /**
     *  Image :   合成之后的图像
     *  fromRect:  合成之后图像的尺寸： 图像.extent
     */
//    CGImageRef imageRefr = [context createCGImage:outputImage fromRect:outputImage.extent];
    int centerX = outputImage.extent.origin.x + outputImage.extent.size.width / 2;
    int centerY = outputImage.extent.origin.y + outputImage.extent.size.height / 2;
    int startX = centerX - self.oldImage.size.width / 2;
    int startY = centerY - self.oldImage.size.height / 2;
    
    CGImageRef imageRefr = [context createCGImage:outputImage fromRect:CGRectMake(startX, startY, self.oldImage.size.width, self.oldImage.size.height)];
    
    UIImage *newImage = [UIImage imageWithCGImage:imageRefr];
    NSLog(@"%@===%@",outputImage,newImage);
    self.filterImageView.image = newImage;
    double endTime = CFAbsoluteTimeGetCurrent();
    double time = endTime - startTime;
    NSLog(@"%f",time);

//    NSLog(@"%@===%@",self.oldImageView.image,self.filterImageView.image);
}

@end
