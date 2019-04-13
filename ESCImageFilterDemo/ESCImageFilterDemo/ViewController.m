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
    // Do any additional setup after loading the view.
    
    UIImage *testImage = [UIImage imageNamed:@"test"];
    
    self.oldImageView.image = testImage;
    
    CGImageRef imageRef = testImage.CGImage;
    CIImage *ciimage = [CIImage imageWithCGImage:imageRef];
    
    NSArray *array = [CIFilter filterNamesInCategories:nil];
    
    NSLog(@"%@",array);
    
    CIFilter *filter = [CIFilter filterWithName:@"CIBumpDistortion"];
    // 这里我们使用的是KVC的方式给filter设置属性
    [filter setValue:ciimage forKey:kCIInputImageKey];
    // 设置凹凸的效果半径  越大越明显
    [filter setValue:@500 forKey:kCIInputRadiusKey];
    // CIVector :表示 X Y 坐标的一个类
    // 设置中心点的
    [filter setValue:[CIVector vectorWithX:200 Y:200] forKey:kCIInputCenterKey];
    
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
    NSLog(@"%@===%@",imageRef,ciimage);
}


@end
