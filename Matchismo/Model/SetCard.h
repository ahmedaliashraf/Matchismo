//
//  SetCard.h
//  Matchismo
//
//  Created by Ahmed Ali Ashraf on 10/11/15.
//  Copyright © 2015 CMP 464. All rights reserved.
//

#import "Card.h"

@interface SetCard : Card

@property (strong, nonatomic) NSString *symbol;
@property (strong, nonatomic) NSString *shade;
@property (strong, nonatomic) NSString *color;
@property (nonatomic) NSUInteger count;

+ (NSArray *)validSymbols;
+ (NSArray *)validShades;
+ (NSArray *)validColors;
+ (NSUInteger)maxCount;

//-(NSAttributedString *) getAttributedContents;
@end
