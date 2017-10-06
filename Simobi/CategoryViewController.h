//
//  CategoryViewController.h
//  Simobi
//
//  Created by Ravi on 10/15/13.
//  Copyright (c) 2013 Mfino. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"


typedef enum {
    ParentClass_Purchase = 101,
    ParentClass_Payment
}ParentClass;


typedef enum {
    FieldType_Category = 1,
    FieldType_Biller,
    FieldType_Product

}FieldType;



@interface CategoryViewController : BaseViewController<UIPickerViewDataSource,UIPickerViewDelegate,UIActionSheetDelegate>

- (IBAction)dropDownBtnAction:(id)sender;

@property (retain,nonatomic) UIActionSheet *actionSheet;
@property (retain,nonatomic) UIPickerView *pickerView;
@property (retain,nonatomic) UIToolbar *pickerToolbar;
@property (assign) FieldType fieldType;
@property (assign) ParentClass parentClass;

@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (weak, nonatomic) IBOutlet UILabel *categoriesLBL;
@property (weak, nonatomic) IBOutlet UILabel *billerLBL;
@property (weak, nonatomic) IBOutlet UILabel *productLBL;

@property (weak, nonatomic)  IBOutlet UITextField *categoryField;
@property (weak, nonatomic)  IBOutlet UITextField *productField;
@property (weak, nonatomic)  IBOutlet UITextField *billerField;

@property (weak, nonatomic) IBOutlet UIView *bgView;
- (IBAction)submitButtonAction:(id)sender;

- (instancetype)initWithParentClass:(ParentClass)parent;

@end


