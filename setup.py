#!/usr/bin/python
# -*- coding: utf8 -*-
"""
The MIT License (MIT)

Copyright (c) 2014 Jarl Stefansson

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

import sys

# prefer using setuptools/Distribute, else use distutils
try:
    from setuptools import setup
except ImportError:
    from distutils.core import setup

setup(
    name = "listen",
    version = "0.1.0",
    author = "Jarl Stefansson",
    author_email = "jarl.stefansson@gmail.com",
    packages = ["sdec", "test"],
    scripts = ["bin/render_application_tree.py"],
    url = "https://github.com/jalli/listen",
    keywords = ["singal", "unix", "kill", "abort", "quit", "info"],
    license = "LICENSE",
    description = "Simple but powerful signal handling to process OS signals in python",
    long_description = open("README").read(),
    # Support both formats for required packages, build automatically
    install_requires = [" ".join(x[1:]) for x in required_modules],
    requires = [x[0] if len(x) <= 2 else x[0] + " (" + "".join(x[2:]) + ")" for x in required_modules],
    classifiers = [
        "Programming Language :: Python",
        "Programming Language :: Python :: 2",
        "Development Status :: 4 - Beta",
        "Environment :: Other Environment",
        "Intended Audience :: Developers",
        "Intended Audience :: Information Technology",
        "Intended Audience :: System Administrators",
        "License :: OSI Approved :: MIT License",
        "Operating System :: OS Independent",
        "Topic :: Software Development :: Libraries :: Python Modules"
        ]
)
