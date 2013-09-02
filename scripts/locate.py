import sys
import os

from geopy import geocoders

if not len(sys.argv)==2:
    exit('Incorrect syntax, please supply a search string, ex: python locate.py London')

#searchName = "London"
searchName = sys.argv[1]

g = geocoders.GoogleV3()
l = list(g.geocode(searchName,exactly_one=False))  
#print "%s: %.5f, %.5f" % (place, lat, lng)  

place, (lat, lng) = l[0]
print "%s: %.5f, %.5f" % (place, lat, lng)
