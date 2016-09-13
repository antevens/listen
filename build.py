#!/usr/bin/python
# -*- coding: utf8 -*-
"""
The MIT License (MIT)

Copyright (c) 2014 Antonia Stevens

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
"""

# Due to the mess python packaging is in the most reliable method to call setup.py is via subprocess *sigh*
import subprocess

# Register with PyPi, only done once
# http://guide.python-distribute.org/creation.html
# Before uploading you first need to create an account at http://pypi.python.org/pypi
#subprocess.call(["python", "setup.py", "register"])

# Clean up
subprocess.call(["python", "setup.py", "clean", "--all"])

# Create Source Distribution
#python setup.py sdist --owner=root --group=root
subprocess.call(["python", "setup.py", "sdist"])

# Create Windows Installer
#subprocess.call(["python", "setup.py", "bdist_msi"])

# Create an RPM package
#subprocess.call(["python", "setup.py", "bdist_rpm"])

# Create a DEB package
# http://wiki.debian.org/Python/Packaging
try:
    import stdeb
except ImportError:
    print("Unable to import stdeb, try installing with sudo apt-get install python-stdeb if you are on a debian based Linux distribution")
else:
    subprocess.call(["python", "setup.py", "bdist_deb"])

# Upload all releases to PyPi
#subprocess.call(["python", "setup.py", "sdist", "bdist_msi", "bdist_rpm", "bdist_deb", "upload"])
