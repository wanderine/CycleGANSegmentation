#!/bin/bash

for i in /flush2/andek67/Data/BRATS/HGG/* ; do

    cd $i

    # Get subject ID
    Subject=${PWD##*/}

    echo "Processing subject $Subject "

    fslmerge -t ${Subject}_merged.nii.gz  ${Subject}_t1.nii.gz ${Subject}_t1ce.nii.gz ${Subject}_t2.nii.gz ${Subject}_flair.nii.gz

    mv ${Subject}_merged.nii.gz /flush2/andek67/Data/BRATS/preparedImages
    
    cd /flush2/andek67/Data/BRATS/preparedImages

    3drefit -orient RAI ${Subject}_merged.nii.gz

    fslroi ${Subject}_merged.nii.gz ${Subject}_merged_cropped.nii.gz 50 140 40 176 25 124 0 -1

done
