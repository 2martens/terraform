#!/bin/sh

printf "vm.overcommit_memory = 1\nkernel.panic = 10\nkernel.panic_on_oops = 1" > /etc/sysctl.d/90-kubelet.conf