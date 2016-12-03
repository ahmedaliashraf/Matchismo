//
//  Deck.h
//  Matchismo
//
//  Created by Ahmed Ali Ashraf on 9/10/15.
//  Copyright (c) 2015 CMP 464. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface Deck : NSObject

- (void)addCard:(Card *)card atTop:(BOOL)atTop;
- (void)addCard:(Card *)card;

- (Card *)drawRandomCard;
- (int)numberOfCards;

@end
