//
//  ViewController.m
//  VoiceChanger
//
//  Created by Zagham Arshad on 27/03/2023.
//

#import "ViewController.h"

@interface ViewController ()
@property (strong, nonatomic) AVAudioRecorder *audioRecorder;
@property (strong, nonatomic) AVAudioPlayer *audioPlayer;
@property (strong, nonatomic) NSURL *recordedAudioURL;
@property (strong, nonatomic) AVAudioEngine *audioEngine;
@end

@implementation ViewController

- (void)viewDidLoad {
    [self setupAudioSession];
    [self setupAudioRecorder];
    self.audioEngine = [[AVAudioEngine alloc] init];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)setupAudioSession {
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *error;
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
    [session setActive:NO error:&error];
}

- (void)setupAudioRecorder {
    // Set the audio file path
    NSArray *pathComponents = @[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject], @"voiceRecording.m4a"];
    self.recordedAudioURL = [NSURL fileURLWithPathComponents:pathComponents];
    
    NSLog(@"File path: %@", self.recordedAudioURL.path);

    // Setup audio settings
    NSDictionary *settings = @{AVFormatIDKey: @(kAudioFormatMPEG4AAC),
                               AVSampleRateKey: @12000.0,
                               AVNumberOfChannelsKey: @1,
                               AVEncoderAudioQualityKey: @(AVAudioQualityHigh)};
    
    NSError *error;
    self.audioRecorder = [[AVAudioRecorder alloc] initWithURL:self.recordedAudioURL settings:settings error:&error];
    
    if (error) {
        NSLog(@"Error setting up audio recorder: %@", error.localizedDescription);
    } else {
        self.audioRecorder.delegate = self;
        [self.audioRecorder prepareToRecord];
    }
}

#pragma mark - Button Actions

- (IBAction)recordTapped:(id)sender {
    if (self.audioRecorder.isRecording) {
        [self.audioRecorder stop];
        [self.recordButton setTitle:@"Start Recording" forState:UIControlStateNormal];
        self.statusLabel.text = @"Recording stopped";
    } else {
        [self.audioRecorder record];
        [self.recordButton setTitle:@"Stop Recording" forState:UIControlStateNormal];
        self.statusLabel.text = @"Recording in progress...";
    }
}

- (IBAction)playNormalTapped:(id)sender {
    [self playAudioWithPitch:1.0];
}

- (IBAction)playChipmunkTapped:(id)sender {
    [self playAudioWithPitch:1800.0];
}

- (IBAction)playRobotTapped:(id)sender {
    [self playAudioWithPitch:-1000.0];
}

- (IBAction)playDarthVaderTapped:(id)sender {
    [self playAudioWithPitch:-1500.0];
}

- (void)playAudioWithPitch:(float)pitch {
    NSError *error;
    AVAudioPlayerNode *playerNode = [[AVAudioPlayerNode alloc] init];
    AVAudioUnitTimePitch *pitchEffect = [[AVAudioUnitTimePitch alloc] init];
    pitchEffect.pitch = pitch;

    // Add the player node and pitch effect to the audio engine
    [self.audioEngine attachNode:playerNode];
    [self.audioEngine attachNode:pitchEffect];

    // Connect the player node to the pitch effect and the pitch effect to the output node
    [self.audioEngine connect:playerNode to:pitchEffect format:nil];
    [self.audioEngine connect:pitchEffect to:self.audioEngine.outputNode format:nil];

    NSURL *audioFileURL = self.recordedAudioURL;
    AVAudioFile *audioFile = [[AVAudioFile alloc] initForReading:audioFileURL error:&error];

    if (error) {
        NSLog(@"Error opening audio file: %@", error.localizedDescription);
    } else {
        // Schedule the audio file to play on the player node
        [playerNode scheduleFile:audioFile atTime:nil completionHandler:nil];

        // Start the audio engine and player node
        [self.audioEngine startAndReturnError:&error];
        [playerNode play];
    }
}


@end
