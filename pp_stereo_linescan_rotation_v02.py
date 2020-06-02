#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Mar 25 09:05:06 2020

@author: sfranke
"""

import pandas as pd
import numpy as np
from matplotlib import pyplot as plt
from matplotlib import gridspec
import mplstereonet
import os, glob
import shutil
from pathlib import Path



pd.set_option('display.max_rows', 200)
pd.set_option('display.max_columns', 20)
pd.set_option('display.width', 1500)

Seafile = 'C:/Seafile/'
#Seafile = '/Users/sfranke/Seafile/'

stereo_files_path   = Seafile + 'Orca/2019_EGRIP_Field/PP_Results/stereo_plots/stereo_plot_files/'
#figure_path         = Seafile + 'Orca/2019_EGRIP_Field/PP_Results/stereo_plots/stereo_plots_rotated/'

os.chdir(stereo_files_path)


#cmap='ocean_r'
cmap='Blues'
 
        

# original + rotated version

# save output figures here
figure_path = Seafile + 'Orca/2019_EGRIP_Field/PP_Results/stereo_plots/linescan_rotation_new_delta_20200602/'

# load rotation data from file
#df_rotation = pd.read_csv(Seafile + 'Orca/2019_EGRIP_Field/PP_Results/stereo_plots/rotation_list_linescan.csv', delimiter=',')

df_excel = pd.read_excel(Seafile + 'Orca/2019_EGRIP_Field/PP_Results/' + \
                            '2020_05_27_ice_core_orientation.xlsx')#, skiprows=2)# index_col=3)
    

    
#df['deftype_lateral_constrinction'] = pd.to_numeric(df['deftype_lateral_constrinction'], errors='coerce')
#%% 
    
print('')
print('++++ ROTATION VALUES FROM LINESCANNER ++++')
print('++++ Plotting rotated Stereo Plots and Rose Diagrams')
print('++++ Figure Path: {}'.format(figure_path))
print('')

for i in range(1, len(df_excel)):
#for i in range(1, 690):   
    print(i)    
    depth        = float(df_excel['Depth'][i])
    bag          = str(int(df_excel['Bag'][i]))
    tilt         = float(df_excel['layer_tilt_deg'][i])
    tilt         = np.round(tilt, decimals=2)
    dt_lateral   = df_excel['deftype_lateral_constrinction'][i]
    dt_extension = df_excel['deftype_extension_fold'][i]
    dt_flat      = df_excel['deftype_flat'][i]
    #blog_dir     = float(df_excel['borehole_log_direction'][i])
    #blog_plunge  = float(df_excel['borehole_log_plunge'][i])
    #blog_beta    = float(df_excel['borehole_log_beta'][i])
    #d1           = int(df_excel['delta1'][i])
    #d2           = int(df_excel['delta2'][i])
    #d3           = int(df_excel['delta3'][i])
    d_final      = df_excel['delta_final'][i]
    abw          = df_excel['abweichung'][i]
    var          = df_excel['var'][i]
    stdv          = df_excel['stdv'][i]
    
    rotation     = d_final
    
    #rotation_bag_section    = str(df_rotation['bag_section'][i])
    #rotation                = int(df_rotation['rotation'][i])
    #rotation = 0

#%%
    
    file = 'stereo_EGRIP' + bag + '_1' + '_20.txt'
    
    
    

    check_file = Path(stereo_files_path + file)
    
    # first check
    if check_file.is_file():
        file = file
        checkfile = True
        print('File ==> {} exists.'.format(file))
        pass
    else:
        checkfile = False
        print('File ==> {} does not exist.'.format(file))
        
        
    if checkfile == False: 
        bag = str(int(bag) + 1)
        file = 'stereo_EGRIP' + bag + '_1' + '_20.txt'
        check_file = Path(stereo_files_path + file)
    
    #second check    
    if check_file.is_file():
        file = file
        checkfile = True
        print('File ==> {} exists.'.format(file))
        pass
    else:
        checkfile = False
        print('File ==> {} does not exist.'.format(file))
        
    if checkfile == False: 
        bag = str(int(bag) + 1)
        file = 'stereo_EGRIP' + bag + '_1' + '_20.txt'
        check_file = Path(stereo_files_path + file)
        
    if check_file.is_file():
        file = file
        checkfile = True   
        print('File ==> {} exists.'.format(file))
        pass




    
    try:
    
        delta = rotation.astype(int)

        # Reading Data and defining variables
        df                   = pd.read_csv(file, delimiter='\t')
        df.columns           = ['azimuth', 'latitude']
        azimuth, latitude    = df['azimuth'], df['latitude']
        
        
        delta_tmp             = (180 - delta)
        rotation_dir = ''
        
        if 0:
        
            if delta_tmp >= 0:
                azimuth_ = azimuth - np.abs(delta_tmp)
                rotation_dir = 'counterclockwise'
                
            elif delta_tmp < 0:
                azimuth_ = azimuth + np.abs(delta_tmp)
                rotation_dir = 'clockwise'
                
        if 1:
            azimuth_ = azimuth - delta
            
        
        number_of_grains     = str(df.shape[0])
        appendix             = ''
        
    
        # Determining Bagnumber and section type via the filename
        # 1. Going for regular files (no volume sections)
        try:
            if 1:
                #Bag         = bag #file.split('_')[1].split('EGRIP')[1]
                segment     = file.split('_')[2]
                #Segmetn     = 1
                Filename    = 'EGRIP' + '_' + bag + '_' + segment + appendix
                depth       = ((float(bag) * 0.55) + (float(segment)) * (0.55/6)) - 0.55
                depth_p     = np.round(depth, decimals=1).astype(str)
            
            if 0:
                Bag         = file.split('_')[3]
                Segment     = file.split('_')[4]
                Filename    = 'S5' + '_' + bag + '_' + segment + appendix
                Depth       = ((float(bag) * 0.55) + (float(Segment)) * (0.55/6)) - 0.55
                Depth_p     = np.round(Depth, decimals=1).astype(str)
            
        except ValueError:
            pass
        
        
        # 
        bin_edges                       = np.arange(0, 365, 10)
        number_of_strikes, bin_edges    = np.histogram(azimuth, bin_edges)
        bin_data                        = number_of_strikes
        
        try:
            abw = int(abw)
        except ValueError:
            abw = 'NaN'
        ###############
        #   Plotting  #
        ###############
    
        print('===> Plotting: {}'.format(Filename))
        
        fig = plt.figure(figsize=(16,18.5))
        ax  = fig.add_subplot(121, projection='stereonet')
        
        #ax.pole(azimuth - 90, latitude - 90, c='k', label='Pole of the Planes', \
        #        markersize=1.75, alpha=0.5)
            
        ax.pole(azimuth, latitude - 90, c='k', label='Pole of the Planes', \
                markersize=1.75, alpha=0.5)
            
        dens = ax.density_contourf(azimuth, latitude - 90, measurement='poles', \
                                   cmap=cmap, levels=15)
    
        ax.set_title('Random Orientation \nDepth: {} m - Bag: {}_{} \nNo Rotation'.format(\
                     depth_p, bag, segment), y=1.15, fontsize=22)
        ax.grid()
        #cbaxes = fig.add_axes([0.54, 0.375, 0.02, 0.25]) 
        #fig.colorbar(dens, orientation='vertical', cax=cbaxes, label='Density', format='%.1f')
    
        ax  = fig.add_subplot(122, projection='stereonet')
        
        ax.pole(azimuth_, latitude - 90, c='k', label='Pole of the Planes', \
                markersize=1.75, alpha=0.5)

        dens = ax.density_contourf(azimuth_, latitude - 90, measurement='poles', \
                                   cmap=cmap, levels=15)
        #ax.set_thetagrids(np.arange(0, 360, 10), labels=np.arange(0, 360, 10))
        
        ax.set_title("Delta: {} \n'{}' \nDepth: {} m - Bag: {}_{} \nOffset2Swiss: {}\nLateral Const.: {}\nExtention Fold: {}\n Flat: {}".format(\
                     delta, rotation_dir, depth_p, bag, segment, abw, dt_lateral, dt_extension, dt_flat), y=1.15, fontsize=22)
        ax.grid()
        
        plt.savefig(figure_path + 'new_delta_Stereo_rotated_linescan_' + Filename + '.png', \
                    dpi=100, bbox_inches='tight') 
        print('===> Saved: Stereo_rotated_linescan_{}.png'.format(Filename))
        print('')
        plt.close()

    except FileNotFoundError:
        pass
        


