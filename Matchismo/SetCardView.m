//
//  SetCardView.m
//  Matchismo
//
//  Created by Ultimate on 11/3/15.
//  Copyright (c) 2015 CMP 464. All rights reserved.
//

#import "SetCardView.h"

@implementation SetCardView

#pragma mark - properties

- (void)setSymbol:(NSString *)symbol{
    _symbol = symbol;
    [self setNeedsDisplay];
}

- (void)setColor:(NSString *)color{
    _color = color;
    [self setNeedsDisplay];
}

- (void)setShade:(NSString *)shade{
    _shade = shade;
    [self setNeedsDisplay];
}

- (void)setCount:(NSUInteger)count{
    _count = count;
    [self setNeedsDisplay];
}

- (void)setChosen:(BOOL)chosen{
    _chosen = chosen;
    [self setNeedsDisplay];
}

#pragma mark - Neccessary Constants

float const CORNER_RADIUS = 0.1;
float const OFFSET_FOR_SYMBOL = 0.3;
float const WIDTH_OF_SYMBOL_LINE = 0.02;
float const HEIGHT_OF_SYMBOL = 0.5;
float const WIDTH_OF_SYMBOL = 0.2;
float const AMOUNT_OF_CURVE = 0.8;
float const OFFSET_FOR_SHADE = 0.05;

#pragma mark - Create symbols

-(void)makeDiamondWithPoint:(CGPoint) point{
    CGFloat preferredWidth = self.bounds.size.width * WIDTH_OF_SYMBOL/2.0;
    CGFloat preferredHeight = self.bounds.size.height *HEIGHT_OF_SYMBOL/2.0;
    UIBezierPath *path = [[UIBezierPath alloc]init];
    [path moveToPoint:CGPointMake(point.x, point.y-preferredHeight)];
    [path addLineToPoint:CGPointMake(point.x-preferredWidth, point.y)];
    [path addLineToPoint:CGPointMake(point.x, point.y+preferredHeight)];
    [path addLineToPoint:CGPointMake(point.x+preferredWidth, point.y)];
    [path closePath];
    path.lineWidth = self.bounds.size.width * WIDTH_OF_SYMBOL_LINE;
    [path stroke];
    [self shadeForPath:path];
}

- (void)makeSquiggleWithPoint:(CGPoint) point{
    CGFloat preferredWidth = self.bounds.size.width * WIDTH_OF_SYMBOL / 2.0;
    CGFloat preferredHeight = self.bounds.size.height *(HEIGHT_OF_SYMBOL-.1) / 2.0;
    CGFloat preferredCurveW = preferredWidth * AMOUNT_OF_CURVE;
    CGFloat preferredCurveH = preferredHeight * AMOUNT_OF_CURVE;
    UIBezierPath *path = [[UIBezierPath alloc]init];
    [path moveToPoint:CGPointMake(point.x-preferredWidth, point.y-preferredHeight)];
    [path addQuadCurveToPoint:CGPointMake(point.x+preferredWidth, point.y-preferredHeight) controlPoint:CGPointMake(point.x-preferredCurveW, point.y-preferredCurveH-preferredHeight)];
    [path addCurveToPoint:CGPointMake(point.x+preferredWidth, point.y+preferredHeight) controlPoint1:CGPointMake(point.x+preferredWidth+preferredCurveW, point.y-preferredHeight+preferredCurveH) controlPoint2:CGPointMake(point.x+preferredWidth-preferredCurveW, point.y+preferredHeight-preferredCurveH)];
    [path addQuadCurveToPoint:CGPointMake(point.x-preferredWidth, point.y+preferredHeight) controlPoint:CGPointMake(point.x+preferredCurveW, point.y+preferredCurveH+preferredHeight)];
    [path addCurveToPoint:CGPointMake(point.x-preferredWidth, point.y-preferredHeight) controlPoint1:CGPointMake(point.x-preferredWidth-preferredCurveW, point.y+preferredHeight-preferredCurveH) controlPoint2:CGPointMake(point.x-preferredWidth+preferredCurveW, point.y-preferredHeight+preferredCurveH)];
    path.lineWidth = self.bounds.size.width * WIDTH_OF_SYMBOL_LINE;
    [path stroke];
    [self shadeForPath:path];
}

- (void)makeOvalWithPoint:(CGPoint)point{
    CGFloat preferredWidth = self.bounds.size.width * WIDTH_OF_SYMBOL/2.0;
    CGFloat preferredHeight = self.bounds.size.height *HEIGHT_OF_SYMBOL/2.0;
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(point.x-preferredWidth, point.y-preferredHeight, preferredWidth*2, preferredHeight*2) cornerRadius:preferredWidth];
    path.lineWidth = self.bounds.size.width * WIDTH_OF_SYMBOL_LINE;
    [path stroke];
    [self shadeForPath:path];
}

#pragma mark - methods for drawing

- (UIColor *)getSymbolColor{
    if ([self.color isEqualToString:@"green"]) {
        return [UIColor greenColor];
    } else if ([self.color isEqualToString:@"red"]){
        return [UIColor redColor];
    } else if ([self.color isEqualToString:@"purple"]){
        return [UIColor purpleColor];
    } else{
        return nil;
    }
}

- (void)makeSymbolWithPoint:(CGPoint)point{
    if ([self.symbol isEqualToString:@"diamond"]) {
        [self makeDiamondWithPoint:point];
    } else if ([self.symbol isEqualToString:@"squiggle"]){
        [self makeSquiggleWithPoint:point];
    } else if ([self.symbol isEqualToString:@"oval"]){
        [self makeOvalWithPoint:point];
    } else{
        nil;
    }
}

- (void)shadeForPath: (UIBezierPath *)path{
    if ([self.shade isEqualToString:@"open"]) {
        [[UIColor clearColor]setFill];
        [path fill];
    } else if ([self.shade isEqualToString:@"solid"]){
        [[self getSymbolColor]setFill];
        [path fill];
    } else if ([self.shade isEqualToString:@"striped"]){
        CGContextRef graphicContext = UIGraphicsGetCurrentContext();
        CGContextSaveGState(graphicContext);
        [path addClip];
        UIBezierPath *shadePaths = [[UIBezierPath alloc] init];
        CGPoint first = self.bounds.origin;
        CGPoint last = first;
        CGFloat preferredOffset = self.bounds.size.height * OFFSET_FOR_SHADE;
        last.x += self.bounds.size.width;
        first.y += preferredOffset;
        for (int i = 0; i < 1 / OFFSET_FOR_SHADE; i++) {
            [shadePaths moveToPoint:first];
            [shadePaths addLineToPoint:last];
            first.y += preferredOffset;
            last.y += preferredOffset;
        }
        shadePaths.lineWidth = self.bounds.size.width / 2 * WIDTH_OF_SYMBOL_LINE;
        [shadePaths stroke];
        CGContextRestoreGState(UIGraphicsGetCurrentContext());
    } else{
        nil;
    }
    
}

- (void)drawSymbolOnce{
    CGPoint center = CGPointMake(self.bounds.size.width / 2.0, self.bounds.size.height / 2.0);
    [self makeSymbolWithPoint:center];
}
- (void)drawSymbolTwice{
    CGPoint center = CGPointMake(self.bounds.size.width / 2.0, self.bounds.size.height / 2.0);
    CGFloat preferredSymbolOffset = self.bounds.size.width * OFFSET_FOR_SYMBOL;
    [self makeSymbolWithPoint:CGPointMake(center.x-preferredSymbolOffset/2, center.y)];
    [self makeSymbolWithPoint:CGPointMake(center.x+preferredSymbolOffset/2, center.y)];
}
- (void)drawSymbolThrice{
    CGPoint center = CGPointMake(self.bounds.size.width / 2.0, self.bounds.size.height / 2.0);
    CGFloat preferredSymbolOffset = self.bounds.size.width * OFFSET_FOR_SYMBOL;
    [self makeSymbolWithPoint:center];
    [self makeSymbolWithPoint:CGPointMake(center.x-preferredSymbolOffset, center.y)];
    [self makeSymbolWithPoint:CGPointMake(center.x+preferredSymbolOffset, center.y)];
}

#pragma mark - Drawing

- (CGFloat)cornerRadius{return CORNER_RADIUS * self.bounds.size.width;}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect{
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:[self cornerRadius]];
    [roundedRect addClip];
    [[UIColor whiteColor]setFill];
    UIRectFill(self.bounds);
    
    if (self.chosen) {
//        [self setBackgroundColor:[UIColor orangeColor]];//[UIColor colorWithPatternImage:[UIImage imageNamed:@"selectedCardFront"]
        [[UIColor darkGrayColor]setStroke];
        roundedRect.lineWidth = 3;
    } else{
        [[UIColor clearColor]setStroke];
        roundedRect.lineWidth = 3;
    }
    [roundedRect stroke];
    [self drawSymbol];
}

- (void)drawSymbol{
    [[self getSymbolColor]setStroke];
    if (self.count == 1) {
        [self drawSymbolOnce];
    } else if (self.count == 2){
        [self drawSymbolTwice];
    } else if (self.count == 3){
        [self drawSymbolThrice];
    }else{
        nil;
    }
}

#pragma mark - Initialization

-(void)setup{
    self.backgroundColor = nil;
    self.opaque = NO;
    self.contentMode = UIViewContentModeRedraw;
}
-(void)awakeFromNib{
    [self setup];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setup];
    }
    return self;
}



@end
