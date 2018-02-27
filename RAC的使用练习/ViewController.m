//
//  ViewController.m
//  RAC的使用练习
//
//  Created by 迦南 on 2018/2/20.
//  Copyright © 2018年 迦南. All rights reserved.
//

#import "ViewController.h"
#import "RAC_Basic.h"
#import "RAC_Sequence.h"
#import "RAC_Advanced.h"
#import "RAC_CommonMethods.h"

#import "LLView.h"
#import "TableViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet LLView *LLView;
@property (nonatomic, assign) NSInteger age;

@property (weak, nonatomic) IBOutlet UITextField *txtField;
@property (weak, nonatomic) IBOutlet UILabel *txtLabel;
@end

@implementation ViewController

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    
    ViewController *vc = [super allocWithZone:zone];

    // ViewDidLoad
    [[vc rac_signalForSelector:@selector(viewDidLoad)] subscribeNext:^(id  _Nullable x) {
        NSLog(@"ViewDidLoad");
    }];

    // ViewWillAppear
    [[vc rac_signalForSelector:@selector(viewWillAppear:)] subscribeNext:^(id  _Nullable x) {
        NSLog(@"ViewWillAppear");
    }];

    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
  
    RAC_BasicTest();
//    RAC_SequenceTest();
//    RAC_AdvancedTest();
//    [self RACCommandBtnDidClick];
//    [self RACSubjectDelegateUse];
//    [self RACCommonMethods];
}


// RAC基本使用
void RAC_BasicTest()  {
//    [RAC_Basic createBasicSignal];
//    [RAC_Basic createSubjectSignal];
//    [RAC_Basic createReplaySubjectSignal];
//    [RAC_Basic mergeSignal];
    [RAC_Basic dependecySignal];
}

// RAC集合使用
void RAC_SequenceTest() {
//    [RAC_Sequence getArrayElement];
//    [RAC_Sequence getDictionaryElement];
    [RAC_Sequence dictToModel];
}

// RAC一些进阶使用
void RAC_AdvancedTest() {
//    [RAC_Advanced signalConnection];
//    [RAC_Advanced signalCommand];
}


// RACSubject作为代理的使用
- (void)RACSubjectDelegateUse {
    RACSubject *subject = [RACSubject subject];
    _LLView.subject = subject;
    
    [subject subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@", x);
    }];
}

// RACCommand控制按钮点击
- (void)RACCommandBtnDidClick {
     [RAC_Advanced signalCommandSceneWithLoginBtn:_loginBtn];
}

// RAC常用方法使用
- (void)RACCommonMethods {
//    [RAC_CommonMethods listenMethodUseWithView:_LLView];
//    [self RAC_KOVUse];
//    [RAC_CommonMethods listenNotificationUse];
    [RAC_CommonMethods listenTextChangeWithTextField:_txtField label:_txtLabel];
}

// 使用RAC KVO
- (void)RAC_KOVUse {
    // 内部也是调用- (RACSignal *)rac_valuesAndChangesForKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options方法
    [[self rac_valuesForKeyPath:@keypath(self, age) observer:self] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@", x);
    }];
    
     // KVO宏 @"age" 直接写属性名,不要包装成字符串
    [RACObserve(self, age) subscribeNext:^(id  _Nullable x) {
         NSLog(@"%@", x);
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.age++;
}
- (IBAction)jumpVc:(id)sender {
    TableViewController *vc = [[TableViewController alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
}
@end
