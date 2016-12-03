//
//  Card.m
//  Matchismo
//
//  Created by Ahmed Ali Ashraf on 9/10/15.
//  Copyright (c) 2015 CMP 464. All rights reserved.
//

#import "Card.h"

@interface Card() 

@end

@implementation Card


- (int)match:(NSArray *)otherCards
{
    int score = 0;
    for (Card *card in otherCards)
    {
        if ([card.contents isEqualToString:self.contents])
        {
            score = 1;
        }
    
    }
    
    return score;
    
}

@end
