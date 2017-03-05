#!/bin/bash

project1_nets="network1 network2"
project2_nets="network3"

network1_subnet="192.168.55.0/24"
network2_subnet="198.168.57.0/24"
network3_subnet="10.7.1.0/24"

set -e

echo "creating networks"
for proj in {1..2}; do
	echo "creating router for project project${proj}"
	openstack router create --project project${proj} \
		project${proj}_router

	echo "creating networks for project project${proj}"
	networks="project${proj}_nets"
	for network in ${!networks}; do
		echo "creating network $network for project project${proj}"
		openstack network create --project project${proj} $network

		subnet="${network}_subnet"
		echo "creating subnet ${!subnet} for network $network"
		openstack subnet create \
			--project project${proj} \
			--network $network \
			--subnet-range ${!subnet} $subnet

		echo "attaching subnet ${!subnet} to router"
		openstack router add subnet project${proj}_router $subnet
	done
done
