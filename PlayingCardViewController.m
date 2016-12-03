//
//  PlayingCardViewController.m
//  Matchismo
//
//  Created by Ahmed Ali Ashraf on 10/8/15.
//  Copyright © 2015 CMP 464. All rights reserved.
//

#import "PlayingCardViewController.h"
#import "PlayingCardDeck.h"
#import "PlayingCard.h"
#import "PlayingCardView.h"

@interface PlayingCardViewController ()

@end

@implementation PlayingCardViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.isPlayingCardGame = YES;
    self.cardSize = CGSizeMake(78.0, 120.0);
    self.numberOfCards = 30;
    [self.game isTwoMatchMode:YES];
    [self updateUI];
}

- (Deck *)makeDeck
{
    return [[PlayingCardDeck alloc] init];
}

- (UIView *)makeCardView:(Card *)card{
    PlayingCardView *playingCardView = [[PlayingCardView alloc]init];
    [self updateView:playingCardView forCard:card];
    return playingCardView;
}
- (void)updateView:(UIView *)view forCard:(Card *)card{
    if ([card isKindOfClass:[PlayingCard class]] && [view isKindOfClass:[PlayingCardView class]]) {
        PlayingCard *playingCard = (PlayingCard *)card;
        PlayingCardView *playingCardView = (PlayingCardView *)view;
        playingCardView.rank = playingCard.rank;
        playingCardView.suit = playingCard.suit;
        playingCardView.faceUp = playingCard.chosen;
    }
}

@end
