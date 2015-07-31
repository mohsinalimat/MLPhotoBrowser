//
//  ViewController.m
//  MLPhotoBrowser
//
//  Created by 张磊 on 15/4/26.
//  Copyright (c) 2015年 www.weibo.com/makezl. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (strong,nonatomic) NSArray *examples;
@end

@implementation ViewController

- (NSArray *)examples{
    if (!_examples) {
        _examples = @[
                      @"Scale Browser, 没有数据源传photos",
                      @"Fade Browser",
                      @"Show Signle Browser in Portrait",
                      @"Scale Browser, 有数据源的用法",
                      ];
    }
    return _examples;
}

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.title = @"MLPhotoBrowser";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.examples.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.textLabel.text = self.examples[indexPath.row];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UIViewController *viewController = [[NSClassFromString([NSString stringWithFormat:@"Example%ldViewController",indexPath.row+1]) alloc] init];
    viewController.title = self.examples[indexPath.row];
    [self.navigationController pushViewController:viewController animated:YES];
    
}

@end
