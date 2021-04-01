#!/bin/bash

for p in $(find | grep wface.json)
do
	mv $p ${p%%"_wface.json"}.json
done
