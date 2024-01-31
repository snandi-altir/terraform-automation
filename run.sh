#!/bin/sh

service docker start
sleep 3
$(jenkins-agent)
