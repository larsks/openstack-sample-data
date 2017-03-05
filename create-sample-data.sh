#!/bin/bash

: ${MEMBER_ROLE:=_member_}

roles='manager'

project1_members='user1 user2 user3'
project2_members='user3 user4'
project1_managers='user5'
project2_managers='user6'

set -e

echo "creating roles"
for role in $roles; do
    echo "creating role $role"
    openstack role create --or-show $role
done

echo "creating users"
for user in {1..6}; do
    echo "creating user user${user}"
    openstack user create --or-show \
        --password secret${user} \
        --email user${user}@example.com \
        --enable \
        user${user}
done

echo "creating projects"
for proj in {1..2}; do
    echo "creating project project${proj}"
    openstack project create --or-show project${proj}

    members="project${proj}_members"
    managers="project${proj}_managers"

    echo "adding members to project project${proj}"
    for user in ${!members}; do
        echo "adding user $user as member to project project${proj}"
        openstack role add \
            --project project${proj} \
            --user $user \
            $MEMBER_ROLE
    done

    echo "adding manager to project project${proj}"
    for user in ${!managers}; do
        echo "adding user $user as manager to project project${proj}"
        openstack role add \
            --project project${proj} \
            --user $user \
            manager
    done
done
