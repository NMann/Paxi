//
//  PCardInfoVC.h
//  PaxiApp
//
//  Created by TarunMahajan on 15/07/14.
//  Copyright (c) 2014 Deftsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PCardInfoVC : UIViewController<UIGestureRecognizerDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    BOOL ispickerShow;
}
@property(nonatomic,strong)NSString *date;
@property(nonatomic,strong)NSString *cardType;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *accountNoTextField;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UIPickerView *datePicker;
@property (weak, nonatomic) IBOutlet UITextField *cvcTextField;
@property (weak, nonatomic) IBOutlet UIButton *dateButton;
@property (weak, nonatomic) IBOutlet UIButton *cardTypeButton;
@property (weak, nonatomic) IBOutlet UIView *pickerView;
@property (weak, nonatomic) IBOutlet UITableView *cardTypeTableView;

- (IBAction)m_CardTypeButtonPressed:(id)sender;
- (IBAction)m_DateButtonPressed:(id)sender;
- (IBAction)m_DoneButtonPressed:(id)sender;
- (IBAction)m_DateSelected:(id)sender;
- (IBAction)m_CancelButtonPressed:(id)sender;
- (IBAction)m_Done:(id)sender;
- (IBAction)m_validateCard:(id)sender;

@property(nonatomic,strong)NSMutableDictionary *userInfoDictionary;
@end
