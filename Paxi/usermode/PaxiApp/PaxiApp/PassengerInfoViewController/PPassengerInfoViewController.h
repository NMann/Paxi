//
//  PPassengerInfoViewController.h
//  PaxiApp
//
//  Created by TarunMahajan on 10/07/14.
//  Copyright (c) 2014 Deftsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PPassengerInfoViewController : UIViewController<UITextFieldDelegate>
{
    BOOL ispickerShow;
}
@property(nonatomic,strong)NSString *date;
@property(nonatomic,strong)NSString *cardType;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *flightNoTextField;
@property (weak, nonatomic) IBOutlet UITextField *destinationTextField;
@property (weak, nonatomic) IBOutlet UITextField *passengerNameTextField;
@property (weak, nonatomic) IBOutlet UIButton *departureDateButton;
@property (weak, nonatomic) IBOutlet UIView *pickerView;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
- (IBAction)m_CancelButtonPressed:(id)sender;
- (IBAction)m_Done:(id)sender;
- (IBAction)m_DepartureDateButtonPressed:(id)sender;
- (IBAction)m_DateSelected:(id)sender;
- (IBAction)m_LocationButtonPressed:(id)sender;
- (IBAction)m_PickUpButtonPressed:(id)sender;

@end
