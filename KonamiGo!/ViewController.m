//
//  ViewController.m
//  KonamiGo!
//
//  Created by Eric Ito on 4/5/14.
//  Copyright (c) 2014 Eric Ito. All rights reserved.
//

#import "ViewController.h"
#import "KONAMIGestureRecognizer.h"

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>
@property (nonatomic, strong) KONAMIGestureRecognizer *konamiGR;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *things;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
//    self.konamiGR = [[KONAMIGestureRecognizer alloc] initWithTarget:self action:@selector(konami:)];
//    self.konamiGR.delegate = self;
//    self.konamiGR.cancelsTouchesInView = NO;
//    [self.view addGestureRecognizer:self.konamiGR];
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

-(void)konami:(KONAMIGestureRecognizer*)sender {
    NSLog(@"recognized gesture");
}

#pragma mark UIGestureRecognizerDelegate

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

#pragma mark - 

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellid = @"eaoifeajr";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    cell.textLabel.text = @"Hello World";
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return self.things.count;
    return 100;
}
@end
