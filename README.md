* **************** *
# TWAIN SANE Interface for MacOS (10.10 and Next Versions) #
## Make your OLD Scanner back to Service !! ##
* **************** *

This Repository contains Pre-Build Software in form of Package Installation for recent MACOS(10.10 => +), 
you can request older version in
https://github.com/genose/macos-scanner-interface-twain-sane-binaries/issues

Or use Old Packages for MAC 10.6 / 10.9 from from [ Mattias Ellert's Official site ]:http://www.ellert.se/twain-sane/  

* **************** *
**** For Other Operating Systems (Linux, Windows, Beos/Zeta, SunOS ...) **** 
**** OR more Information about sane-project, Please Refer to : [http://sane-project.org/] Official Site ****
* **************** *

05/2019 : Revisions are designed around Offical version 1.0.25 from historic maintener : [ Mattias Ellert's Official site ]:http://www.ellert.se/twain-sane/

09/2020 : 
The Backends and Frontends are designed around version 1.0.31 from Official : [http://sane-project.org/]

Project still active and planned has so :
- Use last of official releases of sane-project 
- Quartz compliant GUI
- Release for Pre-Sierra ERA(10.9-10.12) to Catalina(10.15)
- Release also for older version (10.6, in reflection)


* **************** *
### NO SKILLS IN XCODE nor HOMEBREW nor MACPORT nor BASH are needed ###
### JUST DOWNLOAD, OPEN PKG INSTALLER AND FOLLOW ON-SCREEN INSTRUCTIONS ###

Provided software is distributed as-is 

Used Software : 

@{{GIT_README_VERSIONINFO}}@

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
      
  This will give you all depenc, such :
  @{{GIT_README_PKGCONTENTINFO}}@
    TWAIN-SANE-Scanner
      |__ libusb
      |__ gettext
      |__ sane-backends
      |__ TWAIN-SANE-Interface
      |__ SANE-Preference-Pane
      
  Exemple ( Mojave )
  
    MACOS-10.14
      |__ TWAIN-SANE-Scanner-ALL_IN_ONE-(PKGVERSION)-MACOS-10.14-10.14.11-MACOSSDK-10.14.dmg
  
  Exemple ( Catalina )
  
    MACOS-10.15
      |__ TWAIN-SANE-Scanner-ALL_IN_ONE-(PKGVERSION)-MACOS-10.15-10.15.11-MACOSSDK-10.14.dmg
  
 Exemple ( BigSur )
  
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
