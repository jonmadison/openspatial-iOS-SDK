//
//  MainViewController.m
//  Example App
//
//  Created by Neel Bhoopalam on 6/9/14.
//  Copyright (c) 2014 Nod Labs. All rights reserved.
//

#import "MainViewController.h"

#define SWIPE_STEP 15
#define FACTOR 10.0
#define DRAW_WIDTH 2

@interface MainViewController ()
{
  NSInteger _imageWidth;
  NSInteger _imageHeight;
  UIImageView* _drawImageView;
  CGPoint drawLocation;
  CGPoint lastDrawPoint;
  CGPoint currentDrawPoint;
}

@end

@implementation MainViewController

uint8_t mode = POINTER_MODE;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    self.HIDServ = [OpenSpatialBluetooth sharedBluetoothServ];
    self.HIDServ.delegate = self;
  _imageWidth = _viewDrawCanvas.frame.size.width;
  _imageHeight = _viewDrawCanvas.frame.size.height;
  drawLocation = CGPointMake((_viewDrawCanvas.frame.origin.x +_imageWidth)/2, (_viewDrawCanvas.frame.origin.y + _imageHeight)/2);
  lastDrawPoint = drawLocation;
  _drawImageView = [[UIImageView alloc]initWithFrame:_viewDrawCanvas.frame];
  [_viewDrawCanvas addSubview:_drawImageView];
  [super viewDidLoad];
}

- (void) resetDrawing
{
  drawLocation = CGPointMake((_viewDrawCanvas.frame.origin.x +_imageWidth)/2, (_viewDrawCanvas.frame.origin.y + _imageHeight)/2);
  lastDrawPoint = drawLocation;
  _drawImageView = [[UIImageView alloc]initWithFrame:_viewDrawCanvas.frame];
  [_viewDrawCanvas addSubview:_drawImageView];
}

-(void) startLoop
{
    [self.HIDServ setMode:mode forDeviceNamed:self.lastNodPeripheral.name];
    if(mode == POINTER_MODE)
    {
        mode = THREE_D_MODE;
    }
    else
    {
        mode = POINTER_MODE;
    }
    [self performSelector:@selector(startLoop) withObject:nil afterDelay:5];
}

-(ButtonEvent *)buttonEventFired: (ButtonEvent *) buttonEvent
{
    NSLog(@"This is the value of button event type from %@", [buttonEvent.peripheral name]);
    switch([buttonEvent getButtonEventType])
    {
        case TOUCH0_DOWN:
            NSLog(@"Touch 0 Down");
            break;
        case TOUCH0_UP:
            NSLog(@"Touch 0 Up");
            break;
        case TOUCH1_DOWN:
            NSLog(@"Touch 1 Down");
            break;
        case TOUCH1_UP:
            NSLog(@"Touch 1 Up");
            break;
        case TOUCH2_DOWN:
            NSLog(@"Touch 2 Down");
            break;
        case TOUCH2_UP:
            NSLog(@"Touch 2 Up");
            break;
        case TACTILE0_DOWN:
            NSLog(@"Tactile 0 Down");
            break;
        case TACTILE0_UP:
            NSLog(@"Tactile 0 Up");
            break;
        case TACTILE1_DOWN:
            NSLog(@"Tactile 1 Down");
            break;
        case TACTILE1_UP:
            NSLog(@"Tactile 1 Up");
            break;
    }
    
    return nil;
}

-(PointerEvent *)pointerEventFired: (PointerEvent *) pointerEvent
{
    NSString* xStr = [NSString stringWithFormat:@"x from %@: %hd", [pointerEvent.peripheral name],[pointerEvent getXValue]];
    drawLocation = CGPointMake(drawLocation.x+([pointerEvent getXValue]/FACTOR), drawLocation.y);
    currentDrawPoint = drawLocation;
    [self drawSome];
    NSLog(@"%hd", [pointerEvent getXValue]);
    [_labelX setText:xStr];

    NSString* yStr = [NSString stringWithFormat:@"y from %@: %hd", [pointerEvent.peripheral name],[pointerEvent getYValue]];
    [_labelY setText:yStr];
    drawLocation = CGPointMake(drawLocation.x, drawLocation.y+([pointerEvent getYValue]/FACTOR));
    currentDrawPoint = drawLocation;
    [self drawSome];
    NSLog(@"%hd", [pointerEvent getYValue]);
    
    return nil;
}

-(GestureEvent *)gestureEventFired: (GestureEvent *) gestureEvent
{
    NSLog(@"This is the value of gesture event type from %@", [gestureEvent.peripheral name]);
    switch([gestureEvent getGestureEventType])
    {
        case SWIPE_UP:
            drawLocation = CGPointMake(drawLocation.x, drawLocation.y-SWIPE_STEP);
            currentDrawPoint = drawLocation;
            [self drawSome];
            [_labelGestureLog setText:@"Swipe Up"];
            NSLog(@"Gesture Up");
            break;
        case SWIPE_DOWN:
            drawLocation = CGPointMake(drawLocation.x, drawLocation.y+SWIPE_STEP);
            currentDrawPoint = drawLocation;
            [self drawSome];
            [_labelGestureLog setText:@"Swipe Down"];
            NSLog(@"Gesture Down");
            break;
        case SWIPE_LEFT:
            drawLocation = CGPointMake(drawLocation.x-SWIPE_STEP, drawLocation.y);
            currentDrawPoint = drawLocation;
            [self drawSome];
            [_labelGestureLog setText:@"Swipe Left"];
            NSLog(@"Gesture Left");
            break;
        case SWIPE_RIGHT:
            drawLocation = CGPointMake(drawLocation.x+SWIPE_STEP, drawLocation.y);
            currentDrawPoint = drawLocation;
          [self drawSome];
          [_labelGestureLog setText:@"Swipe Right"];
           NSLog(@"Gesture Right");
            break;
        case SLIDER_LEFT:
            [_labelGestureLog setText:@"Slider Left"];
            NSLog(@"Slider Left");
            break;
        case SLIDER_RIGHT:
            [_labelGestureLog setText:@"Slider Right"];
            NSLog(@"Slider Right");
            break;
        case CCW:
            [_labelGestureLog setText:@"Counter Clockwise"];
        //clear image
        [self resetDrawing];
           NSLog(@"Counter Clockwise");
            break;
        case CW:
            [_labelGestureLog setText:@"Clockwise"];
            NSLog(@"Clockwise");
            break;
    }
    
    return nil;
}

-(RotationEvent *)rotationEventFired:(RotationEvent *)rotationEvent
{
    NSLog(@"This is the x value of the quaternion from %@", [rotationEvent.peripheral name]);
    NSLog(@"%f", rotationEvent.x);
    
    NSLog(@"This is the y value of the quaternion from %@", [rotationEvent.peripheral name]);
    NSLog(@"%f", rotationEvent.y);

    NSLog(@"This is the z value of the quaternion from %@", [rotationEvent.peripheral name]);
    NSLog(@"%f", rotationEvent.z);

    NSLog(@"This is the roll value of the quaternion from %@", [rotationEvent.peripheral name]);
    NSLog(@"%f", rotationEvent.roll);

    NSLog(@"This is the pitch value of the quaternion from %@", [rotationEvent.peripheral name]);
    NSLog(@"%f", rotationEvent.pitch);

    NSLog(@"This is the yaw value of the quaternion from %@", [rotationEvent.peripheral name]);
    NSLog(@"%f", rotationEvent.yaw);
    
    return nil;
}

- (void) didConnectToNod: (CBPeripheral*) peripheral
{
    NSLog(@"here");
    self.lastNodPeripheral = peripheral;
  [self.HIDServ subscribeToButtonEvents:self.lastNodPeripheral.name];
  [self.HIDServ subscribeToGestureEvents:self.lastNodPeripheral.name];
  [self.HIDServ subscribeToPointerEvents:self.lastNodPeripheral.name];
  [self.HIDServ subscribeToRotationEvents:self.lastNodPeripheral.name];
}

- (IBAction)subscribeEvents:(UIButton *)sender
{
    [self.HIDServ subscribeToButtonEvents:self.lastNodPeripheral.name];
    [self.HIDServ subscribeToGestureEvents:self.lastNodPeripheral.name];
    [self.HIDServ subscribeToPointerEvents:self.lastNodPeripheral.name];
    [self.HIDServ subscribeToRotationEvents:self.lastNodPeripheral.name];
}

- (void)drawSome
{
  UIGraphicsBeginImageContext(CGSizeMake(_imageWidth, _imageHeight));
  [_drawImageView.image drawInRect:CGRectMake(0, 0, _imageWidth, _imageHeight)];
  CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
  CGContextSetLineWidth(UIGraphicsGetCurrentContext(), DRAW_WIDTH);
  CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0.4, 0.3, 0.8, 1);
  CGContextBeginPath(UIGraphicsGetCurrentContext());
  CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastDrawPoint.x, lastDrawPoint.y);
  CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentDrawPoint.x, currentDrawPoint.y);
  CGContextStrokePath(UIGraphicsGetCurrentContext());
  
  [_drawImageView setFrame:CGRectMake(0, 0, _imageWidth, _imageHeight)];
  _drawImageView.image = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  lastDrawPoint = currentDrawPoint;
  [_viewDrawCanvas addSubview:_drawImageView];
}
@end
