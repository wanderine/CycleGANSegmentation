close all
clear all
clc

addpath('/home/andek67/Research_projects/nifti_matlab')

augmentTraining = 1;
augmentTesting = 0;

%study = 'Beijing';
%datapath = ['data/fcon1000_128_' study '/'];
%augmentedDatapath = ['data/fcon1000_128_' study '_augmented/'];

datapath = ['data/BRATS/'];
augmentedDatapath = ['data/BRATS_augmented5/'];

numberOfTrainingSubjects = 210;
numberOfTestSubjects = 38;

filenamesA = dir([datapath 'trainA' ]);
filenamesB = dir([datapath 'trainB' ]);
filenamesA = filenamesA(3:end);
filenamesB = filenamesB(3:end);

nii = load_nii([datapath '/trainA/' filenamesA(1).name]);
volume = double(nii.img);
[sy sx sz scA] = size(volume);

nii = load_nii([datapath '/trainB/' filenamesB(1).name]);
volume = double(nii.img);
[sy sx sz scB] = size(volume);

[xi, yi, zi] = meshgrid(-(sx-1)/2:(sx-1)/2,-(sy-1)/2:(sy-1)/2, -(sz-1)/2:(sz-1)/2);

if augmentTraining == 1
    
    for subject = 1:numberOfTrainingSubjects
        
        subject
        
        for augmentation = 1:5
            
            if augmentation <= 10
                
                x_rotation = 10 * randn;
                y_rotation = 10 * randn;
                z_rotation = 10 * randn;
                
                
                R_x = [1                        0                           0;
                    0                        cos(x_rotation*pi/180)      -sin(x_rotation*pi/180);
                    0                        sin(x_rotation*pi/180)      cos(x_rotation*pi/180)];
                
                R_y = [cos(y_rotation*pi/180)   0                           sin(y_rotation*pi/180);
                    0                        1                           0;
                    -sin(y_rotation*pi/180)  0                           cos(y_rotation*pi/180)];
                
                R_z = [cos(z_rotation*pi/180)   -sin(z_rotation*pi/180)     0;
                    sin(z_rotation*pi/180)   cos(z_rotation*pi/180)      0;
                    0                        0                           1];
                
                Rotation_matrix = R_x * R_y * R_z;
                Rotation_matrix = Rotation_matrix(:);
                
                rx_r = zeros(sy,sx,sz);
                ry_r = zeros(sy,sx,sz);
                rz_r = zeros(sy,sx,sz);
                
                rx_r(:) = [xi(:) yi(:) zi(:)]*Rotation_matrix(1:3);
                ry_r(:) = [xi(:) yi(:) zi(:)]*Rotation_matrix(4:6);
                rz_r(:) = [xi(:) yi(:) zi(:)]*Rotation_matrix(7:9);
                
            else
                
                scale = 1 + 0.25*randn;
                
                Rotation_matrix = [scale 0 0;
                    0 scale 0;
                    0 0 scale];
                Rotation_matrix = Rotation_matrix(:);
                
                rx_r = zeros(sy,sx,sz);
                ry_r = zeros(sy,sx,sz);
                rz_r = zeros(sy,sx,sz);
                
                rx_r(:) = [xi(:) yi(:) zi(:)]*Rotation_matrix(1:3);
                ry_r(:) = [xi(:) yi(:) zi(:)]*Rotation_matrix(4:6);
                rz_r(:) = [xi(:) yi(:) zi(:)]*Rotation_matrix(7:9);
            end
            
            %----
            
            %nii = load_nii([datapath '/trainA/' study '_fMRI_' num2str(subject) '.nii.gz']);
            nii = load_nii([datapath '/trainA/' filenamesA(subject).name ]);
            
            volumes = double(nii.img);
            newVolumes = zeros(size(volumes));
            
            for c = 1:scA
                % Add rotation and translation at the same time
                newVolume = interp3(xi,yi,zi,volumes(:,:,:,c),rx_r,ry_r,rz_r,'cubic');
                % Remove 'not are numbers' from interpolation
                newVolume(isnan(newVolume)) = 0;
                newVolumes(:,:,:,c) = newVolume;
            end
            
            newFile.hdr = nii.hdr;
            newFile.hdr.dime.datatype = 16;
            newFile.hdr.dime.bitpix = 16;
            newFile.img = single(newVolumes);
            
            temp = filenamesA(subject).name
            temp = temp(1:end-7);
            save_nii(newFile,[augmentedDatapath '/trainA/' temp '_augmented_' num2str(augmentation) '.nii.gz']);
            
            %----
            
            nii = load_nii([datapath '/trainB/' filenamesB(subject).name ]);
            volumes = double(nii.img);
            newVolumes = zeros(size(volumes));
            
            for c = 1:scB
                % Add rotation and translation at the same time
                newVolume = interp3(xi,yi,zi,volumes(:,:,:,c),rx_r,ry_r,rz_r,'nearest');
                % Remove 'not are numbers' from interpolation
                newVolume(isnan(newVolume)) = 0;
                newVolumes(:,:,:,c) = newVolume;
            end
            
            newFile.hdr = nii.hdr;
            newFile.hdr.dime.datatype = 16;
            newFile.hdr.dime.bitpix = 16;
            newFile.img = single(newVolumes);
            
            temp = filenamesB(subject).name
            temp = temp(1:end-7);
            save_nii(newFile,[augmentedDatapath '/trainB/' temp '_augmented_' num2str(augmentation) '.nii.gz']);
            
            
        end
    end
end


if augmentTesting == 1
    
    for subject = (numberOfTrainingSubjects+1):(numberOfTrainingSubjects + numberOfTestSubjects)
        
        subject
        
        for augmentation = 1:20
            
            if augmentation <= 10
                
                x_rotation = 10 * randn;
                y_rotation = 10 * randn;
                z_rotation = 10 * randn;
                
                
                R_x = [1                        0                           0;
                    0                        cos(x_rotation*pi/180)      -sin(x_rotation*pi/180);
                    0                        sin(x_rotation*pi/180)      cos(x_rotation*pi/180)];
                
                R_y = [cos(y_rotation*pi/180)   0                           sin(y_rotation*pi/180);
                    0                        1                           0;
                    -sin(y_rotation*pi/180)  0                           cos(y_rotation*pi/180)];
                
                R_z = [cos(z_rotation*pi/180)   -sin(z_rotation*pi/180)     0;
                    sin(z_rotation*pi/180)   cos(z_rotation*pi/180)      0;
                    0                        0                           1];
                
                Rotation_matrix = R_x * R_y * R_z;
                Rotation_matrix = Rotation_matrix(:);
                
                rx_r = zeros(sy,sx,sz);
                ry_r = zeros(sy,sx,sz);
                rz_r = zeros(sy,sx,sz);
                
                rx_r(:) = [xi(:) yi(:) zi(:)]*Rotation_matrix(1:3);
                ry_r(:) = [xi(:) yi(:) zi(:)]*Rotation_matrix(4:6);
                rz_r(:) = [xi(:) yi(:) zi(:)]*Rotation_matrix(7:9);
                
            else
                
                scale = 1 + 0.25*randn;
                
                Rotation_matrix = [scale 0 0;
                    0 scale 0;
                    0 0 scale];
                Rotation_matrix = Rotation_matrix(:);
                
                rx_r = zeros(sy,sx,sz);
                ry_r = zeros(sy,sx,sz);
                rz_r = zeros(sy,sx,sz);
                
                rx_r(:) = [xi(:) yi(:) zi(:)]*Rotation_matrix(1:3);
                ry_r(:) = [xi(:) yi(:) zi(:)]*Rotation_matrix(4:6);
                rz_r(:) = [xi(:) yi(:) zi(:)]*Rotation_matrix(7:9);
            end
            
            %----
            
            nii = load_nii([datapath '/testA/' study '_fMRI_' num2str(subject) '.nii.gz']);
            volume = double(nii.img);
            
            % Add rotation and translation at the same time
            newVolume = interp3(xi,yi,zi,volume,rx_r,ry_r,rz_r,'cubic');
            % Remove 'not are numbers' from interpolation
            newVolume(isnan(newVolume)) = 0;
            
            newFile.hdr = nii.hdr;
            newFile.hdr.dime.datatype = 16;
            newFile.hdr.dime.bitpix = 16;
            newFile.img = single(newVolume);
            
            save_nii(newFile,[augmentedDatapath '/testA/' study '_fMRI_' num2str(subject) '_augmented_' num2str(augmentation) '.nii.gz']);
            
            %----
            
            nii = load_nii([datapath '/testB/' study '_T1_' num2str(subject) '.nii.gz']);
            volume = double(nii.img);
            
            % Add rotation and translation at the same time
            newVolume = interp3(xi,yi,zi,volume,rx_r,ry_r,rz_r,'cubic');
            % Remove 'not are numbers' from interpolation
            newVolume(isnan(newVolume)) = 0;
            
            newFile.hdr = nii.hdr;
            newFile.hdr.dime.datatype = 16;
            newFile.hdr.dime.bitpix = 16;
            newFile.img = single(newVolume);
            
            save_nii(newFile,[augmentedDatapath '/testB/' study '_T1_' num2str(subject) '_augmented_' num2str(augmentation) '.nii.gz']);
            
            
        end
    end
end


