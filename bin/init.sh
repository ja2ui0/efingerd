#!/bin/sh

socat tcp-listen:79,fork exec:"/usr/bin/efingerd -n -f"
