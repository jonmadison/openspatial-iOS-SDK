//
//  MainViewController.h
//  Example App
//
//  Created by Neel Bhoopalam on 6/9/14.
//  Copyright (c) 2014 Nod Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OpenSpatialBluetooth.h"

@interface MainViewController : UIViewController <OpenSpatialBluetoothDelegate>
@property (weak, nonatomic) IBOutlet UIView *viewDrawCanvas;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewCanvas;
@property (weak, nonatomic) IBOutlet UILabel *labelGestureLog;
@property (weak, nonatomic) IBOutlet UILabel *labelX;
@property (weak, nonatomic) IBOutlet UILabel *labelY;
@property OpenSpatialBluetooth *HIDServ;
@property CBPeripheral *lastNodPeripheral;

-(void) startLoop;
@end
