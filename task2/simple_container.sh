#!/bin/bash

SIMPLE_CONTAINER_ROOT=container_root

mkdir -p $SIMPLE_CONTAINER_ROOT

gcc -o container_prog container_prog.c

## Subtask 1: Execute in a new root filesystem

cp container_prog $SIMPLE_CONTAINER_ROOT/

# 1.1: Copy any required libraries to execute container_prog to the new root container filesystem 


echo -e "\n\e[1;32mOutput Subtask 2a\e[0m"

list="$(ldd container_prog | egrep -o '/lib.*\.[0-9]')"
# echo $list
for i in $list; do cp --parents "$i" "${SIMPLE_CONTAINER_ROOT}"; done

# 1.2: Execute container_prog in the new root filesystem using chroot. You should pass "subtask1" as an argument to container_prog

sudo chroot $SIMPLE_CONTAINER_ROOT /container_prog subtask1

echo "__________________________________________"
echo -e "\n\e[1;32mOutput Subtask 2b\e[0m"


## Subtask 2: Execute in a new root filesystem with new PID and UTS namespace
# The pid of container_prog process should be 1
# You should pass "subtask2" as an argument to container_prog

sudo unshare -p -u --fork --root=$SIMPLE_CONTAINER_ROOT /container_prog subtask2

# unshare --root=$SIMPLE_CONTAINER_ROOT -f -p -u  ./container_prog subtask2


echo -e "\nHostname in the host: $(hostname)"


## Subtask 3: Execute in a new root filesystem with new PID, UTS and IPC namespace + Resource Control
# Create a new cgroup and set the max CPU utilization to 50% of the host CPU. (Consider only 1 CPU core)

echo "__________________________________________"
echo -e "\n\e[1;32mOutput Subtask 2c\e[0m"

mkdir /sys/fs/cgroup/nikhil

shellpid=$$
echo $shellpid | sudo tee /sys/fs/cgroup/nikhil/cgroup.procs > /dev/null


max_quota=100000
cpu_quota_percentage=50  # Define the CPU quota percentage
cpu_quota=$((max_quota * cpu_quota_percentage / 100))

echo $cpu_quota | sudo tee /sys/fs/cgroup/nikhil/cpu.max > /dev/null

sudo unshare -p -u --fork --root=$SIMPLE_CONTAINER_ROOT /container_prog subtask3


# Assign pid to the cgroup such that the container_prog runs in the cgroup
# Run the container_prog in the new root filesystem with new PID, UTS and IPC namespace
# You should pass "subtask1" as an argument to container_prog

# Remove the cgroup


# If mounted dependent libraries, unmount them, else ignore
