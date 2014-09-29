#STSOData

A template and reusable MVC framework for the native iOS OData SAP Mobile SDK 

##A template app, and reusable framework
We’ve been working with the new 3.0 SP05 API set for several months now, and some common usage patterns have developed around the core application components, best practices for MVC, etc. I’ve encapsulated these in a helper template called STSOData, and am making it available both as an example, and also as a reusable framework to app developers using the SDK. 

The STSOData code is not a standard product framework, but it does a lot of the bootstrapping of the core application components with the SDK that you’re going to need anyway. So, it should really speed your development, and let you take advantage of some great features without learning too much about the lower level details of the core APIs.

I want to stress that use of this framework is not mandatory with the SP05 version of the SDK, and you can feel free to modify or throw away parts or all of it, as your application architecture requires. I also want to point out that this code is not indicative of gaps in the API, but is really a stylistic enhancement around principles of MVC, blocks, reactive programming, etc. that are great for iOS developers.

##Intro to the template app
The template app is a simple customer loyalty flights application, which allows the end user to search flights, and book a round-trip pair of flights.

Check out the experience:

[YouTube clip](www.youtube.com/embed/2npfEyhw9nQ)

##Installation

###Pre-requisites
There are a few pre-requisites for running the template as it is configured in the repository.

1.  Install the **SAP Mobile SDK 3 SP05 PL01** or higher.  The SDK libraries & headers are *not* included in this repository, so you will need to download them directly from SAP.

2.  **xCode 6 / iOS8**  The SDK has an official minimum iOS version of iOS7, but this sample makes use of an iOS8-only API when handling date conversions.  

3.  Install **cocoapods** on your development machine.  Cocoapods is an open-source ruby gem tool, which makes cocoa dependency management really easy.  Installation can be accomplished with one line on the terminal:  `$ sudo gem install cocoapods`.  See [cocoapods.org](http://cocoapods.org) for details.

4.  Copy the file **NativeSDK.podspec** from [here](https://github.com/sstadelman/NativeSDK-podspec), into the **NativeSDK** folder in your MobileSDK3 installation directory.  I've recorded a video overview, and documented this [here](http://sstadelman.bull.io/blog/CocoaPods-with-Mobile-SDK-Installer/). 

###Installation and configuration

1.  Clone, or download the repository to your local machine

2.  Navigate to the project directory, and run at the terminal:  `pod update`.  

3.  Once cocoapods is completed, open the project via the **.xcworkspace**, *not* the .xcodeproj.
