//
//  ViewController.m
//  仿写微信朋友圈
//
//  Created by Guangquan Yu on 2017/11/13.
//  Copyright © 2017年 ZHM.YU. All rights reserved.
//

#import "ViewController.h"
#import "YGQ_FriendCircle.h"
#import "YGQ_FC_CommitTableViewCell.h"
#import "YGQ_FC_TableViewCell.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    YGQ_FriendCircle * friendCircle = [[YGQ_FriendCircle alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    
    NSArray * data = @[
                       @{YGQCOMMENTMAN:@"房间爱了",YGQREVERT:@"回复",YGQBYCOMMENTMAN:@"恩星",YGQCONTENT:@": 在俄总统普京访华框架内，俄联合飞机制造公司与中国商用飞机有限责任公司签订了关于组建合资企业共同生产远程干线宽体客机的合同。"}
                       ,@{YGQCOMMENTMAN:@"超级大",YGQREVERT:@"回复",YGQBYCOMMENTMAN:@"玉川砂记子",YGQCONTENT:@":会谈中双方同意加快中国一带一路倡议同老挝变陆锁国为陆联国战略对接共建中老经济走廊推进中老铁路等标志性项目提升经贸合作规模和水联国战略对接共建中老经济走廊推进中老铁路等标志性项目提升经贸合作规模和水联国战略对接共建中老经济走廊推进中老铁路等标志性项目提升经贸合作规模和水平"}
                       ,@{YGQCOMMENTMAN:@"铂金老师",YGQCONTENT:@"：虽说每位小朋友都是父母的天使，但总是有那么一些粗线条大脑洞的爹妈，分分钟就让你知道什么叫实力坑娃~"}
                       ];

    
    
    NSMutableArray * finalDataMutable = @[].mutableCopy;
    for (int i=0; i<13; i++) {

        NSMutableArray * dataMutable = @[].mutableCopy;
   
        CGFloat cellAllHeight = 0;
        NSInteger pinglun_count = arc4random() % 23;
        for (int i=0; i<pinglun_count; i++) {
            
            NSDictionary * dic = data[arc4random() % 3];

            NSDictionary * heightDic = [YGQ_FC_CommitTableViewCell calculateHeight:dic maxWidth:([UIScreen mainScreen].bounds.size.width-60-20-20)];
            
            NSMutableDictionary * dic1 = dic.mutableCopy;
            [dic1 addEntriesFromDictionary:heightDic];
            [dataMutable addObject:dic1];
            
            cellAllHeight += [heightDic[@"height"] doubleValue];
        }

        NSDictionary * dic = @{@"commentsContent":dataMutable,
                               @"commentsH":[NSString stringWithFormat:@"%f",cellAllHeight]
                               };
        ;
        
        NSMutableDictionary * muDic = dic.mutableCopy;

        [muDic addEntriesFromDictionary:[self loadData:arc4random() % 7]];
  
        [finalDataMutable addObject:[YGQ_FC_TableViewCell calculateHeight:muDic maxWidth:([UIScreen mainScreen].bounds.size.width-60-20-20)]];
    }
    
    
    friendCircle.dataArr = finalDataMutable;
    [self.view addSubview:friendCircle];
}
#pragma mark- 数据

- (NSDictionary *)loadData:(NSInteger)count{
    NSMutableArray * dataArr = @[].mutableCopy;
    if (dataArr) {
        [dataArr removeAllObjects];
    }
    NSArray * arr = @[@"民生银行",
                      @"兴业银行",
                      @"光大证券",
                      @"招商银行",
                      @"民生银行",
                      @"兴业银行",
                      @"光大证券",
                      @"招商银行",
                      ];
    NSArray * arr0 = @[[NSString stringWithFormat:@"%f", (1024.0)],
                       [NSString stringWithFormat:@"%f", (750.0)],
                       [NSString stringWithFormat:@"%f", (700.0)],
                       [NSString stringWithFormat:@"%f", (637.0)],
                       [NSString stringWithFormat:@"%f", (1024.0)],
                       [NSString stringWithFormat:@"%f", (750.0)],
                       [NSString stringWithFormat:@"%f", (700.0)],
                       [NSString stringWithFormat:@"%f", (637.0)]
                       ];
    NSArray * arr1 = @[[NSString stringWithFormat:@"%f", (576.0)],
                       [NSString stringWithFormat:@"%f", (15712.0)],
                       [NSString stringWithFormat:@"%f", (990.0)],
                       [NSString stringWithFormat:@"%f", (966.0)],
                       [NSString stringWithFormat:@"%f", (576.0)],
                       [NSString stringWithFormat:@"%f", (15712.0)],
                       [NSString stringWithFormat:@"%f", (990.0)],
                       [NSString stringWithFormat:@"%f", (966.0)]
                       ];
    
    NSArray * arr2 = @[@"6.jpg",
                       @"picture2.jpeg",
                       @"3.jpeg",
                       @"5.jpg",
                       @"6.jpg",
                       @"picture2.jpeg",
                       @"3.jpeg",
                       @"5.jpg"
                       ];
    NSArray * arr3 = @[@"http://pic9.nipic.com/20100906/1295091_134639124058_2.jpg",
                       @"http://106.14.18.64:8080/FilesService/servlet/DownloadImgServlet?fileName=%5B750-15712%5Dcf667ed981d044efaa716d8c229d4557.jpg",
                       @"http://img3.imgtn.bdimg.com/it/u=815355944,211976467&fm=206&gp=0.jpg",
                       @"http://pic.58pic.com/58pic/13/23/37/01958PICjAH_1024.jpg",
                       @"http://pic9.nipic.com/20100906/1295091_134639124058_2.jpg",
                       @"http://106.14.18.64:8080/FilesService/servlet/DownloadImgServlet?fileName=%5B750-15712%5Dcf667ed981d044efaa716d8c229d4557.jpg",
                       @"http://img3.imgtn.bdimg.com/it/u=815355944,211976467&fm=206&gp=0.jpg",
                       @"http://pic.58pic.com/58pic/13/23/37/01958PICjAH_1024.jpg"
                       ];

    for (int i = 0; i < count; i ++) {
        ZZJijinModel * model  = [[ZZJijinModel alloc]init];
        
        model.title = arr[i];
        model.imageSize = CGSizeMake([arr0[i] floatValue], [arr1[i] floatValue]);
        model.stateImageName = arr2[i];
        model.stateImageUrl = arr3[i];
        [dataArr addObject:model];
        
    }
    
    return @{@"图片Count":[NSString stringWithFormat:@"%ld",count],@"图片Data":dataArr};
  
}



@end
