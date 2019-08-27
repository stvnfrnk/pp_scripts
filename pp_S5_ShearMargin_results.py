
import pandas as pd
import numpy as np
from matplotlib import pyplot as plt
from matplotlib import gridspec
import os
import scipy.io


pd.set_option('display.max_rows', 200)
pd.set_option('display.max_columns', 20)
pd.set_option('display.width', 1500)


os.chdir('/Users/sfranke/Seafile/Orca/2019_EGRIP_Field/PP_Results/S5_ShearMargin/')


####
# READ 2019 DATA

df = pd.read_csv('statistics_S5_ShearMargin.txt', skiprows=26, delimiter='\t')

df.columns=['data_directory', 
            'nr_of_grains', 
            'mean_grain_size_pixel',
            'sum_vector_norm',
            'regelungsgrad',
            'regelungsgrad_g_weighted',
            'conc_parameter',
            'conc_parameter_g_weighted',
            'spherical_ap_deg',
            'spherical_ap_g_weighted_deg',
            'eigenvalue_e1',
            'eigenvalue_e1_g_weighted',
            'eigenvalue_e2',
            'eigenvalue_e2_g_weighted',
            'eigenvalue_e3',
            'eigenvalue_e3_g_weighted',
            'woodcock_par',
            'woodcock_par_g_weighted']


#%%

for i in df.index:
    df.at[i, 'bag_number'] = \
    df['data_directory'][i].split('/')[-1].split('S5')[1].split('_')[1]
    df.at[i, 'bag_section'] = \
    df['data_directory'][i].split('/')[-1].split('S5')[1].split('_')[2]


#%%

# Unschön:
df['bag_section'] = df['bag_section'].str.replace('volume', '0')
df['bag_section'] = df['bag_section'].str.replace('vertical', '0')
df['bag_section'] = df['bag_section'].astype(int)

#%%

###################
# Define Variables
###################


df['depth'] = ((df['bag_number'].astype(float) * 0.55) + \
               (df['bag_section'].astype(float) * (0.55/6))) - 0.55

df['grain_area_mm2'] = df['mean_grain_size_pixel'] * 20 * 20 * 1e-6
df['grain_area_m2'] = df['mean_grain_size_pixel'] * 20 * 20 * 1e-12
df['grain_diameter_mm'] = 2 * np.sqrt(df['grain_area_mm2'] / np.pi)
df['grain_diameter_m'] = 2 * np.sqrt(df['grain_area_m2'] / np.pi)


depth           = df['depth']
e1              = df['eigenvalue_e1']
e2              = df['eigenvalue_e2']
e3              = df['eigenvalue_e3']
grainsize       = df['mean_grain_size_pixel']
grain_area      = df['grain_area_mm2']
nr_grain        = df['nr_of_grains']
regelungsgrad   = df['regelungsgrad']

df = df.sort_values(by=['bag_number', 'bag_section'])

#%%

#############
# WRITE DATA
#############

#df = df.drop_duplicates()


# CSV Data

if 1:
    # PP Data
    df.to_csv('PP_S5_ShearMargin_2019_Results.csv', sep='\t', index=False)

# MAT Files
    
if 1:
    ## PP Data
    df_array = {name: col.values for name, col in df.items()}
    
    df_mat_filename = 'PP_S5_ShearMargin_2019_Results.mat'
    scipy.io.savemat(df_mat_filename, df_array)
    print('Saved DataFrame as: {}'.format(df_mat_filename))


#%%
    

#########################
# Plot several parameters
# Full depth scale
#########################
        
if 1:

    fig = plt.subplots(figsize=(15,10))
    plt.suptitle('S5 Shear Margin Shallow Drill')

    gs = gridspec.GridSpec(1, 3,
                           width_ratios=[1, 1, 1],
                           height_ratios=[1]
                           )
    
    #ylimit = 2800
    #step   = 100
    
    #################
    ## 1. Eigenvalues
    ax1 = plt.subplot(gs[0])
    
    ax1.plot(e1, depth, '^', color='blue', label='e1', markersize=10, alpha=0.5)
    ax1.plot(e2, depth, '<', color='purple', label='e2', markersize=10, alpha=0.5)
    ax1.plot(e3, depth, '>', color='orange', label='e3', markersize=10, alpha=0.5)
    
    plt.gca().invert_yaxis()
    ax1.legend(loc='lower center', ncol=1)
    #plt.legend(bbox_to_anchor=(0.3, -0.1, 0.5, .102), loc=3, \
               #ncol=2, borderaxespad=0.5)    
    #plt.ylim(ylimit, 0)
    #plt.yticks(np.arange(0, ylimit, step=step))
    plt.grid()
    plt.title('eigen vectors')
    
    
    ################
    ## 2. Grain Area
    
    ax2 = plt.subplot(gs[1])
    ax2.scatter(grain_area, depth, s=grain_area * 30, facecolors='none', \
                edgecolors='black', label='Mean Grain Area (mm2)')

    plt.gca().invert_yaxis()
    ax2.legend(loc='lower left', ncol=1)      
    #plt.ylim(ylimit, 0)
    plt.title('Grain Area [mm^2]', fontsize='8')
    #plt.yticks(np.arange(0, ylimit, step=step))
    plt.grid()
    
    
    ###################
    ## 3. Regelungsgrad
    
    ax3 = plt.subplot(gs[2])
    ax3.plot(regelungsgrad, depth, 'd', color='black', \
             label='regelungsgrad', markersize=15, linewidth=2, alpha=0.3)

    plt.gca().invert_yaxis()
    ax3.legend(loc='lower left')
    #plt.ylim(ylimit, 0)
    plt.title('regelungsgrad')
    #plt.yticks(np.arange(0, ylimit, step=step))
    plt.grid()
    
    
    #############
    # Save Figure
    #############
    
    plt.savefig('PP_S5_ShearMargin.png', dpi=300)



