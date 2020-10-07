* **************** *
# TWAIN SANE Interface for MacOS (10.10 and Next Versions) #
## Make your OLD Scanner back to Service !! ##
* **************** *

This Repository contains Pre-Build Software (Binaries) in form of Package Installation (PKG / DMG) for recent MACOS(10.9 => +), also old MacOS Leopard (10.6) .

You can put your request for any improvement or request to obtain older version in
https://github.com/genose/macos-scanner-interface-twain-sane-binaries/issues

Or use Old Packages for MAC 10.6 / 10.9 from from [ Mattias Ellert's Official site ]:http://www.ellert.se/twain-sane/  

* **************** *
**** For Other Operating Systems (Linux, Windows, Beos/Zeta, SunOS ...) **** 
**** OR more Information about sane-project, Please Refer to : [http://sane-project.org/] Official Site ****
* **************** *
### NO SKILLS IN XCODE nor HOMEBREW nor MACPORT nor BASH are needed ###
### JUST DOWNLOAD, OPEN PKG INSTALLER AND FOLLOW ON-SCREEN INSTRUCTIONS ###
* **************** *
### History : ###
04/2019 : Fork Mattias Ellert work, aged from 2015
05/2019 : Workarounds and Revisions are designed from historic maintener : [ Mattias Ellert's Official site ]:http://www.ellert.se/twain-sane/ ( Sane-Backend Based on Release Version 1.0.25 )
09/2020 : 
Project still active and planned has so :
- Use last official sources (Backends and Frontends) release from sane-project [http://sane-project.org/] ( last version 1.0.31 )
- Quartz compliant GUI ( ImageKit / IKScannerDeviceView )
- ImageCapture compliant (ICA)
- Release for Pre-Sierra ERA (10.9-10.12) to Catalina (10.15)
- Release also for older version (10.6, in reflection)
- ARM / PPC / INTEL (i386 / x86)

* **************** *
Provided software is distributed as-is with no warranty, tested by community

Used Software : 

@{{GIT_README_VERSIONINFO}}
@{{GIT_README_VERSIONINFO_MODEL}}}@
@{{GIT_README_VERSIONINFO_EACH}}}@

    @{{DSTNAME}}@
      |__ @{{DSTAUTHOR}}@
      |__ @{{DSTVERSION}}@
      |__ @{{DSTORIGIN}}@
@{{GIT_README_VERSIONINFO_EACH_END}}@
@{{GIT_README_VERSIONINFO_MODEL_END}}}@

    gettext
      |__ @{{DSTAUTHOR}}@
      |__ @{{DSTVERSION}}@
      |__ @{{DSTORIGIN}}@     
     
    libusb
      |__ @{{DSTAUTHOR}}@
      |__ @{{DSTVERSION}}@
      |__ @{{DSTORIGIN}}@     

    sane-backends 
      |__ @{{DSTAUTHOR}}@
      |__ @{{DSTVERSION}}@
      |__ @{{DSTORIGIN}}@     

    SANE-Preference-Pane
      |__ @{{DSTAUTHOR}}@
      |__ @{{DSTVERSION}}@
      |__ @{{DSTORIGIN}}@     

    TWAIN-SANE-Interface
      |__ @{{DSTAUTHOR}}@
      |__ @{{DSTVERSION}}@
      |__ @{{DSTORIGIN}}@     

* **************** *
## Installation and USAGE ##
* **************** *
### Which packages to Download ... ###
 
  There is Different "Branches"
  - Archives
  - Current Release (ALL_IN_ONE), contain all you need ...
  
  For Older MacOS Version in /MACOS-OLDERVERSION-ARCHIVES/
  
    MACOS-OLDERVERSION-ARCHIVES
      |__ TWAIN-SANE-Scanner-(PKGVERSION)-MACOS-(MACOSMINORVERSION)-(MACOSMAJORVERSION)-SDK-(SDKVERSION).pkg
    
  PACKAGE is Simplfied in Monolithic Version (All IN ONE) 
    MACOS-SIMPLIFIED-ALL_IN_ONE
      |__ TWAIN-SANE-Scanner-ALL_IN_ONE-(PKGVERSION)-MACOS-(MACOSMINORVERSION)-(MACOSMAJORVERSION)-MACOSSDK-(SDKVERSION).dmg
      
  This will give you all depencies, such :

@{{GIT_README_PKG_CONTENTINFO}}@
@{{GIT_README_PKG_CONTENTINFO_MODEL}}@

    TWAIN-SANE-Scanner
@{{GIT_README_PKG_CONTENTINFO_EACH}}@
      |__ @{{DSTNAME}}@
@{{GIT_README_PKG_CONTENTINFO_EACH_END}}@
@{{GIT_README_PKG_CONTENTINFO_MODEL_END}}@

    TWAIN-SANE-Scanner
      |__ libusb
      |__ gettext
      |__ sane-backends
      |__ TWAIN-SANE-Interface
      |__ SANE-Preference-Pane
      
  ** Exemple ( Mojave ) **
  
    MACOS-10.14
      |__ TWAIN-SANE-Scanner-ALL_IN_ONE-(PKGVERSION)-MACOS-10.14-10.14.11-MACOSSDK-10.14.dmg
  
  ** Exemple ( Catalina ) **
  
    MACOS-10.15
      |__ TWAIN-SANE-Scanner-ALL_IN_ONE-(PKGVERSION)-MACOS-10.15-10.15.11-MACOSSDK-10.14.dmg
  
 ** Exemple ( BigSur, Anticipated for 2021 ) **
  
    MACOS-11
      |__ (Beta not Tested)
  
  
 
## Just Install packages corresponding to your MacOS Version, OPEN PKG FILE and follow instructions ##


* **************** 
## Test scanner : ##
* **************** 

## User-Friendly Method : ## 

**** TODO Installation Post Process :  ****

### Avanced User Method : ###
- Open Terminal.app 
and enter the following command :
```sh
scanimage --format jpg > test.jpg
```
Your scanner should react and make a picture sample (100px X 100px)

* **************** 
## Note about TWAIN Support ##
* **************** 
Beside some fact, We Love Twain integration.
- Adobe annouced in 2015 there is no Further support in Photoshop for TWAIN Integration, dues to "Some Resitrictions Caused by Twain", that means Money not in us Pokets 
- Apple make it more difficult to interfacing with ImageCapture.app


* **************** 
# About Remote / Shared Scan #
## Server sonfiguration ##
* **************** 

Server side configuration taken [here](https://forum.keenetic.net/topic/240-sane-%D0%B8%D1%81%D0%BF%D0%BE%D0%BB%D1%8C%D0%B7%D0%BE%D0%B2%D0%B0%D0%BD%D0%B8%D0%B5-usb-%D0%BC%D1%84%D1%83-%D0%B8%D0%BB%D0%B8-%D1%81%D0%BA%D0%B0%D0%BD%D0%B5%D1%80%D0%B0/?do=findComment&comment=3599)

* **************** 
## Client configuration ##
* **************** 

- Download and Install all packages
- Modify sane config file

```sh
sudo vi /usr/local/etc/sane.d/net.conf
```

Add IP of your Sane scaner at the last line

```sh
# This is the net backend config file.

## net backend options
# Timeout for the initial connection to saned. This will prevent the backend
# from blocking for several minutes trying to connect to an unresponsive
# saned host (network outage, host down, ...). Value in seconds.
# connect_timeout = 60

## saned hosts
# Each line names a host to attach to.
# If you list "localhost" then your backends can be accessed either
# directly or through the net backend.  Going through the net backend
# may be necessary to access devices that need special privileges.
# localhost
192.168.1.1  # Add this line with correct IP address
```
* ******************
## Test scan

```sh
scanimage --format jpg > test.jpg
```
* ******************
** Thanks to Mattias Ellert, for all this Year of Maintaining SANE TWAIN for MacOS **

[ Mattias Ellert's Official site ]:http://www.ellert.se/twain-sane/

* ******************
## About HOMEBREW and other installation methods ##
* ******************
Homebrew is another way to get software installed on your computer. 
But it required some skill in BASH usage and Homebrew command line argument.

- You had to download the right version of XCode depends on what Version of MacOS you using. 
- You had to use Terminal.app and type some commands to install
    - Homebrew
    - Sane-backend
    - Sane-interface

OR IF you a very skilled one.

- You can try by yourself to install latest [Sane Project's version](http://sane-project.org/) 
- You had to download the right version of XCode depends on what Version of MacOS you using 
- You had to use Terminal.app and type some commands to compile and install Sane
