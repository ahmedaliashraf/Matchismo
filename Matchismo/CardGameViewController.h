//
//  CardGameViewController.h
//  Matchismo
//
//  Created by Ahmed Ali Ashraf on 9/9/15.
//  Copyright (c) 2015 CMP 464. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Deck.h"
#import "CardMatchingGame.h"

@interface CardGameViewController : UIViewController

@property (strong, nonatomic) CardMatchingGame *game;
@property (nonatomic) CGSize cardSize;
@property (nonatomic) NSUInteger numberOfCards;
@property (nonatomic)BOOL removeMatchedCards;
@property (nonatomic)BOOL isPlayingCardGame;

//abstarct method
- (Deck *)makeDeck;
//abstract method

- (UIView *)makeCardView:(Card *)card;
- (void)updateView:(UIView *)view forCard:(Card *)card;
- (void)updateUI;
@end
