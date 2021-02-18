extends Sprite

const FIRST_GRACE_TIME = 0.1
const SECOND_GRACE_TIME = 0.2

var time_since_hearbeat = FIRST_GRACE_TIME
var pretend_time_since_heartbeat = 0

func beat():
	time_since_hearbeat = 0
	pass
	
var sfx_queue = []
	
func play_sfx(what):
	if pretend_time_since_heartbeat <= FIRST_GRACE_TIME:
		# If the pretened time is less than the grace, we've already
		# gone past the start of the beat
		what.play()
	else:
		sfx_queue.append(what)
		
func play_sfx_queue():
	for item in sfx_queue:
		item.play()
		
	sfx_queue.clear()
	
func _process(delta):
	# This is a, in my opinion, clever trick.
	# It's very easy to check if the player input occurs in a time period after
	# the heartbeat timer is reset. However, we would like to also test if the
	# player hit the input slightly before the timer was reset.
	# Well, all we have to do is to pretend, visually, that the timer was reset
	# a bit later than it actually was. And then check if the time since heart
	# beat is within a slightly bigger period.
	
	var t = 0.5 - pretend_time_since_heartbeat
	t = clamp(t, 0.0, 1.0)
	
	scale.x = 1.0 + t * 0.5
	scale.y = scale.x
	
	time_since_hearbeat += delta
	if time_since_hearbeat > FIRST_GRACE_TIME:
		if not $Audio.playing:
			$Audio.playing = true
		play_sfx_queue()
		pretend_time_since_heartbeat = time_since_hearbeat - FIRST_GRACE_TIME
	else:
		pretend_time_since_heartbeat += delta
	
func is_on_beat():
	return time_since_hearbeat <= FIRST_GRACE_TIME + SECOND_GRACE_TIME
