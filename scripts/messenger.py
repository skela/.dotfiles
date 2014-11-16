import os
import sys

class Messenger(object):

	def send_msg_to_buddy(self, msg, buddy):
		print "Sending '%s' to buddy %s" % (msg, buddy)
		cmd = 'tell application "Messages" to send \"%s\" to buddy \"%s\"' % (msg, buddy)
		cmd = "osascript -e '%s'" % cmd
		print cmd
		os.system(cmd)

	def get_chats():
		cmd = 'tell application "Messages" to get chats'
		cmd = "osascript -e '%s'" % cmd
		print cmd
		os.system(cmd)
