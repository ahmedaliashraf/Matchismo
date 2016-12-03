//
//  SetCard.m
//  Matchismo
//
//  Created by Ahmed Ali Ashraf on 10/11/15.
//  Copyright © 2015 CMP 464. All rights reserved.
//

#import "SetCard.h"

@implementation SetCard

#pragma mark - properties

@synthesize symbol = _symbol, color = _color, shade = _shade;

- (NSString *)symbol{
    return _symbol ? _symbol: @"?";
}

- (void)setSymbol:(NSString *)symbol{
    if ([[SetCard validSymbols] containsObject:symbol]) {
        _symbol = symbol;
    }
}

- (NSString *)color{
    return _color ? _color: @"?";
}

- (void)setColor:(NSString *)color{
    if ([[SetCard validColors] containsObject:color]) {
        _color = color;
    }
}

- (NSString *)shade{
    return _shade ? _shade: @"?";
}

- (void)setShade:(NSString *)shade{
    if ([[SetCard validShades] containsObject:shade]) {
        _shade = shade;
    }
}

- (void)setCount:(NSUInteger)count{
    if (count <= [SetCard maxCount]) {
        _count = count;
    }
}

#pragma mark - possibilties for properties

+ (NSArray *)validSymbols{
    return @[@"oval", @"squiggle", @"diamond"];
}
+ (NSArray *)validColors{
    return @[@"red", @"green", @"purple"];
}
+ (NSArray *)validShades{
    return @[@"solid", @"open", @"striped"];
}
+ (NSUInteger)maxCount{
    return 3;
}

#pragma mark - contents of card & matching

- (NSString *)contents{
    return [NSString stringWithFormat:@"%@:%@:%@:%u",self.symbol,self.color,self.shade,self.count];
}

- (int)match:(NSArray *)otherCards
{
    int score = 0;
    
    if ([otherCards count] == 2){
        SetCard *otherCard = [otherCards firstObject];
        SetCard *otherCard2 =[otherCards objectAtIndex:1];
        if ((self.count == otherCard.count && self.count == otherCard2.count) || (self.count != otherCard.count && self.count != otherCard2.count && otherCard.count != otherCard2.count)) {
            if (([self.shade isEqualToString:otherCard.shade] && [self.shade isEqualToString:otherCard2.shade]) || (![self.shade isEqualToString:otherCard.shade] && ![self.shade isEqualToString:otherCard2.shade] && ![otherCard.shade isEqualToString:otherCard2.shade])) {
                if (([self.color isEqualToString:otherCard.color] && [self.color isEqualToString:otherCard2.color]) || (![self.color isEqualToString:otherCard.color] && ![self.color isEqualToString:otherCard2.color] && ![otherCard.color isEqualToString:otherCard2.color])){
                    if (([self.symbol isEqualToString:otherCard.symbol] && [self.symbol isEqualToString:otherCard2.symbol]) || (![self.symbol isEqualToString:otherCard.symbol] && ![self.symbol isEqualToString:otherCard2.symbol] && ![otherCard.symbol isEqualToString:otherCard2.symbol])){
                        score = 10;
                    }
                }
            }
        }
    }
    return score;
}

@end
