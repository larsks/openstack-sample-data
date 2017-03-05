#!/bin/bash

: ${MEMBER_ROLE:=_member_}

project1_members='user1 user2 user3'
project2_members='user3 user4'
project1_managers='user5'
project2_managers='user6'

set -e

openstack role create manager

for user in {1..6}; do
    openstack user create --or-show \
        --password secret${user} \
        --email user{$user}@example.com \
        --enable \
        user${user}
done

for proj in {1..2}; do
    openstack project create --or-show project${proj}

    members="project${proj}_members"
    managers="project${proj}_managers"
    for user in ${!members}; do
        openstack role add \
            --project project${proj} \
            --user $user \
            $MEMBER_ROLE
    done
    for user in ${!managers}; do
        openstack role add \
            --project project${proj} \
            --user $user \
            manager
    done
done

