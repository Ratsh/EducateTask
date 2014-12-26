//
//  MainViewController.m
//  EducateTask
//
//  Created by Admin on 21.12.14.
//  Copyright (c) 2014 rth. All rights reserved.
//

#import "MainViewController.h"
#import "TableViewController.h"
#import "AppDelegate.h"
#import "PicturesCollectionViewController.h"

@interface MainViewController ()

@property (weak, nonatomic) IBOutlet UILabel    *attrTextCounterLabel;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSManagedObjectContext  *context            = APP_DELEGATE.managedObjectContext;
    NSFetchRequest          *fetchRequest       = [NSFetchRequest fetchRequestWithEntityName:@"AttrText"];
    NSError                 *error              = nil;
    NSArray                 *results            = [context executeFetchRequest:fetchRequest
                                                                         error:&error];
    if (error != nil) {
        NSLog(@"fetch error: %@", error);
        return;
    }
    _attrTextCounterLabel.text                  = [NSString stringWithFormat:@"%lu", (unsigned long)results.count];
    
    self.navigationItem.backBarButtonItem       = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                                   style:UIBarButtonItemStylePlain
                                                                                  target:nil action:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(attrTextDidAdd:)
                                                 name:@"increaseAttrText"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(attrTextDidDel:)
                                                 name:@"decreaseAttrText"
                                               object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden   = YES;
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBarHidden   = NO;
}

- (IBAction)TableButtonPressed {    
    [self.navigationController pushViewController:[TableViewController new]
                                         animated:YES];
}

- (void)attrTextDidAdd:(NSNotification *)notification {
    NSInteger       counter                     = [_attrTextCounterLabel.text integerValue];
    
    _attrTextCounterLabel.text                  = [NSString stringWithFormat:@"%li", counter + 1];
}

- (void)attrTextDidDel:(NSNotification *)notification {
    NSInteger       counter                     = [_attrTextCounterLabel.text integerValue];
    
    _attrTextCounterLabel.text                  = [NSString stringWithFormat:@"%li", counter - 1];
}

- (IBAction)CollectButtonPressed {
    [self.navigationController pushViewController:[[PicturesCollectionViewController alloc]
                                                   initWithNibName:@"PicturesCollectionViewController"
                                                   bundle:[NSBundle mainBundle]]
                                         animated:YES];
}

@end
