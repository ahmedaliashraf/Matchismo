//
//  SetCardDeck.m
//  Matchismo
//
//  Created by Ahmed Ali Ashraf on 10/11/15.
//  Copyright © 2015 CMP 464. All rights reserved.
//

#import "SetCardDeck.h"
#import "SetCard.h"

@implementation SetCardDeck

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        for (NSString *symbol in [SetCard validSymbols]) {
            for (NSString *color in [SetCard validColors]) {
                for (NSString *shade in [SetCard validShades]){
                    for (NSUInteger count = 1; count <= [SetCard maxCount]; count++) {
                        SetCard *card = [[SetCard alloc]init];
                        card.symbol = symbol;
                        card.color = color;
                        card.shade = shade;
                        card.count = count;
                        [self addCard:card atTop:YES];
                    }
                }
            }
        }
    }
    return self;
}

@end
