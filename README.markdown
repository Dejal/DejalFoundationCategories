DejalFoundationCategories
=========================

DejalFoundationCategories is a collection of Foundation-level categories, to add useful methods to classes like `NSArray`, `NSDictionary`, `NSString`, and others.

They work on both OS X and iOS.


Donations
---------

I wrote DejalFoundationCategories for my own use, but I'm making it available for the benefit of the Mac and iOS developer community.

If you find it useful, a donation via PayPal (or something from my Amazon.com Wish List) would be very much appreciated. Appropriate links can be found on the Dejal Developer page:

<http://www.dejal.com/developer>


Latest Version
--------------

You can find the latest version of this code via the GitHub repository:

<https://github.com/Dejal/DejalFoundationCategories>

For news on updates, also check out the Dejal Developer page or the Dejal Blog filtered for Dejal categories posts:

<http://www.dejal.com/blog/dejalcategories>


Environment & Requirements
--------------------------

- All recent versions of OS X or iOS.
- Objective-C language.
- ARC.


Features
--------

- **NSArray+Dejal**: 30+ methods extending `NSArray` and `NSMutableArray`, including object matching, reversal, sorting, deep copying, adding and removing.
- **NSAttributedString+Dejal**: 10+ methods extending `NSAttributedString` and `NSMutableAttributedString`, including convenience initializers, RTF and font methods.
- **NSData+Dejal**: A couple of methods to make archiving and unarchiving objects slightly more convenient.
- **NSDate+Dejal**: 50+ methods extending `NSDate`, including convenience initializers, handy date component properties and calculators, JSON date support, string formatting, and relative date output.
- **NSDictionary+Dejal**: 25+ methods extending `NSDictionary` and `NSMutableDictionary`, including object matching, scalar support, deep copying, and more.
- **NSFileManager+Dejal**: 15+ methods extending `NSFileManager`, including convenient file attributes, file renaming, and path building.
- **NSObject+Dejal**: 15+ methods extending the `NSObject` base class, including key-value conveniences, "equivalent" comparisons, and `performSelector` methods.
- **NSString+Dejal**: 80+ methods extending `NSString` and `NSMutableString`, including scalar value formatting, contains evaluation, comparisons, substring and range utilities, reformatting, checksum and encoding utilities, internet utilities, file path methods, and appending and replacing methods.
- **NSUserDefaults+Dejal**: 15+ methods extending `NSUserDefaults`, including support for default values, sanitizing values, time intervals, factory settings, and copying preferences.

The methods use a `dejal_` prefix to ensure uniqueness (important with categories).

Some of the methods date back over 10 years, so may be less useful nowadays, or have outdated code style.  But there are still lots of gems that are used in all [Dejal](http://www.dejal.com/) apps.


Usage
-----

Include the desired source files in your project.  Some of them have interdependencies, some can be used independently.


License and Warranty
--------------------

This code uses the standard BSD license.  See the included License.txt file.  Please also see the [Dejal Open Source License](http://www.dejal.com/developer/license/) web page for more information.

You can use this code at no cost, with attribution.  A non-attribution license is also available, for a fee.

You're welcome to use it in commercial, closed-source, open source, free or any other kind of software, as long as you credit Dejal appropriately.

The placement and format of the credit is up to you, but I prefer the credit to be in the software's "About" window or view, if any. Alternatively, you could put the credit in the software's documentation, or on the web page for the product. The suggested format for the attribution is:

> Includes DejalFoundationCategories code from [Dejal](http://www.dejal.com/developer/).

Where possible, please link the text "Dejal" to the Dejal Developer web page, or include the page's URL: <http://www.dejal.com/developer/>.

This code comes with no warranty of any kind.  I hope it'll be useful to you, but I make no guarantees regarding its functionality or otherwise.


Support / Contact / Bugs / Features
-----------------------------------

I can't promise to answer questions about how to use the code.

If you create an app that uses the code, please tell me about it.

If you want to submit a feature request or bug report, please use [GitHub's issue tracker for this project](https://github.com/Dejal/DejalFoundationCategories/issues).  Or preferably fork the code and implement the feature/fix yourself, then submit a pull request.

Enjoy!

David Sinclair  
Dejal Systems, LLC


Contact: <http://www.dejal.com/contact/?subject=DejalFoundationCategories>
More open source projects: <http://www.dejal.com/developer>
Open source announcements on Twitter: <http://twitter.com/dejalopen>
General Dejal news on Twitter: <http://twitter.com/dejal>

