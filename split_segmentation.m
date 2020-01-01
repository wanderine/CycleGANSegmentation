close all
clear all
clc

addpath('/home/andek67/Research_projects/nifti_matlab')

dataDirectory='/flush2/andek67/Data/BRATS/segmentedImages/'
MRDirectory='/flush2/andek67/Data/BRATS/preparedImages/'
outputDirectory='/flush2/andek67/Data/BRATS/segmentedImages/'

originalData = dir(dataDirectory);
originalData = originalData(3:end);

sy = 240; sx = 240; sz = 155;

for subject = 1:length(originalData)

	subject

    originalData(subject).name
    
    % Load nifti volumes
    nii = load_nii([dataDirectory  originalData(subject).name ]);
    segmentation = single(nii.img);
    
    split_segmentation_ = zeros(sy,sx,sz,6);
    for x = 1:sx
        for y = 1:sy
            for z = 1:sz
                if segmentation(y,x,z) > 0
                    split_segmentation_(y,x,z,segmentation(y,x,z)) = 500;
                end
            end
        end
    end
    
    temp = originalData(subject).name;
    temp = [temp(1:end-7) '_multichannel.nii.gz'];
    
    newnii = nii;
    newnii.img = single(split_segmentation_);
    newnii.hdr.dime.datatype = 16;
    newnii.hdr.dime.bitpix = 16;
    newnii.hdr.dime.dim = [4 sy sx sz 6 1 1 1];
        
    save_nii(newnii,[outputDirectory temp ]);
    
end
