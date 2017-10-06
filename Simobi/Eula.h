//
//  Eula.h
//  Simobi
//
//  Created by Ravi on 12/24/13.
//  Copyright (c) 2013 Mfino. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol EulaDelegate <NSObject>
@required
- (void) confirmAction;
- (void) cancelAction;

@end

@interface Eula : UIView {

}

@property (nonatomic,assign)id <EulaDelegate> delegate;
;
@end
