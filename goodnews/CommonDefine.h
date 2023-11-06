//
//  CommonDefine.h
//  goodnews
//
//  Created by KimJooYoung on 2015. 4. 29..
//  Copyright (c) 2015년 goodnews. All rights reserved.
//

#ifndef goodnews_CommonDefine_h
#define goodnews_CommonDefine_h


#define MAIN_URL @"http://m.goodnews.or.kr/XML/homeURLforGoodnewsApp.xml"
#define MAIN_KEY @"goodnews://"
#define MOVE_KEY @"pagemove://"
#define SAFARI_OPEN @"safariopen://"
#define PCVIEW @"pcview://"
#define HOME_KEY @"home://"


#define NTC	[NSNotificationCenter defaultCenter]
#define	NUD	[NSUserDefaults standardUserDefaults]

#define MAIN_SIZE() [UIScreen mainScreen].bounds.size

#define MAIN_APP_DELEGATE()	(AppDelegate *)[UIApplication sharedApplication].delegate

//색상관련.
#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#endif
