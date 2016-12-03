//
//  Card.h
//  Matchismo
//
//  Created by Ahmed Ali Ashraf on 9/10/15.
//  Copyright (c) 2015 CMP 464. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Card : NSObject

@property (strong, nonatomic) NSString *contents;
@property (nonatomic, getter = isChosen) BOOL chosen;
@property (nonatomic, getter = isMatched) BOOL matched;

- (int)match:(NSArray *)otherCards;

@end
