//
//  CRFruitView.h
//  fruit
//
//  Created by croath on 12/15/14.
//  Copyright (c) 2014 Croath. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CRFruitView : UIView

/*
 Margin between 2 animation characters.
 */
@property (nonatomic, assign) CGFloat verticalMargin;

/*
 Margin between 2 characters.
 */
@property (nonatomic, assign) CGFloat horizontalMargin;

/*
 Bounds size for one character.
 */
@property (nonatomic, assign) CGSize charSize;

/*
 Label's text's attributed dictionary.
 */
@property (nonatomic, strong) NSDictionary *textAttr;

/*
 Rolling animation number increment or not. Default YES.
 */
@property (nonatomic, assign) BOOL incrementRoll;

/*
 Rolling direction down or up. Default YES.
 */
@property (nonatomic, assign) BOOL downRoll;

/*
 Animation time(seconds) of animating one single character. Default 0.3.
 */
@property (nonatomic, assign) NSTimeInterval charAnimationDuration;

- (void)setInteger:(NSInteger)integer;

@end
