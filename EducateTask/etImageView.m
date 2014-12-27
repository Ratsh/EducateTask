//
//  etImageView.m
//  EducateTask
//
//  Created by Admin on 27.12.14.
//  Copyright (c) 2014 rth. All rights reserved.
//

#import "etImageView.h"

@implementation etImageView

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.layer.cornerRadius = self.bounds.size.width / 2;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
