#!/usr/bin/env python3
import os

response = os.system("aws eks describe-addon-versions > addons.json")
#print(os.system("cat addons.json | jq   '.addons[] | .addonName'"))
print(os.system("jq '[ .[] .addons, .[] .addonName ])' addons.json"))
