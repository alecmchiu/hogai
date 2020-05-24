#!/bin/env python3

import re

if __name__=='__main__':

	pattern = r'[\n]*([0-9]{4})\s+(.*[Ss]hadow)[\n.\s;]*[.\n]*'	
	filename='outcomes1.txt'
	with open(filename)as f:
		contents = f.read()
	#print(contents)
	matches = re.findall(pattern,contents)
	for match in matches:
		if 'no' in match[1].lower():
			res = "No Shadow"
		else:
			res = "Shadow"
		print("{}\t{}".format(match[0],res))
	exit(0)
