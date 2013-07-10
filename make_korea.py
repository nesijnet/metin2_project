import pre_qc_korea
import os
os.system('rmdir object')
os.system('mkdir object')
for line in file('quest_list'):
	os.system('clear')
	os.system('mkdir pre_qc_korea')
	r = pre_qc_korea.run (line)
	if r == True:
		filename = 'pre_qc_korea/'+line
	else:
		filename = line

	if os.system('./qc_korea '+filename):
		print 'UndergroundMt3: Error occured on compile ' + line
		import sys
		sys.exit(-1)
	print 'Quest compiled.'
	os.system('rmdir pre_qc_korea')
	print 'All quests has been successfully compiled.'