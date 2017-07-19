#!/bin/bash

if [ ! -f Vagrantfile.jenkins ] ; then
  cp Vagrantfile Vagrantfile.jenkins
fi

cp Vagrantfile.gui Vagrantfile
vagrant up
vagrant provision
