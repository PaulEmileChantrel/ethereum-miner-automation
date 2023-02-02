#!/bin/sh


export GPU_MAX_ALLOC_PERCENT=100


./ethdcrminer64 -epool eth-us-east1.nanopool.org:19999 -ewal 0xc0007dfed5ae8541f369afe4775878cc8610e17b/MeteorETC/paulemile.chantrel@gmail.com -mode 1 -allpools 1 -tt 68 -fanmin 90
