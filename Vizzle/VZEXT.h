//
//  VZEXT.h
//  VZAsyncTemplate
//
//  Created by moxin.xt on 15-1-29.
//  Copyright (c) 2015年 VizLab. All rights reserved.
//

//语法糖(low level):

#ifndef VZAsyncTemplate_VZEXT_h
#define VZAsyncTemplate_VZEXT_h

#define vz_ext_stringify_(x) # x
#define vz_ext_concat_(x, y) x ## y
#define vz_ext_head_(FIRST, ...) FIRST
#define vz_ext_tail_(FIRST, ...) __VA_ARGS__
#define vz_ext_consume_(...)
#define vz_ext_expand_(...) __VA_ARGS__

#define vz_ext_args_at0(...) vz_ext_head_(__VA_ARGS__)
#define vz_ext_args_at1(_a, ...) vz_ext_head_(__VA_ARGS__)
#define vz_ext_args_at2(_a, _b, ...) vz_ext_head_(__VA_ARGS__)
#define vz_ext_args_at3(_a, _b, _c, ...) vz_ext_head_(__VA_ARGS__)
#define vz_ext_args_at4(_a, _b, _c, _d, ...) vz_ext_head_(__VA_ARGS__)
#define vz_ext_args_at5(_a, _b, _c, _d, _e, ...) vz_ext_head_(__VA_ARGS__)
#define vz_ext_args_at6(_a, _b, _c, _d, _e, _f, ...) vz_ext_head_(__VA_ARGS__)
#define vz_ext_args_at7(_a, _b, _c, _d, _e, _f, _g, ...) vz_ext_head_(__VA_ARGS__)
#define vz_ext_args_at8(_a, _b, _c, _d, _e, _f, _g, _h, ...) vz_ext_head_(__VA_ARGS__)
#define vz_ext_args_at9(_a, _b, _c, _d, _e, _f, _g, _h, _i, ...) vz_ext_head_(__VA_ARGS__)

#define vz_ext_args_first0(...)
#define vz_ext_args_first1(...) vz_ext_head_(__VA_ARGS__)
#define vz_ext_args_first2(...) vz_ext_head_(__VA_ARGS__), vz_ext_args_first1(vz_ext_tail_(__VA_ARGS__))
#define vz_ext_args_first3(...) vz_ext_head_(__VA_ARGS__), vz_ext_args_first2(vz_ext_tail_(__VA_ARGS__))
#define vz_ext_args_first4(...) vz_ext_head_(__VA_ARGS__), vz_ext_args_first3(vz_ext_tail_(__VA_ARGS__))
#define vz_ext_args_first5(...) vz_ext_head_(__VA_ARGS__), vz_ext_args_first4(vz_ext_tail_(__VA_ARGS__))
#define vz_ext_args_first6(...) vz_ext_head_(__VA_ARGS__), vz_ext_args_first5(vz_ext_tail_(__VA_ARGS__))
#define vz_ext_args_first7(...) vz_ext_head_(__VA_ARGS__), vz_ext_args_first6(vz_ext_tail_(__VA_ARGS__))
#define vz_ext_args_first8(...) vz_ext_head_(__VA_ARGS__), vz_ext_args_first7(vz_ext_tail_(__VA_ARGS__))
#define vz_ext_args_first9(...) vz_ext_head_(__VA_ARGS__), vz_ext_args_first8(vz_ext_tail_(__VA_ARGS__))

#define vz_ext_args_remove0(...) __VA_ARGS__
#define vz_ext_args_remove1(...) vz_ext_tail_(__VA_ARGS__)
#define vz_ext_args_remove2(...) vz_ext_args_remove1(vz_ext_tail_(__VA_ARGS__))
#define vz_ext_args_remove3(...) vz_ext_args_remove2(vz_ext_tail_(__VA_ARGS__))
#define vz_ext_args_remove4(...) vz_ext_args_remove3(vz_ext_tail_(__VA_ARGS__))
#define vz_ext_args_remove5(...) vz_ext_args_remove4(vz_ext_tail_(__VA_ARGS__))
#define vz_ext_args_remove6(...) vz_ext_args_remove5(vz_ext_tail_(__VA_ARGS__))
#define vz_ext_args_remove7(...) vz_ext_args_remove6(vz_ext_tail_(__VA_ARGS__))
#define vz_ext_args_remove8(...) vz_ext_args_remove7(vz_ext_tail_(__VA_ARGS__))
#define vz_ext_args_remove9(...) vz_ext_args_remove8(vz_ext_tail_(__VA_ARGS__))

#define vz_ext_if_eq0(x) vz_ext_concat_(vz_ext_if_eq0_, x)  //vz_ext_if_eq0(0)--> vz_ext_if_eq0_0
#define vz_ext_if_eq1(x) vz_ext_if_eq0(vz_ext_x_des(x))     //vz_ext_if_eq1(1)--> vz_ext_if_eq0(0)
#define vz_ext_if_eq2(x) vz_ext_if_eq1(vz_ext_x_des(x))     //vz_ext_if_eq2(2) --> vz_ext_if_eq1(1) --> z_ext_if_eq0(0)
#define vz_ext_if_eq3(x) vz_ext_if_eq2(vz_ext_x_des(x))
#define vz_ext_if_eq4(x) vz_ext_if_eq3(vz_ext_x_des(x))
#define vz_ext_if_eq5(x) vz_ext_if_eq4(vz_ext_x_des(x))
#define vz_ext_if_eq6(x) vz_ext_if_eq5(vz_ext_x_des(x))
#define vz_ext_if_eq7(x) vz_ext_if_eq6(vz_ext_x_des(x))
#define vz_ext_if_eq8(x) vz_ext_if_eq7(vz_ext_x_des(x))
#define vz_ext_if_eq9(x) vz_ext_if_eq8(vz_ext_x_des(x))

#define vz_ext_if_eq0_0(...) __VA_ARGS__
#define vz_ext_if_eq0_1(...) vz_ext_expand_
#define vz_ext_if_eq0_2(...) vz_ext_expand_
#define vz_ext_if_eq0_3(...) vz_ext_expand_
#define vz_ext_if_eq0_4(...) vz_ext_expand_
#define vz_ext_if_eq0_5(...) vz_ext_expand_
#define vz_ext_if_eq0_6(...) vz_ext_expand_
#define vz_ext_if_eq0_7(...) vz_ext_expand_
#define vz_ext_if_eq0_8(...) vz_ext_expand_
#define vz_ext_if_eq0_9(...) vz_ext_expand_
//


//public APIs


//////////Args//////////////

//返回第N个参数
#define vz_ext_args_at(N, ...) \
        vz_ext_concat_(vz_ext_args_at, N)(__VA_ARGS__)

//返回参数个数
#define vz_ext_args_count(...) \
        vz_ext_args_at(9, __VA_ARGS__, 9, 8, 7, 6, 5, 4, 3, 2, 1)

//第一个参数
#define vz_ext_args_head(...) \
        vz_ext_args_head_(__VA_ARGS__, 0)

//最后一个参数
#define vz_ext_args_tail(...) \
        vz_ext_tail_(__VA_ARGS__)

//取前N个参数
#define vz_ext_args_get_fisrt(N,...) \
        vz_ext_concat_(vz_ext_args_frist,N)(__VA_ARGS__)

//去掉前N个参数
#define vz_ext_args_remove_first(N,...)\
        vz_ext_concat_(vz_ext_args_remove,N)(__VA_ARGS__)

//////////Values//////////////

//0~9以内的数字-1
#define vz_ext_x_des(x) \
        vz_ext_args_at(x, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9)

//0~9以内的数字+1
#define vz_ext_x_asc(x) \
        vz_ext_args_at(x,1, 2, 3, 4, 5, 6, 7, 8, 9, 10)


//参数展开：
/**
 
 如果x = y，那么取第一个参数项，反之，取第二个

 条件：
 
 0<x<9 && 0<y<9 && y>x
 
 例子：
 
 vz_ext_if_eq(0,1)(a)(b) -> vz_ext_if_eq0(1) -> vz_ext_if_eq0_1(a)(b) = (b)
 
 vz_ext_if_eq(0,0)(a)(b) -> vz_ext_if_eq0(0) -> vz_ext_if_eq0_0(a)(b) = (a)
 
 调试:
 
 vz_ext_args_count(vz_ext_if_eq(0,0)(1,2,3)(0)) -> 3
 vz_ext_args_count(vz_ext_if_eq(0,1)(1,2,3)(0)) -> 1

 */
#define vz_ext_if_eq(x,y) \
        vz_ext_concat_(vz_ext_if_eq, x)(y)


//////////Keypath//////////////

/*
 返回对象的keypath && 编译器检查object的keypath是否正确
 
 例子：
 
 @vz_ext_keypath(self,window) -> @"window"
 @vz_ext_keypath(self.window) -> @"window"
 
 */

#define vz_ext_keypath(...) \
        vz_ext_if_eq(1,vz_ext_args_count(__VA_ARGS__))(vz_ext_keypath_1(__VA_ARGS__))(vz_ext_keypath_2(__VA_ARGS__))

#define vz_ext_keypath_1(PATH) \
(((void)(NO && ((void)PATH, NO)), strchr(# PATH, '.') + 1))

#define vz_ext_keypath_2(OBJ, PATH) \
(((void)(NO && ((void)OBJ.PATH, NO)), # PATH))


//////////Exit//////////////

/**
 
 在lexical scope最后执行一段代码
 
 原理：
 GCC:__attribute__ ((cleanup))
 https://gcc.gnu.org/onlinedocs/gcc/Variable-Attributes.html
 
 例子:
 
 {
    vz_ext_exit{
 
        NSLog(@"A");
    };
 
    NSLog(@"B");
 
 }
 
 输出顺序为 "B"  "A"
 
 */

typedef void (^vz_ext_cleanupBlock_t)();

static inline void vz_ext_executeCleanupBlock (__strong vz_ext_cleanupBlock_t *block) {
    (*block)();
}

#define vz_ext_exit \
        __strong vz_ext_cleanupBlock_t vz_ext_concat_(vz_ext_exitBlock_, __LINE__) __attribute__((cleanup(vz_ext_executeCleanupBlock), unused)) = ^



#endif