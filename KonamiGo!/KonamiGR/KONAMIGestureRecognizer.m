//
//  KONAMIGestureRecognizer.m
//  KonamiGo!
//
//  Created by Eric Ito on 4/5/14.
//  Copyright (c) 2014 Eric Ito. All rights reserved.
//

#import "KONAMIGestureRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>

/*
 debug, will show HUD when each step is done
 
 play noise from Capcom?
 */

#define UP_DOWN_SWIPE_HORIZONTAL_THRESHOLD 15
#define LEFT_RIGHT_SWIPE_VERTICAL_THRESHOLD 15

typedef enum : NSUInteger {
//    KONAMICodeStateNone,
    KONAMICodeStateFirstUp,
    KONAMICodeStateSecondUp,
    KONAMICodeStateFirstDown,
    KONAMICodeStateSecondDown,
    KONAMICodeStateFirstLeft,
    KONAMICodeStateFirstRight,
    KONAMICodeStateSecondLeft,
    KONAMICodeStateSecondRight,
//    KONAMICodeStateB,
//    KONAMICodeStateA,
    KONAMICodeStateRecognized
} KONAMICodeState;

@interface KONAMIGestureRecognizer () {
    KONAMICodeState _konamiCodeState;
    NSMutableArray *_touchPoints;
    
    CGPoint _startPoint;
    CGPoint _endPoint;
}
@end

@implementation KONAMIGestureRecognizer

-(id)init {
    self = [super init];
    if (self) {
        _konamiCodeState = KONAMICodeStateFirstUp;
    }
    return self;
}

#pragma mark -
#pragma mark Misc


#pragma mark -
#pragma mark Overrides

-(void)reset {
    [super reset];
    _konamiCodeState = KONAMICodeStateFirstUp;
}

#pragma mark -
#pragma mark Actions

-(void)advanceToNextState {
    switch (_konamiCodeState) {
//        case KONAMICodeStateNone:
//            _konamiCodeState = KONAMICodeStateFirstUp;
//            break;
        case KONAMICodeStateFirstUp:
            _konamiCodeState = KONAMICodeStateSecondUp;
            break;
        case KONAMICodeStateSecondUp:
            _konamiCodeState = KONAMICodeStateFirstDown;
            break;
        case KONAMICodeStateFirstDown:
            _konamiCodeState = KONAMICodeStateSecondDown;
            break;
        case KONAMICodeStateSecondDown:
            _konamiCodeState = KONAMICodeStateFirstLeft;
            break;
        case KONAMICodeStateFirstLeft:
            _konamiCodeState = KONAMICodeStateFirstRight;
            break;
        case KONAMICodeStateFirstRight:
            _konamiCodeState = KONAMICodeStateSecondLeft;
            break;
        case KONAMICodeStateSecondLeft:
            _konamiCodeState = KONAMICodeStateSecondRight;
            break;
        case KONAMICodeStateSecondRight:
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(failGR) object:nil];
            _konamiCodeState = KONAMICodeStateRecognized;
            self.state = UIGestureRecognizerStateRecognized;
            break;
        default:
            break;
    }
}

-(BOOL)recognizedCurrentState {
    if (_konamiCodeState == KONAMICodeStateFirstUp ||
        _konamiCodeState == KONAMICodeStateSecondUp) {
        // check if swiped up
        return (_endPoint.y < _startPoint.y) && (fabs(_startPoint.x - _endPoint.x) < UP_DOWN_SWIPE_HORIZONTAL_THRESHOLD);
    }
    else if (_konamiCodeState == KONAMICodeStateFirstDown ||
             _konamiCodeState == KONAMICodeStateSecondDown) {
        // check if swiped down
        return (_endPoint.y > _startPoint.y) && (fabs(_startPoint.x - _endPoint.x) < UP_DOWN_SWIPE_HORIZONTAL_THRESHOLD);
    }
    else if (_konamiCodeState == KONAMICodeStateFirstLeft ||
             _konamiCodeState == KONAMICodeStateSecondLeft) {
        // check if swiped left
        return (_endPoint.x < _startPoint.x) && (fabs(_startPoint.y - _endPoint.y) < LEFT_RIGHT_SWIPE_VERTICAL_THRESHOLD);
    }
    else if (_konamiCodeState == KONAMICodeStateFirstRight ||
             _konamiCodeState == KONAMICodeStateSecondRight) {
        // check if swiped right
        return (_endPoint.x > _startPoint.x) && (fabs(_startPoint.y - _endPoint.y) < LEFT_RIGHT_SWIPE_VERTICAL_THRESHOLD);
    }
    
    return NO;
}

-(void)failGR {
    self.state = UIGestureRecognizerStateFailed;
    NSLog(@"Failing our GR due to inactivity");
}

#pragma mark -
#pragma mark Touches

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    // cancel any previous selectors that would fail our GR
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(failGR) object:nil];
    
    UITouch *touch = [touches anyObject];
    _startPoint = [touch locationInView:self.view];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    _endPoint = [touch locationInView:self.view];

    if ([self recognizedCurrentState]) {
        // if nothing happens again before 1.0 seconds, we fail our GR
        [self performSelector:@selector(failGR) withObject:nil afterDelay:1.0];
        
        NSLog(@"advancing to next state");
        [self advanceToNextState];
    }
    else {
        NSLog(@"Failing because not recognized");
        self.state = UIGestureRecognizerStateFailed;
    }
}
@end
