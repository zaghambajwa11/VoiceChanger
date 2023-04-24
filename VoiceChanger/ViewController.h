//
//  ViewController.h
//  VoiceChanger
//
//  Created by Zagham Arshad on 27/03/2023.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@interface ViewController : UIViewController<AVAudioRecorderDelegate, AVAudioPlayerDelegate>



@property (weak, nonatomic) IBOutlet UIButton *recordButton;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIButton *playNormalButton;
@property (weak, nonatomic) IBOutlet UIButton *playChipmunkButton;
@property (weak, nonatomic) IBOutlet UIButton *playRobotButton;
@property (weak, nonatomic) IBOutlet UIButton *playDarthVaderButton;


- (IBAction)recordTapped:(id)sender;
- (IBAction)playNormalTapped:(id)sender;
- (IBAction)playChipmunkTapped:(id)sender;
- (IBAction)playRobotTapped:(id)sender;
- (IBAction)playDarthVaderTapped:(id)sender;

@end

