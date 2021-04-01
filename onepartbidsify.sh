#!/bin/bash

# BIDSify Structural scans
#
# vittorio.iacovella@unitn.it 2021
#
# usage
#
# ./anatScript.sh rawpart bidspart
#
# where
#
# rawpart is the patientID_accessionN of the participant
# e.g.: 19830729ABCD_202011281000
# bidspart is the bids-like label
# e.g.: sub-01

export FSLDIR=/usr/lib/fsl/5.0

rawpart=$1
bidspart=$2

mkdir -p ./BIDS/$bidspart/ses-mri/anat
echo BIDSifying $rawpart into $bidspart
n=0
for p in $(ls -d ./$rawpart/*/*mprage*)
do
        n=$(echo $n+1 | bc)
        curracq=$(basename $p | awk -F "_" '{print $4}')
        echo $curracq
        echo $bidspart"_acq-"$curracq"_T1w_wface"
        dcm2niix -o ./BIDS/$bidspart/ses-mri/anat -f $bidspart"_ses-mri_acq-"$curracq"_T1w_wface" $p
        #pydeface --outfile ./BIDS/$bidspart/anat/$bidspart"_acq-"$curracq"_T1w.nii.gz" ./BIDS/$bidspart/anat/$bidspart"_acq-"$curracq"_T1w_wface.nii.gz"

done
echo "BIDSified" $n "MPRAGE series"

mkdir -p ./BIDS/$bidspart/ses-mri/func

funcdir=$(ls -d ./$rawpart/*/*epi1*DiCo*)
echo $funcdir
dcm2niix -o ./BIDS/$bidspart/ses-mri/func -f $bidspart"_ses-mri_task-rest.bold" $funcdir
echo "BIDSified 1 functional series"
