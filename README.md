## Vizzle

[![Build Status](https://travis-ci.org/Vizzle/Vizzle.svg?branch=master)](https://travis-ci.org/Vizzle/Vizzle)
[![Version](https://img.shields.io/cocoapods/v/Vizzle.svg?style=flat)](http://cocoapods.org/pods/Vizzle)
[![License](https://img.shields.io/cocoapods/l/Vizzle.svg?style=flat)](http://cocoapods.org/pods/Vizzle)
[![Platform](https://img.shields.io/cocoapods/p/Vizzle.svg?style=flat)](http://cocoapods.org/pods/Vizzle)

Vizzle is an iOS MVC framework inspired by Ruby on Rails and Three20.

### Features

- Vizzle is designed based on the idea of "convention over configuration" which allows developers write minimium code to make everything work properly
- Vizzle makes a very heavy abstraction for both model and controller layers, providing a single direciton data flow.
- Vizzle seperates the business logic layer from the foundation layer by inserting an adapter layer in the middle.

> Vizzle has been heavily used to implement O2O features in Alipay Wallet since 2016. It has been battle tested and proved stable for more than two years with millions of users visit per day. 
            
### How to use 

Vizzle is distributed using Cocoapods

```shell
pod 'Vizzle'
```

To add Vizzle to your project, you can choose to use the umbrella header in `.pch` file

```objc
//Precompile.pch
#import <Vizzle/Vizzle.h>
```

### License

All source code is licensed under the [MIT License](https://raw.githubusercontent.com/rs/SDWebImage/master/LICENSE).