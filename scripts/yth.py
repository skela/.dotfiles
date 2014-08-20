
from subprocess import Popen, PIPE

playlists = [{"id": "PLjDx5u-G_1SgAqa6kKz56gXxxGhfoMq6j", "start": 100}]

playlist = playlists[0]
start = 1
if 'start' in playlist:
    start = playlist['start']

cmd = "youtube-dl -j --playlist-start %d https://youtube.com/watch?list=%s" % (start, playlist['id'])
p = Popen(cmd, shell=True, stdout=PIPE, stderr=PIPE)
out, err = p.communicate()
print "Return code: ", p.returncode
print out.rstrip(), err.rstrip()
