
#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Sep  5 13:47:20 2022

The scripts is for running tensor-ICA, identifying rejected components, 
plotting components for visual check, denoising all echoes' data and getting the combined data for comparison.
Here, we have preprocessed the data with relign and smooth with 4mm kernel with SPM12.
the kept ratio for select threshold: 0.3
som function are based on tedana, hence, tedana need to be installed in the enviorment.

@author: feng
"""


import os
import numpy as np
import shutil

drive_loc = '/bif/storage/storage3/projects/apicde/LolaRennt/Process_tfeng/HCs/' # the path for data folder
subject_folders = ['S001','S002','S003','S004','S005','S006','S007','S008','S010','S012','S015','S018','S020','S024','S025_neu','S035','S036','S037','S038','S040','S041','S044','S051','S053','S054','S056','S057','S062','S064','S065','S066','S067','S071','S073','S075','S076','S080','S081','S084','S086']

for sub_name in subject_folders:
        # 0. extract the brain of structural data
    # os.system('/usr/local/fsl/bin/bet '+os.path.join(drive_loc, sub_name, 'S_anatomy/y-vol_00001.nii') +
    #           ' '+os.path.join(drive_loc, sub_name, 'S_anatomy/y-vol_00001_brain')+' -m -f 0.5 -g 0')
    print(sub_name)
    current_folder = sub_name  # sub and sess
    # 0. extract the brain mask of mean origin functional data
    # os.system('/usr/local/fsl/bin/bet '+os.path.join(drive_loc, current_folder, 'meantemp_data_echo_1.nii') +
    #             ' '+os.path.join(drive_loc, current_folder, 'mean_data_echo_1_brain')+' -m -f 0.5 -g 0')

    
    # # 1. load data and run tnensor ICA to get independent spatial components
    # # the data are first motion_correction with the 6 motion parameters estimated from the the 1st echo's images and smoothed
    
    
    # # params need to be changed --------
    
    data_file = [drive_loc+'/'+current_folder+'/processed_data/srdata_echo_1.nii',
                    drive_loc+'/'+current_folder+'/processed_data/srdata_echo_2.nii',
                    drive_loc+'/'+current_folder+'/processed_data/srdata_echo_3.nii',
                    drive_loc+'/'+current_folder+'/processed_data/srdata_echo_4.nii']
    out_dir = drive_loc+'/'+current_folder+'/tensor_ICA/'
    
    tica_type = 'tica_s4r03'
    
    if not os.path.isdir(out_dir):
        os.mkdir(out_dir)
    # run tensor_ICA with fsl melodic
    os.system('melodic -i '+data_file[0]+','+data_file[1]+','+data_file[2]+','+data_file[3]+' -o ' +\
                drive_loc+'/'+current_folder+'/tensor_ICA/'+tica_type+' -a tica --dimest=mdl --tr=1 ' +\
                '--vn --sep_vn -v')
    