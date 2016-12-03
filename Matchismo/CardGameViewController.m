//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Ahmed Ali Ashraf on 9/9/15.
//  Copyright (c) 2015 CMP 464. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"
#import "CardMatchingGame.h"
#import "Grid.h"

@interface CardGameViewController ()
@property (strong,nonatomic) NSMutableArray *viewsForCards;
@property (strong, nonatomic) Grid *cardsGrid;
@property (weak, nonatomic) IBOutlet UIView *cardSuperView;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (nonatomic)BOOL cardsArePiled;
@property (strong, nonatomic) UIDynamicAnimator *animatorForPan;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@end

@implementation CardGameViewController

#pragma mark - Superview Load and orientation

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    self.cardsGrid.size = self.cardSuperView.bounds.size;
    [self updateUI];
}

#pragma mark - properties

- (NSMutableArray *)viewsForCards{
    if (!_viewsForCards) {
        _viewsForCards = [NSMutableArray arrayWithCapacity:self.numberOfCards];
    }
    return _viewsForCards;
}

- (Grid *)cardsGrid{
    if (!_cardsGrid) {
        _cardsGrid = [[Grid alloc]init];
        _cardsGrid.size = self.cardSuperView.frame.size;
        _cardsGrid.cellAspectRatio = self.cardSize.width / self.cardSize.height;
        _cardsGrid.minimumNumberOfCells = self.numberOfCards;
        _cardsGrid.maxCellWidth = self.cardSize.width;
        _cardsGrid.maxCellHeight = self.cardSize.height;
    }
    return _cardsGrid;
}

- (CardMatchingGame *)game
{
    if(!_game){
        _game = [[CardMatchingGame alloc] initWithCardCount:self.numberOfCards usingDeck:[self makeDeck]];
    }
    return _game;
}

- (Deck *)makeDeck //abstract
{
    return nil;
}

#pragma mark- actions & animations

- (UIView *)makeCardView:(Card *)card{
    UIView *view = [[UIView alloc]init];
    [self updateView:view forCard:card];
    return view;
}
- (void)updateView:(UIView *)view forCard:(Card *)card{
    //NO NEED TO IMPLEMENT HERE. BOTH VIEW CONTROLLER WILL HAVE THEIR OWN.
}

- (void)tapCard:(UITapGestureRecognizer *)tapGesture
{
    if (tapGesture.state == UIGestureRecognizerStateEnded) {
        self.cardsArePiled = NO;
        Card *card = [self.game cardAtIndex:tapGesture.view.tag];
        if (!card.matched) {
            [UIView transitionWithView:tapGesture.view
                              duration:0.4
                               options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
                                   card.chosen = !card.chosen;
                                   [self updateView:tapGesture.view forCard:card];
                               } completion:^(BOOL finished) {
                                   card.chosen = !card.chosen;
                                   [self.game chooseCardAtIndex:tapGesture.view.tag];
                                   [self updateUI];
                               }];
        }
    }
}

const float SPACING_HELP = 0.05;

- (void)updateUI{
    if (![self.game cardsLeft]) {
        self.addButton.enabled = NO;
    } else{
        self.addButton.enabled = YES;
    }
    for (int crdIndx = 0; crdIndx < self.numberOfCards; crdIndx++) {
        Card *card = [self.game cardAtIndex:crdIndx];
        UIView *cardView;
        NSUInteger viewIndx = [self.viewsForCards indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
            if (((UIView *)obj).tag == crdIndx) {
                return YES;
            }
            return NO;
        }];
        
        if (viewIndx == NSNotFound) {
            if (!card.matched) {
                cardView = [self makeCardView:card];
                cardView.tag = crdIndx;
                cardView.frame = CGRectMake(self.cardSuperView.bounds.size.width, self.cardSuperView.bounds.size.height, self.cardsGrid.cellSize.width, self.cardsGrid.cellSize.height);
                UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapCard:)];
                [cardView addGestureRecognizer:tapGesture];
                [self.viewsForCards addObject:cardView];
                viewIndx = [self.viewsForCards indexOfObject:cardView];
                [self.cardSuperView addSubview:cardView];
            }
        }else{
            cardView = [self.viewsForCards objectAtIndex:viewIndx];
            if (card.matched) {
                if (self.removeMatchedCards) {
                    [self.viewsForCards removeObject:cardView];
                    [UIView animateWithDuration:1.2 animations:^{ cardView.center = CGPointMake(self.cardSuperView.bounds.size.width/2, self.cardSuperView.bounds.size.height-1);} completion:^(BOOL finished) { [cardView removeFromSuperview];}];
                }else{
                    cardView.alpha = 0.5;
                }
            }else{
                [self updateView:cardView forCard:card];
            }
        }
    }
    
    self.cardsGrid.minimumNumberOfCells = [self.viewsForCards count];
    NSUInteger viewsChanged = 0;
    for (NSUInteger vwIdx = 0; vwIdx < [self.viewsForCards count]; vwIdx++) {
        CGRect cardFrame = [self.cardsGrid frameOfCellAtRow:vwIdx / self.cardsGrid.columnCount
                                                      inColumn:vwIdx % self.cardsGrid.columnCount];
        cardFrame = CGRectInset(cardFrame, cardFrame.size.width * SPACING_HELP, cardFrame.size.height * SPACING_HELP);
        UIView *cardView = (UIView *)[self.viewsForCards objectAtIndex:vwIdx];
        if ((fabs(cardFrame.origin.x - cardView.frame.origin.x) > .01)||(fabs(cardFrame.origin.y - cardView.frame.origin.y) > .01)||(fabs(cardFrame.size.width - cardView.frame.size.width) > .01)||(fabs(cardFrame.size.height - cardView.frame.size.height) > .01)) {
            [UIView animateWithDuration:0.5 delay:1.2 * viewsChanged++ / [self.viewsForCards count] options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{cardView.frame = cardFrame;} completion:NULL];
        }
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
}

#pragma mark - UI Interactions

#define DEFAULT_SCORE @"Score: 0"

- (IBAction)dealCards:(UIButton *)sender {
    for (int i = 0; i < 2; i++) {
        [self doDeal];
    }
}

- (IBAction)addNewsCards:(UIButton *)sender {
    if ([self.game cardsLeft]) {
        self.numberOfCards +=3;
        for (int i = 0; i < 3; i++) {
            [self.game addCardsToExistingOnes];
        }
    }
    [self updateUI];
}


- (IBAction)pileCards:(UIPinchGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateChanged || sender.state == UIGestureRecognizerStateEnded) {
        CGPoint cntr = CGPointMake(self.cardSuperView.bounds.size.width/2, self.cardSuperView.bounds.size.height/2);
        self.cardsArePiled = YES;
        for (UIView *subView in self.viewsForCards) {
            [UIView animateWithDuration:1.0 animations:^{ subView.center = cntr;} completion:NULL];
        }
    }
}

- (IBAction)panCards:(UIPanGestureRecognizer *)sender {
    if (self.cardsArePiled) {
        CGPoint currentPanLoc = [sender locationInView:self.cardSuperView];
        if (!self.animatorForPan) {
            self.animatorForPan = [[UIDynamicAnimator alloc]initWithReferenceView:self.cardSuperView];
        }
        if (sender.state == UIGestureRecognizerStateBegan) {
            for (UIView *cardView in self.viewsForCards) {
                UIAttachmentBehavior *attach = [[UIAttachmentBehavior alloc]initWithItem:cardView attachedToAnchor:currentPanLoc];
                [self.animatorForPan addBehavior:attach];
            }
        }else if (sender.state == UIGestureRecognizerStateChanged){
            for (UIDynamicBehavior *bhvr in self.animatorForPan.behaviors) {
                if ([bhvr isKindOfClass:[UIAttachmentBehavior class]]) {
                    ((UIAttachmentBehavior *)bhvr).anchorPoint = currentPanLoc;
                }
            }
        } else if (sender.state == UIGestureRecognizerStateEnded){
            for (UIDynamicBehavior *bhvr in self.animatorForPan.behaviors) {
                if ([bhvr isKindOfClass:[UIAttachmentBehavior class]]) {
                    [self.animatorForPan removeBehavior:bhvr];
                }
            }
            for (UIView *subView in self.viewsForCards) {
                [UIView animateWithDuration:.5 animations:^{ subView.center = currentPanLoc;} completion:NULL];
            }
        }
        //        if (sender.state == UIGestureRecognizerStateBegan ||sender.state == UIGestureRecognizerStateChanged || sender.state == UIGestureRecognizerStateEnded){
        //            for (UIView *subView in self.viewsForCards) {
        //                subView.center = currentPanLoc;
        //           }
        //       }

    }
}
- (void)doDeal{
    self.game = nil;
    self.scoreLabel.text = DEFAULT_SCORE;
    for (UIView *subView in self.viewsForCards) {
        [UIView animateWithDuration:1.5 animations:^{ subView.center = CGPointMake(self.cardSuperView.bounds.size.width/2, self.cardSuperView.bounds.size.height-1);} completion:^(BOOL finished) { [subView removeFromSuperview];}];
    }
    self.viewsForCards = nil;
    self.cardsGrid = nil;
    self.animatorForPan = nil;
    if (self.isPlayingCardGame) {
        [self.game isTwoMatchMode:YES];
    }else{
        [self.game isTwoMatchMode:NO];
        self.numberOfCards = 12;
    }
    [self updateUI];
}
@end
