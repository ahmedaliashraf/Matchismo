//
//  PlayingCard.h
//  Matchismo
//
//  Created by Ahmed Ali Ashraf on 9/10/15.
//  Copyright (c) 2015 CMP 464. All rights reserved.
//

#import "Card.h"
@interface PlayingCard : Card

@property (strong, nonatomic) NSString *suit;
@property (nonatomic) NSUInteger rank;

+ (NSArray *)validSuits;
+ (NSUInteger)maxRank;


@end
