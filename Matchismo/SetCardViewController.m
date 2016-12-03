//
//  SetCardViewController.m
//  Matchismo
//
//  Created by Ahmed Ali Ashraf on 10/19/15.
//  Copyright © 2015 CMP 464. All rights reserved.
//

#import "SetCardViewController.h"
#import "SetCardDeck.h"
#import "SetCard.h"
#import "CardMatchingGame.h"
#import "SetCardView.h"

@interface SetCardViewController ()


@end

@implementation SetCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isPlayingCardGame = NO;
    self.cardSize = CGSizeMake(120.0, 120.0);
    self.numberOfCards = 12;
    self.removeMatchedCards = YES;
    [self.game isTwoMatchMode:NO];
    [self updateUI];
}

- (Deck *)makeDeck
{
    return [[SetCardDeck alloc] init];
}

- (UIView *)makeCardView:(Card *)card{
    SetCardView *setCardView = [[SetCardView alloc]init];
    [self updateView:setCardView forCard:card];
    return setCardView;
}
- (void)updateView:(UIView *)view forCard:(Card *)card{
    if ([card isKindOfClass:[SetCard class]] && [view isKindOfClass:[SetCardView class]]) {
        SetCard *setCard = (SetCard *)card;
        SetCardView *setCardView = (SetCardView *)view;
        setCardView.symbol = setCard.symbol;
        setCardView.color = setCard.color;
        setCardView.shade = setCard.shade;
        setCardView.count = setCard.count;
        setCardView.chosen = setCard.chosen;
    }
}

@end
