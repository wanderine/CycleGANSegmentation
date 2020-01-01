#!/bin/bash

for i in /flush2/andek67/Data/BRATS/HGG/* ; do

    cd $i

    # Get subject ID
    Subject=${PWD##*/}

    echo "Processing subject $Subject "

    cd /flush2/andek67/Data/BRATS/segmentedImages

    3drefit -orient RAI ${Subject}_completeSeg_multichannel.nii.gz

    fslroi ${Subject}_completeSeg_multichannel.nii.gz ${Subject}_completeSeg_multichannel_cropped.nii.gz 50 140 40 176 25 124 0 -1

done
