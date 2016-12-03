//
//  PlayingCardView.h
//  Matchismo
//
//  Created by Ultimate on 10/25/15.
//  Copyright (c) 2015 CMP 464. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayingCardView : UIView
@property (nonatomic) NSUInteger rank;
@property (nonatomic,strong) NSString *suit;
@property (nonatomic) BOOL faceUp;

- (void)pinch: (UIPinchGestureRecognizer *)gesture;

@end
