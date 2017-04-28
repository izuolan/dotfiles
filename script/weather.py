#!/usr/bin/env python2

'''
Author:   Ayman Nedjmeddine, @IOAyman
URL:      https://github.com/IOAyman/pytools
    This script prints out your weather forecast for the next couple of days
    based on your ip location.
    Thanks to
        https://github.com/chubin/wttr.in
        https://github.com/schachmat/wego
'''


from urllib2 import urlopen
from json import load
from subprocess import call


try:
    call('curl wttr.in/%s' % load(urlopen('http://ip-api.com/json'))['city'], shell=True)
except:
    print 'Err!'
