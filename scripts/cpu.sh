#!/bin/zsh

cpuUsage=$(top -bn1 | awk '/Cpu/ { print $2}')

# Print the usage
echo "CPU Usage: $cpuUsage%"
