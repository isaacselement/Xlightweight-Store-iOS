#import "LWViewController.h"
#import "TlStoreProxy.h"
#import "TlUserFiles.h"
#import "TlStoreManager.h"

@interface HkUserDefaults : NSUserDefaults

@end

@implementation HkUserDefaults

- (id)objectForKey:(NSString *)defaultName {
    id value = [super objectForKey:defaultName];
    return value;
}

- (void)setObject:(id)value forKey:(NSString *)defaultName {
    [super setObject:value forKey:defaultName];
}

- (void)setInteger:(NSInteger)value forKey:(NSString *)defaultName {
    [super setInteger:value forKey:defaultName];
}

@end

@interface LWViewController ()

@end

@implementation LWViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        button.frame = CGRectMake(20, 80, 110, 40);
        [button setTitle:@"Click me reset" forState:UIControlStateNormal];
        if (@available(iOS 14.0, *)) {
            [button addAction:[UIAction actionWithHandler:^(__kindof UIAction * _Nonnull action) {
                [self setupData];
            }] forControlEvents:UIControlEventTouchUpInside];
        } else {
            // Fallback on earlier versions
        }
        [self.view addSubview:button];
    }
    
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        button.frame = CGRectMake(20, 120, 110, 40);
        [button setTitle:@"Click me delete" forState:UIControlStateNormal];
        if (@available(iOS 14.0, *)) {
            [button addAction:[UIAction actionWithHandler:^(__kindof UIAction * _Nonnull action) {
                [self deleteData];
            }] forControlEvents:UIControlEventTouchUpInside];
        } else {
            [button addTarget:self action:@selector(deleteData) forControlEvents:UIControlEventTouchUpInside];
        }
        [self.view addSubview:button];
    }
    
#pragma mark -
    
    NSLog(@"Library path: %@", NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES));
    
    NSString *path = nil;
    BOOL isExisted = [[NSFileManager defaultManager] fileExistsAtPath:path];
    NSLog(@"Crash or not: %d", isExisted);
    
    [self setupData];
}

#define kWithDate(str) [NSString stringWithFormat:@"%@: %@", [self nowDateString], str]
#define kWithIndex(str, i) [NSString stringWithFormat:@"%@[%d]", str, i]

- (NSString *)nowDateString {
    NSDateFormatter *_f = [[NSDateFormatter alloc] init];
    _f.dateFormat = @"yyyy/MM/dd HH:mm:ss";
    return [_f stringFromDate:[NSDate date]];
}

- (void)setupData {
    /// MARK: NSUserDefaults Testcase
    {
        HkUserDefaults *store = [[HkUserDefaults alloc] init];
        
        [store setObject:kWithDate(@"You are so good 🐶 你是个好人 💯") forKey:@"STRING"];
        NSString *vS = [store stringForKey:@"STRING"];
        
        [store setInteger:10086 forKey:@"LONG"];
        NSInteger vI = [store integerForKey:@"LONG"];
        
        [store setFloat:3.001f forKey:@"FLOAT"];
        float vF = [store floatForKey:@"FLOAT"];
        
        [store setDouble:1.12345601888 forKey:@"DOUBLE"];
        double vD = [store doubleForKey:@"DOUBLE"];
        NSString *vDS = [store stringForKey:@"DOUBLE"];
        
        [store setBool:NO forKey:@"BOOLEAN"];
        BOOL vB = [store boolForKey:@"BOOLEAN"];
        
        NSLog(@"---->>>>>ORIGINAL: %@, %ld, %.3f, %.10g: %@, %d", vS, vI, vF, vD, vDS, vB);
    }
    
    /// MARK: TlStoreProxy Testcase - without encryption/decryption
    {
        NSString *key = nil;
        NSString *iv = nil;
        TlStoreProxy *store = [[TlStoreProxy alloc] initWithName:@"check_me_cleartext" aesKey:key aesIV:iv];
        
        [store setString:kWithDate(@"You are so good 🐶 你是个好人 💯") forKey:@"STRING"];
        NSString *vS = [store stringForKey:@"STRING"];
        
        [store setInteger:10086 forKey:@"LONG"];
        NSInteger vI = [store integerForKey:@"LONG"];
        
        [store setFloat:3.001f forKey:@"FLOAT"];
        float vF = [store floatForKey:@"FLOAT"];
        
        [store setDouble:1.12345601888 forKey:@"DOUBLE"];
        double vD = [store doubleForKey:@"DOUBLE"];
        NSString *vDS = [store stringForKey:@"DOUBLE"];
        
        [store setBool:NO forKey:@"BOOLEAN"];
        BOOL vB = [store boolForKey:@"BOOLEAN"];
        
        NSLog(@"---->>>>>CLEARING: %@, %ld, %.3f, %.10g: %@, %d", vS, vI, vF, vD, vDS, vB);
    }
    
    /// MARK: TlStoreProxy Testcase - with encryption/decryption
    {
        NSString *key = @"12345678901234567890123456789012";
        NSString *iv = @"abcdef";
        TlStoreProxy *store = [[TlStoreProxy alloc] initWithName:@"check_me_encrypted" aesKey:key aesIV:iv];
        
        [store setString:kWithDate(@"You are so good 🐶 你是个好人 💯") forKey:@"STRING"];
        NSString *vS = [store stringForKey:@"STRING"];
        
        [store setInteger:10086 forKey:@"LONG"];
        NSInteger vI = [store integerForKey:@"LONG"];
        
        [store setFloat:3.001f forKey:@"FLOAT"];
        float vF = [store floatForKey:@"FLOAT"];
        
        [store setDouble:1.12345601888 forKey:@"DOUBLE"];
        double vD = [store doubleForKey:@"DOUBLE"];
        NSString *vDS = [store stringForKey:@"DOUBLE"];
        
        [store setBool:NO forKey:@"BOOLEAN"];
        BOOL vB = [store boolForKey:@"BOOLEAN"];
        
        NSLog(@"---->>>>>ENCRYPTS: %@, %ld, %.3f, %.10g: %@, %d", vS, vI, vF, vD, vDS, vB);
    }
    
    /// MARK: TlUserFiles Testcase - without encryption/decryption
    {
        NSString *key = nil;
        NSString *iv = nil;
        TlUserFiles *store = [[TlUserFiles alloc] initWithName:@"check_me_file" aesKey:key aesIV:iv];
        
        [store setString:kWithDate(@"You are so good 🐶 你是个好人 💯") forKey:@"STRING"];
        NSString *vS = [store stringForKey:@"STRING"];
        
        [store setInteger:10086 forKey:@"LONG"];
        NSInteger vI = [store integerForKey:@"LONG"];
        
        [store setFloat:3.001f forKey:@"FLOAT"];
        float vF = [store floatForKey:@"FLOAT"];
        
        [store setDouble:1.12345601888 forKey:@"DOUBLE"];
        double vD = [store doubleForKey:@"DOUBLE"];
        NSString *vDS = [store stringForKey:@"DOUBLE"];
        
        [store setBool:NO forKey:@"BOOLEAN"];
        BOOL vB = [store boolForKey:@"BOOLEAN"];
        
        NSLog(@"---->>>>>FILETEXT: %@, %ld, %.3f, %.10g: %@, %d", vS, vI, vF, vD, vDS, vB);
    }
    
    /// MARK: TlUserFiles Testcase - with encryption/decryption
    {
        NSString *key = @"12345678901234567890123456789012";
        NSString *iv = @"abcdef";
        TlUserFiles *store = [[TlUserFiles alloc] initWithName:@"check_me_file" aesKey:key aesIV:iv];
        
        [store setString:kWithDate(@"You are so good 🐶 你是个好人 💯") forKey:@"STRING"];
        NSString *vS = [store stringForKey:@"STRING"];
        
        [store setInteger:10086 forKey:@"LONG"];
        NSInteger vI = [store integerForKey:@"LONG"];
        
        [store setFloat:3.001f forKey:@"FLOAT"];
        float vF = [store floatForKey:@"FLOAT"];
        
        [store setDouble:1.12345601888 forKey:@"DOUBLE"];
        double vD = [store doubleForKey:@"DOUBLE"];
        NSString *vDS = [store stringForKey:@"DOUBLE"];
        
        [store setBool:NO forKey:@"BOOLEAN"];
        BOOL vB = [store boolForKey:@"BOOLEAN"];
        
        NSLog(@"---->>>>>FILETEXT: %@, %ld, %.3f, %.10g: %@, %d", vS, vI, vF, vD, vDS, vB);
    }
    
    /// MARK: Minxin
    {
        for (int i = 0; i < 3; i++) {
            NSString *key = @"12345678901234567890123456789012";
            NSString *iv = @"abcdef";
            NSString *module = @"check_me_mixin";
            TlStoreProxy *store = [[TlStoreProxy alloc] initWithName:module aesKey:key aesIV:iv];
            if (i == 1) {
                ((TlStoreBase *)store.myProxy).keyTransformer = nil;
            }
            if (i == 2) {
                ((TlStoreBase *)store.myProxy).keyTransformer = nil;
                ((TlStoreBase *)store.myProxy).valueEncoder = nil;
                ((TlStoreBase *)store.myProxy).valueDecoder = nil;
            }
            [store setString:kWithDate(@"You are so good 🐶 你是个好人 💯") forKey:kWithIndex(@"STRING", i)];
            NSString *vS = [store stringForKey:kWithIndex(@"STRING", i)];
            
            [store setInteger:10086 forKey:kWithIndex(@"LONG", i)];
            NSInteger vI = [store integerForKey:kWithIndex(@"LONG", i)];
            
            [store setFloat:3.001f forKey:kWithIndex(@"FLOAT", i)];
            float vF = [store floatForKey:kWithIndex(@"FLOAT", i)];
            
            [store setDouble:1.12345601888 forKey:kWithIndex(@"DOUBLE", i)];
            double vD = [store doubleForKey:kWithIndex(@"DOUBLE", i)];
            NSString *vDS = [store stringForKey:kWithIndex(@"DOUBLE", i)];
            
            [store setBool:NO forKey:kWithIndex(@"BOOLEAN", i)];
            BOOL vB = [store boolForKey:kWithIndex(@"BOOLEAN", i)];
            
            NSLog(@"---->>>>>[TlStoreProxy][Minxin][%d]: %@, %ld, %.3f, %.10g: %@, %d", i, vS, vI, vF, vD, vDS, vB);
        }
    }
    
    /// MARK: Manager
    {
        NSString *key = @"12345678901234567890123456789012";
        NSString *iv = @"abcdef";
        NSString *module = @"check_me_manager";
        [[TlStoreManager instance] registration:module aesKey:key aesIV:iv isKeepKeyClearText:YES];
        TlStoreManager *store = [TlStoreManager instance];
        [store setString:module forKey:@"STRING" value:kWithDate(@"You are so good 🐶 你是个好人 💯")];
        NSString *vS = [store getString:module forKey:@"STRING"];
        
        [store setInt:module forKey:@"LONG" value: 10086];
        NSInteger vI = [store getInt:module forKey:@"LONG"];
        
        [store setFloat:module forKey:@"FLOAT" value:3.001f];
        float vF = [store getFloat:module forKey:@"FLOAT"];
        
        [store setDouble:module forKey:@"DOUBLE" value:1.12345601888 ];
        double vD = [store getDouble:module forKey:@"DOUBLE"];
        NSString *vDS = [store getString:module forKey:@"DOUBLE"];
        
        [store setBoolean:module forKey:@"BOOLEAN" value:YES];
        BOOL vB = [store getBoolean:module forKey:@"BOOLEAN"];
        
        NSLog(@"---->>>>>Manager: %@, %ld, %.3f, %.10g: %@, %d", vS, vI, vF, vD, vDS, vB);
    }
}

- (void)deleteData {
    {
        HkUserDefaults *store = [[HkUserDefaults alloc] init];
        [store removeObjectForKey:@"STRING"];
        NSString *log = [NSString stringWithFormat:@"%@, %d", [store stringForKey:@"STRING"], [store stringForKey:@"STRING"] == nil];
        NSLog(@"---->>>>>HkUserDefaults: %@", log);
    }
    {
        NSString *key = nil;
        NSString *iv = nil;
        TlStoreProxy *store = [[TlStoreProxy alloc] initWithName:@"check_me_cleartext" aesKey:key aesIV:iv];
        [store removeKey:@"STRING"];
        NSString *log = [NSString stringWithFormat:@"%@, %d", [store stringForKey:@"STRING"], [store stringForKey:@"STRING"] == nil];
        NSLog(@"---->>>>>TlStoreProxy: %@", log);
    }
    {
        NSString *key = @"12345678901234567890123456789012";
        NSString *iv = @"abcdef";
        TlStoreProxy *store = [[TlStoreProxy alloc] initWithName:@"check_me_encrypted" aesKey:key aesIV:iv];
        [store removeKey:@"STRING"];
        NSString *log = [NSString stringWithFormat:@"%@, %d", [store stringForKey:@"STRING"], [store stringForKey:@"STRING"] == nil];
        NSLog(@"---->>>>>TlStoreProxy: %@", log);
    }
    {
        NSString *key = nil;
        NSString *iv = nil;
        TlUserFiles *store = [[TlUserFiles alloc] initWithName:@"check_me_file" aesKey:key aesIV:iv];
        [store removeKey:@"STRING"];
        NSString *log = [NSString stringWithFormat:@"%@, %d", [store stringForKey:@"STRING"], [store stringForKey:@"STRING"] == nil];
        NSLog(@"---->>>>>TlUserFiles: %@", log);
    }
    {
        NSString *key = @"12345678901234567890123456789012";
        NSString *iv = @"abcdef";
        TlUserFiles *store = [[TlUserFiles alloc] initWithName:@"check_me_file" aesKey:key aesIV:iv];
        [store removeKey:@"STRING"];
        NSString *log = [NSString stringWithFormat:@"%@, %d", [store stringForKey:@"STRING"], [store stringForKey:@"STRING"] == nil];
        NSLog(@"---->>>>>TlUserFiles: %@", log);
    }
}

@end
