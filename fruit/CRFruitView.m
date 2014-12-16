//
//  CRFruitView.m
//  fruit
//
//  Created by croath on 12/15/14.
//  Copyright (c) 2014 Croath. All rights reserved.
//

#import "CRFruitView.h"

@interface CRFruitView()

@property (nonatomic, assign) BOOL animating;
@property (nonatomic, assign) NSInteger currentInt;
@property (nonatomic, assign) NSInteger lastInt;
@property (nonatomic, strong) NSMutableArray *numArray;
@property (nonatomic, strong) NSMutableDictionary *waitingDict;
@property (nonatomic, strong) dispatch_queue_t fruitQ;

@end

@implementation CRFruitView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setClipsToBounds:YES];
        self.incrementRoll = YES;
        self.downRoll = YES;
        self.charAnimationDuration = 0.3;
        self.waitingDict = [NSMutableDictionary dictionary];
        self.numArray = [NSMutableArray array];
        self.fruitQ = dispatch_queue_create("com.croath.crfruitview.fruitq", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

- (void)setInteger:(NSInteger)integer{
    NSLog(@"%ld", (long)integer);
    dispatch_async(self.fruitQ, ^{
        dispatch_suspend(self.fruitQ);
        self.lastInt = self.currentInt;
        self.currentInt = integer;
        
        NSString *currentStr = [NSString stringWithFormat:@"%ld", (long)self.currentInt];
        NSString *lastStr = [NSString stringWithFormat:@"%ld", (long)self.lastInt];
        
        BOOL currentIsLonger = currentStr.length>lastStr.length?YES:NO;
        NSInteger enumLength = currentIsLonger?currentStr.length:lastStr.length;
        
        [self.waitingDict removeAllObjects];
        for (int i = 0; i < enumLength; i++) {
            NSString *currentChar = @"";
            NSString *lastChar = @"";
            if (currentIsLonger) {
                currentChar = [currentStr substringWithRange:NSMakeRange(currentStr.length-i-1, 1)];
                if (i < lastStr.length) {
                    lastChar = [lastStr substringWithRange:NSMakeRange(lastStr.length-i-1, 1)];
                }
            } else {
                lastChar = [lastStr substringWithRange:NSMakeRange(lastStr.length-i-1, 1)];
                if (i < currentStr.length) {
                    currentChar = [currentStr substringWithRange:NSMakeRange(currentStr.length-i-1, 1)];
                }
            }
            
            NSMutableArray *array = [NSMutableArray array];
            
            if ([lastChar isEqualToString:@""] || [currentChar isEqualToString:@""]) {
                [array addObject:currentChar];
            } else {
                NSInteger currentNum = [currentChar integerValue];
                NSInteger lastNum = [lastChar integerValue];
                if (self.incrementRoll) {
                    if (currentNum >= lastNum) {
                        for (int j = (int)lastNum + 1; j <= currentNum; j ++) {
                            [array addObject:[NSString stringWithFormat:@"%ld", (long)j]];
                        }
                    } else {
                        for (int j = (int)lastNum + 1; j <= 9; j ++) {
                            [array addObject:[NSString stringWithFormat:@"%ld", (long)j]];
                        }
                        for (int j = 0; j <= currentNum; j ++) {
                            [array addObject:[NSString stringWithFormat:@"%ld", (long)j]];
                        }
                    }
                } else {
                    if (currentNum <= lastNum) {
                        for (int j = (int)lastNum - 1; j >= currentNum; j --) {
                            [array addObject:[NSString stringWithFormat:@"%ld", (long)j]];
                        }
                    } else {
                        for (int j = (int)lastNum - 1; j >= 0; j --) {
                            [array addObject:[NSString stringWithFormat:@"%ld", (long)j]];
                        }
                        for (int j = 9; j >= currentNum; j --) {
                            [array addObject:[NSString stringWithFormat:@"%ld", (long)j]];
                        }
                    }
                }
            }
            
            [self.waitingDict setObject:array forKey:@(i)];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self startAnimation];
        });
    });
}

- (void)startAnimation{
    NSString *currentStr = [NSString stringWithFormat:@"%ld", (long)self.currentInt];
    NSString *lastStr = [NSString stringWithFormat:@"%ld", (long)self.lastInt];
    
    BOOL currentIsLonger = currentStr.length>lastStr.length?YES:NO;
    NSInteger enumLength = currentIsLonger?currentStr.length:lastStr.length;
    
    for (int i = 0; i < (int)enumLength; i ++) {
        NSArray *array = [self.waitingDict objectForKey:@(i)];
        
        if (i >= [self.numArray count]) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, self.charSize.width, self.charSize.height)];
            [label setCenter:CGPointMake(self.bounds.size.width-(i+0.5)*label.bounds.size.width-(i+1)*self.horizontalMargin,
                                         label.bounds.size.height/2.0)];
            [self.numArray addObject:label];
            [self addSubview:label];
        }
        
        if ([array count] == 0) {
            continue;
        }
        
        UILabel *label = [self.numArray objectAtIndex:i];
        
        [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            UILabel *l = [[UILabel alloc] initWithFrame:label.bounds];
            NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:obj attributes:self.textAttr];
            [l setAttributedText:attrStr];
            if (self.downRoll) {
                [l setCenter:CGPointMake(label.center.x, label.center.y - (idx+1)*(self.verticalMargin + l.bounds.size.height))];
            } else {
                [l setCenter:CGPointMake(label.center.x, label.center.y + (idx+1)*(self.verticalMargin + l.bounds.size.height))];
            }
            [self addSubview:l];
            
            [l setAlpha:0.0];
            @autoreleasepool {
                [UIView animateWithDuration:self.charAnimationDuration*array.count animations:^{
                    if (self.downRoll) {
                        [l setCenter:CGPointMake(l.center.x, l.center.y+array.count*(self.verticalMargin + l.bounds.size.height))];
                    } else {
                        [l setCenter:CGPointMake(l.center.x, l.center.y-array.count*(self.verticalMargin + l.bounds.size.height))];
                    }
                    [l setAlpha:1.0];
                } completion:^(BOOL finished) {
                    [l removeFromSuperview];
                }];
            }
        }];
        
        CGPoint oriCenter = label.center;
        
        dispatch_suspend(self.fruitQ);
        [UIView animateWithDuration:self.charAnimationDuration*array.count animations:^{
            if (self.downRoll) {
                [label setCenter:CGPointMake(label.center.x,
                                             label.center.y+array.count*(self.verticalMargin + label.bounds.size.height))];
            } else {
                [label setCenter:CGPointMake(label.center.x,
                                             label.center.y-array.count*(self.verticalMargin + label.bounds.size.height))];
            }
        } completion:^(BOOL finished) {
            NSString *str = @"";
            if ([array lastObject]) {
                str = [array lastObject];
            }
            NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:str attributes:self.textAttr];
            [label setAttributedText:attrStr];
            [label setCenter:oriCenter];
            dispatch_resume(self.fruitQ);
        }];
    }
    dispatch_resume(self.fruitQ);
}

@end
