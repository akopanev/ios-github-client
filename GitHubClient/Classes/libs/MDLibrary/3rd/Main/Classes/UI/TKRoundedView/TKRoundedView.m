//
//  TKRoundedView.m
//  TKRoundedView
//
//  Created by Tomasz Kuźma on 1/6/13.
//  Copyright (c) 2013 Tomasz Kuźma. All rights reserved.
//

#import "TKRoundedView.h"

@interface TKRoundedView () {
    CGColorSpaceRef		_colorSpace;
    CGFloat				*_locationsTable;
    CFArrayRef			_cfColors;
    CGGradientRef		_gradient;
}
@end

@implementation TKRoundedView

#pragma mark - Initialization

- (void)dealloc{
    if(_locationsTable != NULL)
        free(_locationsTable);
    
    if (_cfColors != NULL) {
        CFRelease(_cfColors);
    }
    
    if (_colorSpace != NULL) {
        CGColorSpaceRelease(_colorSpace);
    }
    
    if (_gradient != NULL) {
        CGGradientRelease(_gradient);
    }
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (!self)return nil;
    
    [self commonInit];
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (!self)return nil;
    
    [self commonInit];
    
    return self;
}

- (void)commonInit{
    
    self.opaque = NO;
    self.backgroundColor = [UIColor clearColor];
    self.contentMode = UIViewContentModeRedraw;
    
    _gradientDirection = TKGradientDirectionVertical;
    _fillColor = [UIColor clearColor];
    _borderColor = [UIColor lightGrayColor];
    _cornerRadius = 8.0f;
    _borderWidth = 1.0f;
    _roundedCorners = TKRoundedCornerAll;
    _drawnBordersSides = TKDrawnBorderSidesAll;
    
}

#pragma mark - Drawing

- (void)drawRect:(CGRect)rect {
	
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGFloat halfLineWidth = _borderWidth / 2.0f;
    
    CGFloat topInsets = _drawnBordersSides & TKDrawnBorderSidesTop ? halfLineWidth : 0.0f;
    CGFloat leftInsets = _drawnBordersSides & TKDrawnBorderSidesLeft ? halfLineWidth : 0.0f;
    CGFloat rightInsets = _drawnBordersSides & TKDrawnBorderSidesRight ? halfLineWidth : 0.0f;
    CGFloat bottomInsets = _drawnBordersSides & TKDrawnBorderSidesBottom ? halfLineWidth : 0.0f;
    
    UIEdgeInsets insets = UIEdgeInsetsMake(topInsets, leftInsets, bottomInsets, rightInsets);
    
    CGRect properRect = UIEdgeInsetsInsetRect(rect, insets);
    
    /* Setup line width */
    CGContextSetLineWidth(ctx, 0.0f);
    
    
    // Add and fill rect
    [self addPathToContext:ctx inRect:properRect respectDrawnBorder:NO];
    
    // Close the path
    CGContextClosePath(ctx);
    
    if (_gradientColorsAndLocations.count) {
        CGContextSaveGState(ctx);
        CGContextClip(ctx);
        [self drawGradientToContext:ctx inRect:rect];
        CGContextRestoreGState(ctx);
    }
    else{
        // Fill and Stroke path
        CGContextSetFillColorWithColor(ctx, _fillColor.CGColor);
        CGContextDrawPath(ctx, kCGPathFill);
    }
    
    /* Setup colors and line width */
    CGContextSetStrokeColorWithColor(ctx, _borderColor.CGColor);
    CGContextSetLineWidth(ctx, _borderWidth);
    
    // Add and stroke rect
    [self addPathToContext:ctx inRect:properRect respectDrawnBorder:YES];
    
    // Fill and Stroke path
    CGContextDrawPath(ctx, kCGPathStroke);
    
}

- (void)addPathToContext:(CGContextRef)ctx inRect:(CGRect)rect respectDrawnBorder:(BOOL)respectDrawnBorders{
    
    CGFloat minx = CGRectGetMinX(rect);
    CGFloat midx = CGRectGetMidX(rect);
    CGFloat maxx = CGRectGetMaxX(rect);
    
    CGFloat miny = CGRectGetMinY(rect);
    CGFloat midy = CGRectGetMidY(rect);
    CGFloat maxy = CGRectGetMaxY(rect);
    

    CGContextMoveToPoint(ctx, minx, midy);
    
    /* Top Left Corner */
    if (_roundedCorners & TKRoundedCornerTopLeft) {
        CGContextAddArcToPoint(ctx, minx, miny, midx, miny, _cornerRadius);
        CGContextAddLineToPoint(ctx, midx, miny);
    }
    else{
        
        if (_drawnBordersSides & TKDrawnBorderSidesLeft || !respectDrawnBorders){
            CGContextAddLineToPoint(ctx, minx, miny);
        }
        else{
            CGContextDrawPath(ctx, kCGPathStroke);
            CGContextMoveToPoint(ctx, minx, miny);
        }
        
        if (_drawnBordersSides & TKDrawnBorderSidesTop  || !respectDrawnBorders){
            CGContextAddLineToPoint(ctx, midx, miny);
        }
        else{
            CGContextDrawPath(ctx, kCGPathStroke);
            CGContextMoveToPoint(ctx, midx, miny);
        }
    }
    
    /* Top Right Corner */
    if (_roundedCorners & TKRoundedCornerTopRight) {
        CGContextAddArcToPoint(ctx, maxx, miny, maxx, midy, _cornerRadius);
        CGContextAddLineToPoint(ctx, maxx, midy);
    }
    else{
        
        if (_drawnBordersSides & TKDrawnBorderSidesTop  || !respectDrawnBorders){
            CGContextAddLineToPoint(ctx, maxx, miny);
        }
        else{
            CGContextDrawPath(ctx, kCGPathStroke);
            CGContextMoveToPoint(ctx, maxx, miny);
        }
        
        if (_drawnBordersSides & TKDrawnBorderSidesRight  || !respectDrawnBorders){
            CGContextAddLineToPoint(ctx, maxx, midy);
        }
        else{
            CGContextDrawPath(ctx, kCGPathStroke);
            CGContextMoveToPoint(ctx, maxx, midy);
        }
    }
    
    /* Bottom Right Corner */
    if (_roundedCorners & TKRoundedCornerBottomRight) {
        CGContextAddArcToPoint(ctx, maxx, maxy, midx, maxy, _cornerRadius);
        CGContextAddLineToPoint(ctx, midx, maxy);
        
    }
    else{
        
        if (_drawnBordersSides & TKDrawnBorderSidesRight  || !respectDrawnBorders){
            CGContextAddLineToPoint(ctx, maxx, maxy);
        }
        else{
            CGContextDrawPath(ctx, kCGPathStroke);
            CGContextMoveToPoint(ctx, maxx, maxy);
        }
        
        if (_drawnBordersSides & TKDrawnBorderSidesBottom  || !respectDrawnBorders){
            CGContextAddLineToPoint(ctx, midx, maxy);
        }
        else{
            CGContextDrawPath(ctx, kCGPathStroke);
            CGContextMoveToPoint(ctx, midx, maxy);
        }
    }
    
    /* Bottom Left Corner */
    if (_roundedCorners & TKRoundedCornerBottomLeft) {
        CGContextAddArcToPoint(ctx, minx, maxy, minx, midy, _cornerRadius);
        CGContextAddLineToPoint(ctx, minx, midy);
    }
    else{
        
        if (_drawnBordersSides & TKDrawnBorderSidesBottom  || !respectDrawnBorders){
            CGContextAddLineToPoint(ctx, minx, maxy);
        }
        else{
            CGContextDrawPath(ctx, kCGPathStroke);
            CGContextMoveToPoint(ctx, minx, maxy);
        }
        
        if (_drawnBordersSides & TKDrawnBorderSidesLeft  || !respectDrawnBorders){
            CGContextAddLineToPoint(ctx, minx, midy);
        }
        else{
            CGContextMoveToPoint(ctx, minx, midy);
            CGContextDrawPath(ctx, kCGPathStroke);
        }
        
    }
    
}

- (void)drawGradientToContext:(CGContextRef)ctx inRect:(CGRect)rect{
    
    if (_gradient == NULL) {
        _gradient = CGGradientCreateWithColors(_colorSpace,_cfColors, _locationsTable);
    }
    
    CGPoint startPoint = CGPointZero;
    CGPoint endPoint = CGPointZero;
    
    switch (_gradientDirection) {
        case TKGradientDirectionVertical:
            startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
            endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
            break;
        case TKGradientDirectionHorizontal:
            startPoint = CGPointMake(CGRectGetMinX(rect), CGRectGetMidY(rect));
            endPoint = CGPointMake(CGRectGetMaxX(rect), CGRectGetMidY(rect));
            break;
        case TKGradientDirectionDown:
            startPoint = CGPointMake(CGRectGetMinX(rect), CGRectGetMinY(rect));
            endPoint = CGPointMake(CGRectGetMaxX(rect), CGRectGetMaxY(rect));
            break;
        case TKGradientDirectionUp:
            startPoint = CGPointMake(CGRectGetMaxX(rect), CGRectGetMaxY(rect));
            endPoint = CGPointMake(CGRectGetMinX(rect), CGRectGetMinY(rect));
            break;
            
        default:
            break;
    }
    
    CGContextSaveGState(ctx);
    CGContextAddRect(ctx, rect);
    CGContextClip(ctx);
    CGContextDrawLinearGradient(ctx, _gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(ctx);
    
}

#pragma mark - Setters

- (void)setDrawnBordersSides:(TKDrawnBorderSides)drawnBordersSides{
    _drawnBordersSides = drawnBordersSides;
    [self setNeedsDisplay];
}

- (void)setRoundedCorners:(TKRoundedCorner)roundedCorners{
    _roundedCorners = roundedCorners;
    [self setNeedsDisplay];
}

- (void)setBorderColor:(UIColor *)borderColor{
    if (_borderColor != borderColor) {
        _borderColor = borderColor;
        [self setNeedsDisplay];
    }
}

- (void)setFillColor:(UIColor *)fillColor{
    if (_fillColor != fillColor) {
        _fillColor = fillColor;
        [self setNeedsDisplay];
    }
}

- (void)setGradientColorsAndLocations:(NSArray *)gradientColorsAndLocations{
    if (_gradientColorsAndLocations != gradientColorsAndLocations) {
        _gradientColorsAndLocations = gradientColorsAndLocations;
        [self prepareGradient];
        [self setNeedsDisplay];
    }
}

- (void)setGradientDirection:(TKGradientDirection)gradientDirection{
    if (_gradientDirection != gradientDirection) {
        _gradientDirection = gradientDirection;
        [self setNeedsDisplay];
    }
}

- (void)setBorderWidth:(CGFloat)borderWidth{
    _borderWidth = borderWidth;
    [self setNeedsDisplay];
}

- (void)setCornerRadius:(CGFloat)cornerRadius{
    _cornerRadius = cornerRadius;
    [self setNeedsDisplay];
}

#pragma mark - Private

- (void)prepareGradient{
    NSMutableArray *colors = [NSMutableArray arrayWithCapacity:_gradientColorsAndLocations.count];
    NSMutableArray *locations = [NSMutableArray arrayWithCapacity:_gradientColorsAndLocations.count];
    
    for (NSDictionary *dictionary in self.gradientColorsAndLocations) {
        if ([dictionary isKindOfClass:[NSDictionary class]]) {
            for (NSString *key in dictionary) {
                id object = dictionary[key];
                if ([object isKindOfClass:[NSNumber class]]) {
                    [locations addObject:object];
                }
                else if ([object isKindOfClass:[UIColor class]]){
                    [colors addObject:object];
                }
            }
        }
    }
    
    if (colors.count == locations.count) {
        
        if (_colorSpace == NULL) {
            _colorSpace = CGColorSpaceCreateDeviceRGB();
        }
        
        NSInteger count = locations.count;
        
        
        if (_locationsTable != NULL) {
            free(_locationsTable);
        }
        
        _locationsTable = malloc((size_t) sizeof(CGFloat) * count);
        
        CFMutableArrayRef cfColorsMutable = CFArrayCreateMutable(kCFAllocatorDefault, count, &kCFTypeArrayCallBacks);
        
        for(int i = 0; i < count; i++){
            NSNumber *locationNumber = locations[i];
            _locationsTable[i] = [locationNumber floatValue];
            CGColorRef color = [colors[i] CGColor];
            CFArrayAppendValue(cfColorsMutable, color);
        }
        
        if (_cfColors != NULL) {
            CFRelease(_cfColors);
        }
        _cfColors = CFArrayCreateCopy(kCFAllocatorDefault, cfColorsMutable);
        
        CFRelease(cfColorsMutable);
        
        if (_gradient != NULL) {
            CGGradientRelease(_gradient);
            _gradient = NULL;
        }
    }
}

#pragma mark -

#pragma mark -

- (void)setPositionType:(MDPositionType)positionType {
	_positionType = positionType;
	switch (_positionType) {
		case MDPositionTop: {
			self.roundedCorners = TKRoundedCornerTop;
			self.drawnBordersSides = TKDrawnBorderSidesAllButBottom;
			break;
		}
			
		case MDPositionMiddle: {
			self.roundedCorners = TKRoundedCornerNone;
			self.drawnBordersSides = TKDrawnBorderSidesAllButBottom;
			break;
		}
			
		case MDPositionBottom: {
			self.roundedCorners = TKRoundedCornerBottom;
			self.drawnBordersSides = TKDrawnBorderSidesAll;
			break;
		}
			
		default: {
			self.roundedCorners = TKRoundedCornerAll;
			self.drawnBordersSides = TKDrawnBorderSidesAll;
			break;
		}
	}
}

@end
