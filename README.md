openW3
======

A toolkit for building web & mobile interfaces for routers and other embedded 
devices.

openW3 (c) Copyright 2012 APPMO LTD

* author    : Flame Herbohn (and contributors)
* download  : https://github.com/appmode/openW3

openW3 Runtime
--------------

license   : GNU General Public License version 2
 
openW3 Runtime is a modular runtime environment for web & mobile interfaces 
on routers and other embedded devices.
 
The openW3 Runtime includes all of the Javascript, CSS & HTML portions of
openW3. This allows a web or mobile interface created using the 
openW3 Toolkit to be distributed under the terms of the GNU GPL Licence
version 2.

openW3 SDK
----------

license   : GNU Affero General Public License version 3
 
openW3 SDK is a toolkit for building web & mobile interfaces for routers and 
other embedded devices.
 
The openW3 SDK includes all of the Python portions of openW3. This is the 
toolkit used to compile openW3 interfaces.

Google App Engine
-----------------

openW3 SDK uses Google App Engine as a development web server and to compile 
user interfaces for distribution. Google App Engine is NOT required to run the 
compiled user interfaces and is not distributed as part of the compiled 
user interfaces.


Getting Started
===============

1) readt the openW3 documentation

https://github.com/appmode/openW3/wiki

2) run the script to install Google AppEngine

    ./setup.sh

3) run the script to start Google AppEngine

    ./run.sh

4) view the system in your web browser

    http://localhost:8080/sample

5) edit system files (you will need to restart the run.sh script & refresh your
browser after making changes).

6) run the script to build the compiled system

    ./build.sh

7) the compiled site is located in the `compiled/` folder
