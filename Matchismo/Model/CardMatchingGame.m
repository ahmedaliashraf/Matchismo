//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Ahmed Ali Ashraf on 9/16/15.
//  Copyright (c) 2015 CMP 464. All rights reserved.
//

#import "CardMatchingGame.h"
#import "SetCard.h"


@interface CardMatchingGame ()
@property (nonatomic, strong)Deck *deckCopy;
@property (nonatomic, readwrite) NSInteger score;
@property (nonatomic, strong) NSMutableArray *cards;
@property (nonatomic, readwrite)NSInteger modeValue;
@property (nonatomic) BOOL twoMatch;
@end

@implementation CardMatchingGame

- (NSMutableArray *)cards
{
    if (!_cards)_cards = [[NSMutableArray alloc] init];
    return _cards;
}

- (instancetype)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck
{
    self = [super init];
    if (self){
        _deckCopy = deck;
        for (int i = 0; i < count; i++){
            Card *card = [deck drawRandomCard];
            if (card){
                [self.cards addObject:card];
            } else {
                self = nil;
                break;
            }
            
        }
    }
    return self;
}

- (Card *)cardAtIndex:(NSUInteger)index
{
    return (index<[self.cards count]) ? self.cards[index]: nil;
}

static const int MISMATCH_PENALTY = 2;
static const int MATCH_BONUS = 4;
static const int COST_TO_CHOOSE = 1;



- (void)chooseCardAtIndex:(NSUInteger)index
{
    if (!self.twoMatch){
        Card *card = [self cardAtIndex:index];
        
        if (!card.isMatched){
            if (card.isChosen) {
                card.chosen = NO;
            } else {
                //match against other chosen cards
                NSMutableArray *otherCards = [[NSMutableArray alloc] init];
                for (Card *otherCard in self.cards){
                    if (otherCard.isChosen && !otherCard.isMatched){
                        [otherCards addObject:otherCard];
                    }
                }
                if ([otherCards count] == 2){
                    int matchScore = [card match:otherCards];
                    if (matchScore){
                        self.score += matchScore * MATCH_BONUS;
                        for (Card *anotherCard in otherCards){
                            anotherCard.matched = YES;
                        }
                        card.matched = YES;
                    } else {
                        self.score -= MISMATCH_PENALTY;
                        for (Card *anotherCard in otherCards){
                            anotherCard.chosen = NO;
                        }
                    }
                }
                self.score -= COST_TO_CHOOSE;
                card.chosen = YES;
            }
        }
    }else{
        Card *card = [self cardAtIndex:index];
        
        if (!card.isMatched){
            if (card.isChosen) {
                card.chosen = NO;
            } else {
                //match against other chosen cards
                for (Card *otherCard in self.cards){
                    if (otherCard.isChosen && !otherCard.isMatched){
                        int matchScore = [card match:@[otherCard]];
                        if (matchScore){
                            self.score += matchScore * MATCH_BONUS;
                            otherCard.matched = YES;
                            card.matched = YES;
                        } else {
                            self.score -= MISMATCH_PENALTY;
                            otherCard.chosen = NO;
                        }
                        break; //can only choose 2 cards
                    }
                }
                self.score -= COST_TO_CHOOSE;
                card.chosen = YES;
            }
        }
    }
}
- (void)addCardsToExistingOnes{
    NSLog(@"Cards left:%d",[self.deckCopy numberOfCards]);
    Card *newCard = [self.deckCopy drawRandomCard];
    if (newCard) {
        [self.cards addObject:newCard];
    }
}
- (BOOL)cardsLeft{
    if ([self.deckCopy numberOfCards]>0) {
        return YES;
    }
    return NO;
}
- (void)isTwoMatchMode: (BOOL)isTwoMatch{
    self.twoMatch = isTwoMatch;
}
- (void)resetScore
{
    self.score = 0;
}

@end
