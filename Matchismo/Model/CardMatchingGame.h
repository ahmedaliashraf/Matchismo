//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Ahmed Ali Ashraf on 9/16/15.
//  Copyright (c) 2015 CMP 464. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"
#import "Card.h"


@interface CardMatchingGame : NSObject

// designated initializer
- (instancetype)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck;

- (void)chooseCardAtIndex:(NSUInteger)index;
- (Card *)cardAtIndex:(NSUInteger)index;
- (void)resetScore;
- (void)isTwoMatchMode:(BOOL)isTwoMatch;
- (void)addCardsToExistingOnes;
- (BOOL)cardsLeft;
@property (nonatomic, readonly)NSInteger score;
@end
