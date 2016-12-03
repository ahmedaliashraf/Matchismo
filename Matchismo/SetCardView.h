//
//  SetCardView.h
//  Matchismo
//
//  Created by Ultimate on 11/3/15.
//  Copyright (c) 2015 CMP 464. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetCardView : UIView

@property (strong, nonatomic) NSString *symbol;
@property (strong, nonatomic) NSString *shade;
@property (strong, nonatomic) NSString *color;
@property (nonatomic) NSUInteger count;
@property (nonatomic) BOOL chosen;

@end
