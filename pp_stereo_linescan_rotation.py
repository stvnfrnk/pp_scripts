#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Mar 21 12:39:45 2020

@author: sfranke
"""


import pandas as pd
import numpy as np
from matplotlib import pyplot as plt
from matplotlib import gridspec
import mplstereonet
import os, glob
import shutil



pd.set_option('display.max_rows', 200)
pd.set_option('display.max_columns', 20)
pd.set_option('display.width', 1500)

Seafile = 'C:/Seafile/'
Seafile = '/Users/sfranke/Seafile/'

stereo_files_path   = Seafile + 'Orca/2019_EGRIP_Field/PP_Results/stereo_plots/stereo_plot_files/'
#figure_path         = Seafile + 'Orca/2019_EGRIP_Field/PP_Results/stereo_plots/stereo_plots_rotated/'

os.chdir(stereo_files_path)


#cmap='ocean_r'
cmap='Blues'




#%%

#############################################################
# Single Plots ===>>  ROTATED or UNROTATED
# doing a plot for every file in the stero_path_folder *.txt
# or from a list with rotation values
#############################################################

# just rotation (single plot)
if 0:
        
    # save output figures here
    figure_path = Seafile + 'Orca/2019_EGRIP_Field/PP_Results/stereo_plots/linescan_rotation/'
    
    # load rotation data from file
    df_rotation = pd.read_csv(Seafile + 'Orca/2019_EGRIP_Field/PP_Results/stereo_plots/rotation_list_linescan.csv', delimiter=',')
    
    print('')
    print('++++ ROTATION VALUES FROM LINESCANNER ++++')
    print('++++ Plotting rotated Stereo Plots and Rose Diagrams')
    print('++++ Figure Path: {}'.format(figure_path))
    print('')
    
    for i in range(len(df_rotation)):
        
        rotation_bag_section    = str(df_rotation['bag_section'][i])
        rotation                = int(df_rotation['rotation'][i])
        #rotation = 0
    
        
        file = 'stereo_EGRIP' + rotation_bag_section + '_20.txt'
        
    
        # Reading Data and defining variables
        df                  = pd.read_csv(file, delimiter='\t')
        df.columns          = ['azimuth', 'latitude']
        azimuth, latitude   = df['azimuth'], df['latitude']
        azimuth             = azimuth - rotation + 35
        number_of_grains    = str(df.shape[0])
        appendix            = ''
        
    
        # Determining Bagnumber and section type via the filename
        # 1. Going for regular files (no volume sections)
        try:
            if 1:
                Bag         = file.split('_')[1].split('EGRIP')[1]
                Segment     = file.split('_')[2]
                Filename    = 'EGRIP' + '_' + Bag + '_' + Segment + appendix
                Depth       = ((float(Bag) * 0.55) + (float(Segment)) * (0.55/6)) - 0.55
                Depth_p     = np.round(Depth, decimals=1).astype(str)
            
            if 0:
                Bag         = file.split('_')[3]
                Segment     = file.split('_')[4]
                Filename    = 'S5' + '_' + Bag + '_' + Segment + appendix
                Depth       = ((float(Bag) * 0.55) + (float(Segment)) * (0.55/6)) - 0.55
                Depth_p     = np.round(Depth, decimals=1).astype(str)
            
        except ValueError:
            pass
        
        '''
        try:
            if 0:
                # 2. Going for horizontal volume samples
                if 'horizontal' in file:
                    Bag         = file.split('_')[1].split('EGRIP')[1]
                    Segment     = file.split('_')[4]
                    Filename    = 'EGRIP' + '_' + Bag + '_Volume_Horizontal_' + Segment + appendix
                    Depth       = (float(Bag) * 0.55) - 0.55
                    Depth_p     = np.round(Depth, decimals=1).astype(str)
                
                # 3. Going for vertical volume samples
                elif 'vertical' in file:
            
                    Bag         = file.split('_')[1].split('EGRIP')[1]
                    Segment     = file.split('_')[4]
                    Filename    = 'EGRIP' + '_' + Bag + '_Volume_Vertical_' + Segment + appendix
                    Depth       = (float(Bag) * 0.55) - 0.55
                    Depth_p     = np.round(Depth, decimals=1).astype(str)
                    
            if 1:
                # 2. Going for horizontal volume samples
                if 'horizontal' in file:
                    Bag         = file.split('_')[3]
                    Segment     = file.split('_')[6]
                    Filename    = 'S5' + '_' + Bag + '_Volume_Horizontal_' + Segment + appendix
                    Depth       = (float(Bag) * 0.55) - 0.55
                    Depth_p     = np.round(Depth, decimals=1).astype(str)
                
                # 3. Going for vertical volume samples
                elif 'vertical' in file:
            
                    Bag         = file.split('_')[3]
                    Segment     = file.split('_')[4]
                    Filename    = 'S5' + '_' + Bag + '_Volume_Vertical_' + Segment + appendix
                    Depth       = (float(Bag) * 0.55) - 0.55
                    Depth_p     = np.round(Depth, decimals=1).astype(str)
                
        except:
            # if none of the filename criteria are fullfilled, 
            # I'll trow an error and pass
            print('===> !!!! An Error occured while reading the filename ...')
            print('===> Skipping....')
            print('')
            pass
       
        '''
        
        # 
        bin_edges                       = np.arange(0, 365, 10)
        number_of_strikes, bin_edges    = np.histogram(azimuth, bin_edges)
        bin_data                        = number_of_strikes
        
        
        ###############
        #   Plotting  #
        ###############
    
        print('===> Plotting: {}'.format(Filename))
        
        fig = plt.figure(figsize=(16,18.5))
        ax  = fig.add_subplot(121, projection='stereonet')
        #plt.suptitlle()
        
        ax.pole(azimuth - 90, latitude - 90, c='k', label='Pole of the Planes', \
                markersize=1.75, alpha=0.5)
        dens = ax.density_contourf(azimuth - 90, latitude - 90, measurement='poles', \
                                   cmap=cmap, levels=15)
        #ax.set_title(Filename + '\nDepth: ' + Depth_p + ' m' + \
                     #'\n Number of Grains: ' + '{:04d}'.format(int(number_of_grains)),\
                     #y=1.15, fontsize=20)
        #ax.set_title('Depth: {} m\nBag: {}\nNumber of Grains: {}'.format(\
        #            Depth_p, Filename, int(number_of_grains)), y=1.10, fontsize=20)
        
        ax.set_title('Depth: {} m \nBag: {}_{} \nRotation: {}'.format(\
                     Depth_p, Bag, Segment, rotation), y=1.15, fontsize=24)
        ax.grid()
        #cbaxes = fig.add_axes([0.54, 0.375, 0.02, 0.25]) 
        #fig.colorbar(dens, orientation='vertical', cax=cbaxes, label='Density', format='%.1f')
    
        if 0:
            ax2 = fig.add_subplot(122, projection='polar')
    
            ax2.bar(np.deg2rad(np.arange(0, 360, 10)), bin_data, 
                   width=np.deg2rad(10), bottom=0.0, color='.8', edgecolor='k')
            ax2.set_theta_zero_location('N')
            ax2.set_theta_direction(-1)
            ax2.set_thetagrids(np.arange(0, 360, 10), labels=np.arange(0, 360, 10))
            #ax2.set_rgrids(np.arange(1, two_halves.max() + 1, 2), angle=0, weight= 'black')
            #ax2.set_title('Rose Diagram of the "Fault System"', y=1.10, fontsize=20)
            ax2.set_title('Bag: {}_{}'.format(Bag, Segment), y=1.15, fontsize=28)
        
        plt.savefig(figure_path + 'Stereo_rotated_linescan_' + Filename + '.png', \
                    dpi=200, bbox_inches='tight') 
        print('===> Saved: Stereo_rotated_linescan_{}.png'.format(Filename))
        print('')
        plt.close()




#%%

# original + rotated version
if 1:

    # save output figures here
    figure_path = Seafile + 'Orca/2019_EGRIP_Field/PP_Results/stereo_plots/linescan_rotation/'
    
    # load rotation data from file
    df_rotation = pd.read_csv(Seafile + 'Orca/2019_EGRIP_Field/PP_Results/stereo_plots/rotation_list_linescan.csv', delimiter=',')
    
    print('')
    print('++++ ROTATION VALUES FROM LINESCANNER ++++')
    print('++++ Plotting rotated Stereo Plots and Rose Diagrams')
    print('++++ Figure Path: {}'.format(figure_path))
    print('')
    
    for i in range(len(df_rotation)):
        
        rotation_bag_section    = str(df_rotation['bag_section'][i])
        rotation                = int(df_rotation['rotation'][i])
        #rotation = 0
    
        
        file = 'stereo_EGRIP' + rotation_bag_section + '_20.txt'
        
    
        # Reading Data and defining variables
        df                   = pd.read_csv(file, delimiter='\t')
        df.columns           = ['azimuth', 'latitude']
        azimuth, latitude    = df['azimuth'], df['latitude']
        azimuth_             = azimuth - rotation + 25
        number_of_grains     = str(df.shape[0])
        appendix             = ''
        
    
        # Determining Bagnumber and section type via the filename
        # 1. Going for regular files (no volume sections)
        try:
            if 1:
                Bag         = file.split('_')[1].split('EGRIP')[1]
                Segment     = file.split('_')[2]
                Filename    = 'EGRIP' + '_' + Bag + '_' + Segment + appendix
                Depth       = ((float(Bag) * 0.55) + (float(Segment)) * (0.55/6)) - 0.55
                Depth_p     = np.round(Depth, decimals=1).astype(str)
            
            if 0:
                Bag         = file.split('_')[3]
                Segment     = file.split('_')[4]
                Filename    = 'S5' + '_' + Bag + '_' + Segment + appendix
                Depth       = ((float(Bag) * 0.55) + (float(Segment)) * (0.55/6)) - 0.55
                Depth_p     = np.round(Depth, decimals=1).astype(str)
            
        except ValueError:
            pass
        
        
        # 
        bin_edges                       = np.arange(0, 365, 10)
        number_of_strikes, bin_edges    = np.histogram(azimuth, bin_edges)
        bin_data                        = number_of_strikes
        
        
        ###############
        #   Plotting  #
        ###############
    
        print('===> Plotting: {}'.format(Filename))
        
        fig = plt.figure(figsize=(16,18.5))
        ax  = fig.add_subplot(121, projection='stereonet')
        
        ax.pole(azimuth - 90, latitude - 90, c='k', label='Pole of the Planes', \
                markersize=1.75, alpha=0.5)
        dens = ax.density_contourf(azimuth - 90, latitude - 90, measurement='poles', \
                                   cmap=cmap, levels=15)

        ax.set_title('Random Orientation \nDepth: {} m - Bag: {}_{} \nNo Rotation'.format(\
                     Depth_p, Bag, Segment), y=1.15, fontsize=22)
        ax.grid()
        #cbaxes = fig.add_axes([0.54, 0.375, 0.02, 0.25]) 
        #fig.colorbar(dens, orientation='vertical', cax=cbaxes, label='Density', format='%.1f')
    
        ax  = fig.add_subplot(122, projection='stereonet')
        
        ax.pole(azimuth_ - 90, latitude - 90, c='k', label='Pole of the Planes', \
                markersize=1.75, alpha=0.5)
        dens = ax.density_contourf(azimuth_ - 90, latitude - 90, measurement='poles', \
                                   cmap=cmap, levels=15)
        
        ax.set_title('Towards Ice Flow (0°-180°) \nDepth: {} m - Bag: {}_{} \nRotation: -{}° + 25°'.format(\
                     Depth_p, Bag, Segment, rotation), y=1.15, fontsize=22)
        ax.grid()
        
        plt.savefig(figure_path + 'Stereo_rotated_linescan_' + Filename + '.png', \
                    dpi=100, bbox_inches='tight') 
        print('===> Saved: Stereo_rotated_linescan_{}.png'.format(Filename))
        print('')
        plt.close()









