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

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.oldImageView.layer.borderWidth = 1;
    self.filterImageView.layer.borderWidth = 1;
    
    
    
    // Do any additional setup after loading the view.
    
    UIImage *testImage = [UIImage imageNamed:@"test"];
    
    self.oldImageView.image = testImage;
    
    CGImageRef imageRef = testImage.CGImage;
    CIImage *ciimage = [CIImage imageWithCGImage:imageRef];
    
    NSArray *array = [CIFilter filterNamesInCategories:nil];
    
//    NSLog(@"%@",array);
    
    CIFilter *filter = [CIFilter filterWithName:@"CIAffineTransform"];
    // 这里我们使用的是KVC的方式给filter设置属性
    [filter setValue:ciimage forKey:kCIInputImageKey];
    
    CGAffineTransform d3d = CGAffineTransformIdentity;
    d3d = CGAffineTransformRotate(d3d, M_PI / 4 );
//    d3d = CGAffineTransformScale(d3d, 2, 1);
    
    NSValue *value = [NSValue valueWithBytes:&d3d objCType:@encode(CGAffineTransform)];
    [filter setValue:value forKey:kCIInputTransformKey];
    
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
    
    self.filterImageView.image = [UIImage imageWithCGImage:imageRefr];
    NSLog(@"%@===%@",self.oldImageView.image,self.filterImageView.image);
}


@end
