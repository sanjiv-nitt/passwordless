#!/bin/bash

if [ "$1" == "-h" ]; then
  echo "Usage: $0 <Node Name> <User Name>"
  exit 0;
fi

if [[ "$#" -lt 2 ]] ; then
  echo "Missing node name or user name!!!" ;
  exit 0;
fi

node=$1 ; user=$2 ;
echo "Verifying Passwordless communication with : $node" ;
ssh -oBatchMode=yes -oNumberOfPasswordPrompts=0 $node "echo hello" > /dev/null 2>&1 ;
if [[ "$?" != 0 ]] ; then
  echo "Don't have passwordless communication with node : $node" ;
  if [[ ! -f /${user}/.ssh/id_rsa.pub ]] ; then
    echo "Please generate key pair for the following user : $user"
    exit 0;
  fi
  key=`cat /${user}/.ssh/id_rsa.pub`
  ssh $node "echo '$key' >> /$user/.ssh/authorized_keys"
  if [[ "$?" != 0 ]] ; then
    echo "Establishing passwordless communication to node : $node has failed" ;
    exit 0;
  fi
else
  echo "$routineName : Passwordless communication with node $node already exists" ;
fi
