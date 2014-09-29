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

Clone or download the project, then, after installing SDK v3 SP05.1 and copying the podspec into the Native SDK folder (as described [here](http://sstadelman.bull.io/blog/CocoaPods-with-Mobile-SDK-Installer/)), run `pod update`.

This will auto-link all the SDK libraries and your project.

The SDK libraries & headers are *not* included in this repository, so you will need to download them directly from SAP.
