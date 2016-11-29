#### 2016-04-02 更新

* [+] 增加子类继承，子类实例使用``autoKVCBinding:``时，继承自父类的属性值同样会通过传入的字典绑定；

* [+] 属性值自动转换。属性值的自动转换类型主要指``NSString``到包括``NSInteger``、``CGFloat``、C语言中的自然类型的转换以及``NSNumber``到``NSString``转换；

* [+] 属性声明中类型为``VZItem``或其子类时，类实例被自动创建并被设置为其值；
* [+] 增加类方法``JSONKeyPathsByPropertyKey``，支持对字典的键值映射
。例如：
	
	```
	+ (NSDictionary *)JSONKeyPathsByPropertyKey {
		return @{@"skuTitle":@"skus.title",
				  @"skuMaxSize":@"skus.maxSize",
				  @"skus":@"skus.skuList"};
	}
	
	```
	需要注意的是，此方法并不会返回父类的键值映射配置，如果需要使用父级的键值映射，则使用以下方法进行合并：
	
	```
	+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	    NSMutableDictionary *ret = [[super JSONKeyPathsByPropertyKey] mutableCopy];
	    [ret addEntriesFromDictionary:@{@"skuTitle":@"skus.title",
	                                    @"skuMaxSize":@"skus.maxSize",
	                                    @"skus":@"skus.skuList"}];
	    return [ret copy];
	}
	
	```

* [+] 增加``VZ_ARRAY_TYPE``宏，同时支持属性声明中``NSArray<VZItem>``的初始化。其中``VZItem``可以为``VZItem``的任何子类。例如：
	
	文件 ``VZEPublishSKUItem.h``
	
	```
	@interface VZEPublishSKUItem : VZTableViewItem <NSCopying>
	
	@property (nonatomic, strong) NSString *skuId;
	@property (nonatomic, strong) NSArray *props;
	@property (nonatomic, assign) BOOL canDelete;
	
	- (void)merge:(VZEPublishSKUItem *)sourceItem;
	
	@end
	
	VZ_ARRAY_TYPE(VZEPublishSKUItem) //声明此类存在数组类
	
	```
	
	文件 ``VZEPublishItem.h``
	
	```
	@interface VZEPublishItem : VZTableViewItem
	
	@property (nonatomic, strong) NSString *itemId;
	@property (nonatomic, strong) NSString *title;
	@property (nonatomic, strong) NSString *desc;
	@property (nonatomic, strong) NSArray *images;
	
	...
	
	@property (nonatomic, assign) NSInteger skuMaxSize;
	@property (nonatomic, strong) NSString *skuTitle;
	@property (nonatomic, strong) NSArray<VZEPublishSKUItem> *skus; //此处声明数组项类型
	
	...
	
	@end
	```
	
	则 ``VZEPublishItem``实例化时会自动创建``skus``数组，且数组项为``VZEPublishSKUItem``，需要提醒的是，此语法为``protocol``语法，并不影响**泛型**语法的使用，你仍然可以使用泛型语法：
	
	```
	@property (nonatomic, strong) NSArray<VZEPublishSKUItem *> <VZEPublishSKUItem> *skus;
	```
	
* 传入字典中如果存在``NSNull``类实例，则属性设置为**空值**；
