//
//  AttrText.h
//  EducateTask
//
//  Created by Admin on 22.12.14.
//  Copyright (c) 2014 rth. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface AttrText : NSManagedObject

@property (nonatomic, retain) NSNumber * attrTextId;
@property (nonatomic, retain) NSString * attrTextValue;

@end
