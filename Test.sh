#!/bin/sh 
arecord -d 10 -f cd -t wav /tmp/test.wav &
aplay Test.wav
wait
aplay /tmp/test.wav
