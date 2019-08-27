
import pandas as pd
import numpy as np
from matplotlib import pyplot as plt
from matplotlib import gridspec
import os
import scipy.io


pd.set_option('display.max_rows', 200)
pd.set_option('display.max_columns', 20)
pd.set_option('display.width', 1500)


os.chdir('/Users/sfranke/Seafile/Orca/2019_EGRIP_Field/PP_Results/')


####
# READ 2019 DATA

df = pd.read_csv('statistics_EGRIP2017_18_19.txt', skiprows=26, delimiter='\t')

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




for i in df.index:
    df.at[i, 'bag_number'] = \
    df['data_directory'][i].split('/')[-1].split('EGRIP')[1].split('_')[0]
    df.at[i, 'bag_section'] = \
    df['data_directory'][i].split('/')[-1].split('EGRIP')[1].split('_')[1]
    df.at[i, 'second_try'] = \
    df['data_directory'][i].split('/')[-1].split('_20')[-1]

# Unschön:
df['bag_section'] = df['bag_section'].str.replace('volume', '3')
df['bag_section'] = df['bag_section'].str.replace('vertical', '3')
df['bag_section'] = df['bag_section'].astype(int)

#%%

# Check if second try was necesarry
# and delete the first one
'''
idx2 = df[df['second_try'] == '-2'].index
idx3 = df[df['second_try'] == '-3'].index
idx4 = df[df['second_try'] == '-4'].index

for i in idx4:

    one = df['data_directory'][i-1].split('_20')[0]
    two = df['data_directory'][i].split('_20')[0]

    if one == two:
        print(df['data_directory'][i-1])
        print(df['data_directory'][i])
        print('dropping: {}'.format(df['data_directory'][i-1]))
        print('')
        df.drop(i - 1)

for i in idx3:

    one = df['data_directory'][i-1].split('_20')[0]
    two = df['data_directory'][i].split('_20')[0]

    if one == two:
        print(df['data_directory'][i-1])
        print(df['data_directory'][i])
        print('dropping: {}'.format(df['data_directory'][i-1]))
        print('')
        df.drop(i - 1)

for i in idx2:

    one = df['data_directory'][i-1].split('_20')[0]
    two = df['data_directory'][i].split('_20')[0]

    if one == two:
        print(df['data_directory'][i-1])
        print(df['data_directory'][i])
        print('dropping: {}'.format(df['data_directory'][i-1]))
        print('')
        df.drop(i - 1)

'''

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

df = df.sort_values(by=['depth'])
df = df.reset_index()

#%%
'''
##################################
##################################
##################################

# ADDITIONAL DATA


df2 = pd.read_csv('statistics_2019_07_24.txt', skiprows=26, delimiter='\t')

df2.columns=['data_directory', 
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



# remove vertical sections

for i in df2.index:
    df2.at[i, 'bag_number'] = \
    df2['data_directory'][i].split('/')[-1].split('EGRIP')[1].split('_')[0]
    df2.at[i, 'bag_section'] = \
    df2['data_directory'][i].split('/')[-1].split('EGRIP')[1].split('_')[1]
    df2.at[i, 'second_try'] = \
    df2['data_directory'][i].split('/')[-1].split('_20')[-1]

# Unschön:
df2['bag_section'] = df2['bag_section'].str.replace('volume', '3')
df2['bag_section'] = df2['bag_section'].str.replace('vertical', '3')
df2['bag_section'] = df2['bag_section'].astype(int)


# Check if second try was necesarry
# and delete the first one



idy2 = df2[df2['second_try'] == '-2'].index
idy3 = df2[df2['second_try'] == '-3'].index
idy4 = df2[df2['second_try'] == '-4'].index

for i in idy2:
    if i == 0:
        pass
    else:
        one = df2['data_directory'][i-1].split('_20')[0]
        two = df2['data_directory'][i].split('_20')[0]
    
        if one == two:
            print(df2['data_directory'][i-1])
            print(df2['data_directory'][i])
            print('dropping: {}'.format(df2['data_directory'][i-1]))
            print('')
            df2.drop(i - 1)

        


df2['depth'] = ((df2['bag_number'].astype(float) * 0.55) + \
               (df2['bag_section'].astype(float) * (0.55/6))) - 0.55

df2['grain_area_mm2'] = df2['mean_grain_size_pixel'] * 20 * 20 * 1e-6
df2['grain_area_m2'] = df2['mean_grain_size_pixel'] * 20 * 20 * 1e-12
df2['grain_diameter_mm'] = 2 * np.sqrt(df2['grain_area_mm2'] / np.pi)
df2['grain_diameter_m'] = 2 * np.sqrt(df2['grain_area_m2'] / np.pi)


depth_2           = df2['depth']
e1_2              = df2['eigenvalue_e1']
e2_2              = df2['eigenvalue_e2']
e3_2              = df2['eigenvalue_e3']
grainsize_2       = df2['mean_grain_size_pixel']
grain_area_2      = df2['grain_area_mm2']
nr_grain_2        = df2['nr_of_grains']
regelungsgrad_2   = df2['regelungsgrad']

'''
#%%

##################
# DRILL LOG DATA
##################

df_drill = pd.read_csv('plotting_tools/drilllog_2018_2019.csv')
df_drill.columns = ['depth_drillerlog', 'inclination', 'breakload']

# get Super Banger index in driller log
idx = df_drill[df_drill['breakload']==-1].index
SB_depth = df_drill['depth_drillerlog'][idx]

df_drill['breakload'].mask((df_drill['breakload'] < 1), inplace=True)

drill_depth = df_drill['depth_drillerlog']
breakload   = df_drill['breakload']
inc_drill   = df_drill['inclination']



####################
# NICO's PP RESULTS #
####################

dfn             = pd.read_csv('plotting_tools/EGRIP2019_PP_data_REFORMATTED.csv', \
                              delimiter='\t')

depth_n         = dfn['Top_depth']
e1_n            = dfn['e1']
e2_n            = dfn['e2']
e3_n            = dfn['e3']
grainsize_n     = dfn['mean_grainSize']
#nr_grain_n      = dfn['number_grains']
#regelungsgrad_n = dfn['regelungsgrad']


##############
# LOGGING DATA
##############

dfl_May      = pd.read_csv('plotting_tools/Logger_May2019.csv')
LogMay_depth = dfl_May['Depth']
LogMay_Temp  = dfl_May['Temp']

dfl_June      = pd.read_csv('plotting_tools/Logger_June2019_org.csv')
LogJune_End   = dfl_June[dfl_June['depth'] == dfl_June['depth'].max()].index.min()
dfl_June      = dfl_June[0:LogJune_End]
LogJune_depth = dfl_June['depth']
LogJune_Temp  = dfl_June['thermistor_high']
LogJune_Press = dfl_June['pressure']

dfl_July            = pd.read_csv('plotting_tools/Logger_9July2019_org.csv')
LogJuly_End         = dfl_July[dfl_July['depth'] == dfl_July['depth'].max()].index.min()
dfl_July            = dfl_July[89:LogJuly_End]
LogJuly_depth       = dfl_July['depth']
LogJuly_Temp        = dfl_July['thermistor_high']
#LogJuly_Temp_high   = dfl_July['thermistor_high']
#LogJuly_Temp_low    = dfl_July['thermistor_low']
#LogJuly_Temp_Diff   = dfl_July['thermistor_high'] - dfl_July['thermistor_low']
#LogJuly_Press       = dfl_July['pressure']

#logger_array = np.array([LogMay_depth, LogMay_Temp])



#################
# LINE SCAN DATA
#################

dfLS      = pd.read_csv('LS-Julien/grayscale_2019.txt', delimiter='\t')

depth_LS_tmp    = dfLS['depth'] 
bag_LS          = dfLS['bag']
mm_LS           = dfLS['mm']
grayvalue       = dfLS['grayvalue'] 
grayvalue_rm    = dfLS['1m runing mean'] 
depth_LS        = depth_LS_tmp + (mm_LS / 1000)
dfLS['depth_']    = dfLS['depth'] + (dfLS['mm'] / 1000)


#%%

#####################################
# Line Scan and O18 Data from Dorthe
#####################################
if 0:
    dfO18 = pd.read_csv('EGRIP_RES_DEPTH_NGRIPO18.txt', delimiter='\t')
    
    fig = plt.subplots(figsize=(15,5))
    
    ax1 = plt.plot(dfO18.index, dfO18['line_scan'])
    ax2 = plt.plot(dfO18.index, dfO18['O18'])
    
    plt.show()

#%%

################################
# Bag numbers with Super Bangers
################################

SB_Bag = [3260, 3273, 3681, 3704, 3795]

#       BagNr. * BagLength - 0.55 (--> Bag1 corresponds to Depth = 0m) 
#       + half Bag length (for the center of the bag)
SBB1 = (SB_Bag[0] * 0.55) - 0.55 + (0.55/2)
SBB2 = (SB_Bag[1] * 0.55) - 0.55 + (0.55/2)
SBB3 = (SB_Bag[2] * 0.55) - 0.55 + (0.55/2)
SBB4 = (SB_Bag[3] * 0.55) - 0.55 + (0.55/2)
SBB5 = (SB_Bag[4] * 0.55) - 0.55 + (0.55/2)

# Difference in SB Depth from Drill log to Depth from Bag Numbers
DIFF_SB = []
DIFF_SB.append(np.array(SB_depth)[0] - SBB1)
DIFF_SB.append(np.array(SB_depth)[1] - SBB2)
DIFF_SB.append(np.array(SB_depth)[2] - SBB3)
DIFF_SB.append(np.array(SB_depth)[3] - SBB4)
DIFF_SB.append(np.array(SB_depth)[4] - SBB5)


## Get rows with Superbanger bags
SB_BagRows = {SB_Bag[0]: \
              np.array(df.loc[df['bag_number'].astype(int)==SB_Bag[0]].index), 
              SB_Bag[1]: \
              np.array(df.loc[df['bag_number'].astype(int)==SB_Bag[1]].index),
              SB_Bag[2]: \
              np.array(df.loc[df['bag_number'].astype(int)==SB_Bag[2]].index), 
              SB_Bag[3]: \
              np.array(df.loc[df['bag_number'].astype(int)==SB_Bag[3]].index),
              SB_Bag[4]: \
              np.array(df.loc[df['bag_number'].astype(int)==SB_Bag[4]].index)}

# Put these bags in a DataFrame
df_SB1 = df[df.index.isin(SB_BagRows[SB_Bag[0]].tolist())]
df_SB2 = df[df.index.isin(SB_BagRows[SB_Bag[1]].tolist())]
df_SB3 = df[df.index.isin(SB_BagRows[SB_Bag[2]].tolist())]
df_SB4 = df[df.index.isin(SB_BagRows[SB_Bag[3]].tolist())]
df_SB5 = df[df.index.isin(SB_BagRows[SB_Bag[4]].tolist())]
df_SB  = pd.concat([df_SB1, df_SB2, df_SB3, df_SB4, df_SB5])



#%%

#####################################
#  Bag numbers with Easy Breaks (EB)
#####################################


EB_Bag = [3311, 3693, 3785]

#       BagNr. * BagLength - 0.55 (--> Bag1 corresponds to Depth = 0m) 
#       + half Bag length (for the center of the bag)
EBB1 = (EB_Bag[0] * 0.55) - 0.55 + (0.55/2)
EBB2 = (EB_Bag[1] * 0.55) - 0.55 + (0.55/2)
EBB3 = (EB_Bag[2] * 0.55) - 0.55 + (0.55/2)


# Difference in SB Depth from Drill log to Depth from Bag Numbers
#DIFF_EB = []
#DIFF_EB.append(np.array(EB_depth)[0] - EBB1)



## Get rows with Superbanger bags
EB_BagRows = {EB_Bag[0]: \
              np.array(df.loc[df['bag_number'].astype(int)==EB_Bag[0]].index), 
              EB_Bag[1]: \
              np.array(df.loc[df['bag_number'].astype(int)==EB_Bag[1]].index),
              EB_Bag[2]: \
              np.array(df.loc[df['bag_number'].astype(int)==EB_Bag[2]].index)}

# Put these bags in a DataFrame
df_EB1 = df[df.index.isin(EB_BagRows[EB_Bag[0]].tolist())]
df_EB2 = df[df.index.isin(EB_BagRows[EB_Bag[1]].tolist())]
df_EB3 = df[df.index.isin(EB_BagRows[EB_Bag[2]].tolist())]
df_EB  = pd.concat([df_EB1, df_EB2, df_EB3])


#%%

#####################################
#    Depth with abnormal diameter
#####################################

# Depth = 1825 - 1835
# Depth = 1842 - 1847

Bags = [3324 - 3331]

AD = []



#%%

#############
# WRITE DATA
#############

df = df.drop_duplicates()


# CSV Data

if 1:
    # PP Data
    df.to_csv('PP_Files/PP_Results_2017-19.csv', sep='\t', index=False)
    
    # Logging Data
    dfl_May.to_csv('PP_Files/Logging_2019_05.csv', sep='\t', index=False)
    dfl_June.to_csv('PP_Files/Logging_2019_06.csv', sep='\t', index=False)
    dfl_July.to_csv('PP_Files/Logging_2019_07.csv', sep='\t', index=False)


# MAT Files
    
if 1:
    ## PP Data
    df_array = {name: col.values for name, col in df.items()}
    
    df_mat_filename = 'PP_Results_EGRIP2017_18_19.mat'
    scipy.io.savemat('PP_Files/' + df_mat_filename, df_array)
    print('Saved DataFrame as: {}'.format(df_mat_filename))
    
    
    ## Logger Data  
    logger_array = {'Logger_May_Depth': np.array(LogMay_depth),
                    'Logger_May_Temp': np.array(LogMay_Temp),
                    'Logger_June_Depth': np.array(LogJune_depth),
                    'Logger_June_Temp': np.array(LogJune_Temp),
                    'Logger_July_Depth': np.array(LogJuly_depth),
                    'Logger_July_Temp': np.array(LogJuly_Temp)}
    
    log_mat_filename = 'Logger_Data_2019.mat'
    scipy.io.savemat('PP_Files/' + log_mat_filename, logger_array)
    print('Saved Logger Data as: {}'.format(log_mat_filename))
    
    ## Driller Log
    drill_array = {name: col.values for name, col in df_drill.items()}
    
    drill_mat_filename = 'Drill_Log_2019.mat'
    scipy.io.savemat('PP_Files/' + drill_mat_filename, drill_array)
    print('Saved DataFrame as: {}'.format(drill_mat_filename))
    
    


#%%

##################################
# Print Information of SuperBengel
##################################
    
if 0:
    for j in range(1, 6):        
        sb_depth = np.array(SB_depth)[j-1].astype(float)
        print('SB{} - Drill-Log Depth: {}, Bag: {}, Depth-Diff.: {:.2f}'\
              .format(j, sb_depth, SB_Bag[j-1], DIFF_SB[j-1]))


#%%
        
if 1:

    #########################
    # Plot several parameters
    # Full depth scale
    #########################
            
    if 1:
    
        fig = plt.subplots(figsize=(25,15))
        plt.suptitle('EGRIP - CFO and Drill Parameters (0 - 2300 m depth)')
    
        gs = gridspec.GridSpec(1, 6,
                               width_ratios=[2, 1, 1, 1, 1, 1],
                               height_ratios=[1]
                               )
        
        ylimit = 2800
        step   = 100
        
        #################
        ## 1. Eigenvalues
        ax1 = plt.subplot(gs[0])
        
        ax1.plot(e1, depth, '^', color='blue', label='e1', markersize=5, alpha=0.5)
        ax1.plot(e2, depth, '<', color='purple', label='e2', markersize=5, alpha=0.5)
        ax1.plot(e3, depth, '>', color='orange', label='e3', markersize=5, alpha=0.5)
        
        
        # Second Data File
        #ax1.plot(e1_2, depth_2, '+', color='black', label='e1', markersize=3)
        #ax1.plot(e2_2, depth_2, '+', color='black', label='e2', markersize=3)
        #ax1.plot(e3_2, depth_2, '+', color='black', label='e3', markersize=3)
        
        
        # Plotting SUPER BANGER PARAMS
        ax1.plot(df_SB['eigenvalue_e1'], df_SB['depth'], '^', color='red', \
                 label='SB e1', markersize=5)
        ax1.plot(df_SB['eigenvalue_e2'], df_SB['depth'], '<', color='red', \
                 label='SB e2', markersize=5)
        ax1.plot(df_SB['eigenvalue_e3'], df_SB['depth'], '>', color='red', \
                 label='SB e3', markersize=5)
        
        
        # Plotting Easy Break PARAMS
        ax1.plot(df_EB['eigenvalue_e1'], df_EB['depth'], '^', color='green', \
                 label='EB e1', markersize=5)
        ax1.plot(df_EB['eigenvalue_e2'], df_EB['depth'], '<', color='green', \
                 label='EB e2', markersize=5)
        ax1.plot(df_EB['eigenvalue_e3'], df_EB['depth'], '>', color='green', \
                 label='EB e3', markersize=5)
        
        # Super Banger Depth from Bag Nr.
        plt.axhline(y=SBB1, linewidth=0.5, color='red', label='Super Banger Depth:')
        plt.axhline(y=SBB2, linewidth=0.0, color='red', label='{:.1f}m, {:.1f}m, {:.1f}m,'.format(SBB1, SBB2, SBB3))
        plt.axhline(y=SBB2, linewidth=0.0, color='red', label='{:.1f}m, {:.1f}m'.format(SBB4, SBB5))
        plt.axhline(y=SBB2, linewidth=0.5, color='red')
        plt.axhline(y=SBB3, linewidth=0.5, color='red')
        plt.axhline(y=SBB4, linewidth=0.5, color='red')
        plt.axhline(y=SBB5, linewidth=0.5, color='red')
        
        
        # Easy Breaks Depth from Bag Nr.
        plt.axhline(y=EBB1, linewidth=1, color='green', \
                    linestyle='--', label='Easy Break Depth')
        plt.axhline(y=EBB2, linewidth=0, color='green', \
                    label='{:.1f}m, {:.1f}m, {:.1f}m,'.format(EBB1, EBB2, EBB3))
        plt.axhline(y=EBB2, linewidth=1, linestyle='--', color='green')
        plt.axhline(y=EBB3, linewidth=1, linestyle='--', color='green')
        plt.axhline(y=EBB2, linewidth=0, linestyle='--', color='green', label='  ') # dummys for legend layout
        plt.axhline(y=EBB3, linewidth=0, linestyle='--', color='green', label='  ') # dummys for legend layout
        plt.axhline(y=EBB2, linewidth=0, linestyle='--', color='green', label='  ') # dummys for legend layout
        plt.axhline(y=EBB3, linewidth=0, linestyle='--', color='green', label='  ') # dummys for legend layout
    
    
        plt.gca().invert_yaxis()
        ax1.legend(loc='lower center', ncol=2)
        #plt.legend(bbox_to_anchor=(0.3, -0.1, 0.5, .102), loc=3, \
                   #ncol=2, borderaxespad=0.5)    
        plt.ylim(ylimit, 0)
        plt.yticks(np.arange(0, ylimit, step=step))
        plt.grid()
        plt.title('eigen vectors')
        
        
        ################
        ## 2. Grain Area
        
        ax2 = plt.subplot(gs[1])
        ax2.scatter(grain_area, depth, s=grain_area * 3, facecolors='none', \
                    edgecolors='black', label='Mean Grain Area (mm2)')
        # Super Banger
        ax2.scatter(df_SB['mean_grain_size_pixel'] * 20 * 20 * 1e-6, df_SB['depth'],\
                 s=grain_area * 3, facecolors='none', edgecolors='red', \
                 label='SB Grain Area (mm2)', linewidth=1.5)
        # Easy Breaks
        ax2.scatter(df_EB['mean_grain_size_pixel'] * 20 * 20 * 1e-6, df_EB['depth'],\
                 s=grain_area * 20, facecolors='none', edgecolors='green', \
                 label='EB Grain Area (mm2)', linewidth=1.5)
    
        #ax2.plot(grain_area_2, depth_2, '+', color='black', \
        #         label='Mean Grain Area [mm^2]', markersize=3)
        #ax2.plot(grainsize, depth, '+', color='black', label='mean grain size')
    
        
        # Super Banger Depth from Bag Nr.
        plt.axhline(y=SBB1, linewidth=0.5, color='red')
        plt.axhline(y=SBB2, linewidth=0.5, color='red')
        plt.axhline(y=SBB3, linewidth=0.5, color='red')
        plt.axhline(y=SBB4, linewidth=0.5, color='red')
        plt.axhline(y=SBB5, linewidth=0.5, color='red')
    
        plt.gca().invert_yaxis()
        ax2.legend(loc='lower left', ncol=1)      
        plt.ylim(ylimit, 0)
        plt.title('Grain Area [mm^2]', fontsize='8')
        plt.yticks(np.arange(0, ylimit, step=step))
        plt.grid()
        
        
        ###################
        ## 3. Regelungsgrad
        
        ax3 = plt.subplot(gs[2])
        ax3.plot(regelungsgrad, depth, 'd', color='black', \
                 label='regelungsgrad', markersize=5, linewidth=2, alpha=0.3)
        # Super Banger
        ax3.plot(df_SB['regelungsgrad'], df_SB['depth'], 'd', color='red', \
                 label='SB Regelungsgrad', markersize=5)    
        # Easy Breaks
        ax3.plot(df_EB['regelungsgrad'], df_EB['depth'], 'd', color='green', \
                 label='SB Regelungsgrad', markersize=5, linewidth=2) 
        
        # Super Banger Depth from Bag Nr.
        plt.axhline(y=SBB1, linewidth=0.5, color='red')
        plt.axhline(y=SBB2, linewidth=0.5, color='red')
        plt.axhline(y=SBB3, linewidth=0.5, color='red')
        plt.axhline(y=SBB4, linewidth=0.5, color='red')
        plt.axhline(y=SBB5, linewidth=0.5, color='red')
    
        plt.gca().invert_yaxis()
        ax3.legend(loc='lower left')
        plt.ylim(ylimit, 0)
        plt.title('regelungsgrad')
        plt.yticks(np.arange(0, ylimit, step=step))
        plt.grid()
        
        
        ###################
        ## 4. LineScanner
        
        ax4 = plt.subplot(gs[3])
        ax4.scatter(grayvalue_rm, depth_LS, s=2, edgecolors='none',\
                    c=grayvalue_rm-30, cmap='gray', label='Gray Value')
    
        #ax2.plot(grainsize, depth, '+', color='black', label='mean grain size')
        plt.gray()
        
        # Super Banger Depth from Bag Nr.
        plt.axhline(y=SBB1, linewidth=0.5, color='red')
        plt.axhline(y=SBB2, linewidth=0.5, color='red')
        plt.axhline(y=SBB3, linewidth=0.5, color='red')
        plt.axhline(y=SBB4, linewidth=0.5, color='red')
        plt.axhline(y=SBB5, linewidth=0.5, color='red')
    
        plt.gca().invert_yaxis()
        ax4.legend(loc='lower left', fontsize='12')
        plt.ylim(ylimit, 0)
        plt.title('Line Scanner')
        plt.yticks(np.arange(0, ylimit, step=step))
        plt.grid()
        
        
        #################
        ## 5. Temperature
        
        ax5 = plt.subplot(gs[4])
        ax5.plot(LogMay_Temp, LogMay_depth, color='blue', \
                 label='Temp. 2019-05', markersize=3)
        ax5.plot(LogJune_Temp, LogJune_depth, color='red', \
                 label='Temp. 2019-06', markersize=3)
        ax5.plot(LogJuly_Temp, LogJuly_depth, color='green', \
                 label='Temp. 2019-07', markersize=3)
        
        
        plt.axhline(y=SBB1, linewidth=0.5, color='red')
        plt.axhline(y=SBB2, linewidth=0.5, color='red')
        plt.axhline(y=SBB3, linewidth=0.5, color='red')
        plt.axhline(y=SBB4, linewidth=0.5, color='red')
        plt.axhline(y=SBB5, linewidth=0.5, color='red')
        
        
        plt.gca().invert_yaxis()
        ax5.legend(loc='lower right')
        plt.xlim(-33, -20)
        plt.ylim(ylimit, 0)
        plt.title('Temp. Logging July 2019')
        plt.yticks(np.arange(0, ylimit, step=step))
        plt.grid()
    
    
        ################
        ## 6. Break Load
        
        ax6 = plt.subplot(gs[5])
        ax6.scatter(breakload, drill_depth, s=breakload/15,  edgecolors='none',\
                    marker='+', c=breakload, cmap='jet', label='break load')
        
        plt.axhline(y=np.array(SB_depth)[0], linewidth=0.5)
        plt.axhline(y=np.array(SB_depth)[1], linewidth=0.5)
        plt.axhline(y=np.array(SB_depth)[2], linewidth=0.5)
        plt.axhline(y=np.array(SB_depth)[3], linewidth=0.5)
        plt.axhline(y=np.array(SB_depth)[4], linewidth=0.5)
        
        # Super Banger Depth from Bag Nr.
        plt.axhline(y=SBB1, linewidth=0.5, color='red')
        plt.axhline(y=SBB2, linewidth=0.5, color='red')
        plt.axhline(y=SBB3, linewidth=0.5, color='red')
        plt.axhline(y=SBB4, linewidth=0.5, color='red')
        plt.axhline(y=SBB5, linewidth=0.5, color='red')
        
        plt.gca().invert_yaxis()
        ax6.legend(loc='lower left')
        plt.ylim(ylimit, 0)
        plt.title('break load')
        plt.yticks(np.arange(0, ylimit, step=step))
        plt.grid()
        
        #############
        # Save Figure
        #############
        
        plt.savefig('figures/PP_EGRIP_Several.png', dpi=300)
    
    
    
    
    #%%
    
    ###############################################################################
    ###############################################################################
    ###############################################################################
    ###############################################################################
    ###############################################################################
        
        
    ######################################
    #       Plot several parameters
    # 2019 depth scale ca. (1700 - 2200m)
    ######################################
    
    if 1:
    
        fig = plt.subplots(figsize=(25,12))
        plt.suptitle('EGRIP - CFO and Drill Parameters (1750 - 2230 m depth)')
    
        gs = gridspec.GridSpec(1, 6,
                               width_ratios=[2, 1, 1, 1, 1, 1],
                               height_ratios=[1]
                               )
        
        y1      = 2250
        y2      = 1750
        step    = 10
        
      
        #################
        ## 1. Eigenvalues
        ax1 = plt.subplot(gs[0])
        
        ax1.plot(e1, depth, '^', color='blue', label='e1', markersize=8, alpha=0.5)
        ax1.plot(e2, depth, '<', color='purple', label='e2', markersize=8, alpha=0.5)
        ax1.plot(e3, depth, '>', color='orange', label='e3', markersize=8, alpha=0.5)
        
        
        # Second Data File
        #ax1.plot(e1_2, depth_2, '+', color='black', label='e1', markersize=3)
        #ax1.plot(e2_2, depth_2, '+', color='black', label='e2', markersize=3)
        #ax1.plot(e3_2, depth_2, '+', color='black', label='e3', markersize=3)
        
        
        # Plotting SUPER BANGER PARAMS
        ax1.plot(df_SB['eigenvalue_e1'], df_SB['depth'], '^', color='red', \
                 label='SB e1', markersize=8)
        ax1.plot(df_SB['eigenvalue_e2'], df_SB['depth'], '<', color='red', \
                 label='SB e2', markersize=8)
        ax1.plot(df_SB['eigenvalue_e3'], df_SB['depth'], '>', color='red', \
                 label='SB e3', markersize=8)
        
        
        # Plotting Easy Break PARAMS
        ax1.plot(df_EB['eigenvalue_e1'], df_EB['depth'], '^', color='green', \
                 label='EB e1', markersize=8)
        ax1.plot(df_EB['eigenvalue_e2'], df_EB['depth'], '<', color='green', \
                 label='EB e2', markersize=8)
        ax1.plot(df_EB['eigenvalue_e3'], df_EB['depth'], '>', color='green', \
                 label='EB e3', markersize=8)
        
        
        # Super Banger Depth from Bag Nr.
        plt.axhline(y=SBB1, linewidth=1, linestyle='--', color='red', \
                    label='Super Banger Depth:')
        plt.axhline(y=SBB2, linewidth=0.0, linestyle='--', color='red', \
                    label='{:.1f}m, {:.1f}m, {:.1f}m,'.format(SBB1, SBB2, SBB3))
        plt.axhline(y=SBB2, linewidth=0.0, linestyle='--', color='red', \
                    label='{:.1f}m, {:.1f}m'.format(SBB4, SBB5))
        plt.axhline(y=SBB2, linewidth=1, linestyle='--', color='red')
        plt.axhline(y=SBB3, linewidth=1, linestyle='--', color='red')
        plt.axhline(y=SBB4, linewidth=1, linestyle='--', color='red')
        plt.axhline(y=SBB5, linewidth=1, linestyle='--', color='red')
        
        # Easy Breaks Depth from Bag Nr.
        plt.axhline(y=EBB1, linewidth=1, color='green', \
                    linestyle='--', label='Easy Break Depth')
        plt.axhline(y=EBB2, linewidth=0, color='green', \
                    label='{:.1f}m, {:.1f}m, {:.1f}m,'.format(EBB1, EBB2, EBB3))
        plt.axhline(y=EBB2, linewidth=1, linestyle='--', color='green')
        plt.axhline(y=EBB3, linewidth=1, linestyle='--', color='green')
    
        # Abnormal Diameter Depth
        plt.axhline(y=1830, linewidth=5, linestyle='-', color='gray', alpha=0.4, label='Increased Diameter:')
        plt.axhline(y=1845, linewidth=0, linestyle='-', color='gray', alpha=0.4, label='1825m - 1835m')
        plt.axhline(y=1845, linewidth=0, linestyle='-', color='gray', alpha=0.4, label='1842m - 1847m')
        plt.axhline(y=1845, linewidth=4, linestyle='-', color='gray', alpha=0.4)
        plt.axhline(y=EBB3, linewidth=0, linestyle='--', color='green', label='  ') # dummys for legend layout
    
        plt.gca().invert_yaxis()
        ax1.legend(loc='lower center', ncol=2)
    
        plt.ylim(y1, y2)
        plt.yticks(np.arange(y2, y1, step=step))    
        plt.grid()
        plt.title('eigen vectors')
        
        
        ################
        ## 2. Grain Area
        
        ax2 = plt.subplot(gs[1])
        
        # Regular Data
        ax2.scatter(grain_area, depth, s=grain_area * 20, facecolors='none', \
                    edgecolors='black', label='Mean Grain Area (mm2)')
        # Super Bengel
        ax2.scatter(df_SB['mean_grain_size_pixel'] * 20 * 20 * 1e-6, df_SB['depth'],\
                 s=grain_area * 20, facecolors='none', edgecolors='red', \
                 label='SB Grain Area (mm2)', linewidth=1.5)
        # Easy Breaks
        ax2.scatter(df_EB['mean_grain_size_pixel'] * 20 * 20 * 1e-6, df_EB['depth'],\
                 s=grain_area * 20, facecolors='none', edgecolors='green', \
                 label='EB Grain Area (mm2)', linewidth=1.5)
    
        #ax2.plot(grain_area_2, depth_2, '+', color='black', \
        #         label='Mean Grain Area [mm^2]', markersize=3)
        #ax2.plot(grainsize, depth, '+', color='black', label='mean grain size')
    
        
        # Super Banger Depth from Bag Nr.
        plt.axhline(y=SBB1, linewidth=1, linestyle='--', color='red')
        plt.axhline(y=SBB2, linewidth=1, linestyle='--', color='red')
        plt.axhline(y=SBB3, linewidth=1, linestyle='--', color='red')
        plt.axhline(y=SBB4, linewidth=1, linestyle='--', color='red')
        plt.axhline(y=SBB5, linewidth=1, linestyle='--', color='red')
        
        # Easy Breaks Depth from Bag Nr.
        plt.axhline(y=EBB1, linewidth=1, color='green', linestyle='--')
        plt.axhline(y=EBB2, linewidth=1, linestyle='--', color='green')
        plt.axhline(y=EBB3, linewidth=1, linestyle='--', color='green')
        
        # Abnormal Diameter Depth
        plt.axhline(y=1830, linewidth=5, linestyle='-', color='gray', alpha=0.4)
        plt.axhline(y=1845, linewidth=5, linestyle='-', color='gray', alpha=0.4)
    
        plt.gca().invert_yaxis()
        ax2.legend(loc='lower left', ncol=1)       
        plt.xlim(0, 7)
        plt.ylim(y1, y2)
        plt.title('Grain Area [mm^2]')
        plt.yticks(np.arange(y2, y1, step=step))
        plt.grid()
        
        
        ###################
        ## 3. Regelungsgrad
        
        ax3 = plt.subplot(gs[2])
        
        # Regular Data
        ax3.plot(regelungsgrad, depth, 'd', color='black', \
                 label='regelungsgrad', markersize=7, linewidth=2, alpha=0.3)
        # Super Bengel
        ax3.plot(df_SB['regelungsgrad'], df_SB['depth'], 'd', color='red', \
                 label='SB Regelungsgrad', markersize=7, linewidth=2)    
        # Easy Breaks
        ax3.plot(df_EB['regelungsgrad'], df_EB['depth'], 'd', color='green', \
                 label='SB Regelungsgrad', markersize=7, linewidth=2)  
        
        # Super Banger Depth from Bag Nr.
        plt.axhline(y=SBB1, linewidth=1, linestyle='--', color='red')
        plt.axhline(y=SBB2, linewidth=1, linestyle='--', color='red')
        plt.axhline(y=SBB3, linewidth=1, linestyle='--', color='red')
        plt.axhline(y=SBB4, linewidth=1, linestyle='--', color='red')
        plt.axhline(y=SBB5, linewidth=1, linestyle='--', color='red')
        
        # Easy Breaks Depth from Bag Nr.
        plt.axhline(y=EBB1, linewidth=1, color='green', linestyle='--')
        plt.axhline(y=EBB2, linewidth=1, linestyle='--', color='green')
        plt.axhline(y=EBB3, linewidth=1, linestyle='--', color='green')
        
        # Abnormal Diameter Depth
        plt.axhline(y=1830, linewidth=5, linestyle='-', color='gray', alpha=0.4)
        plt.axhline(y=1845, linewidth=5, linestyle='-', color='gray', alpha=0.4)
    
        plt.gca().invert_yaxis()
        ax3.legend(loc='lower left')
        plt.ylim(y1, y2)
        plt.title('regelungsgrad')
        plt.yticks(np.arange(y2, y1, step=step))
        plt.grid()
        
        
        ###################
        ## 4. LineScanner
        
        ax4 = plt.subplot(gs[3])
        ax4.scatter(grayvalue_rm, depth_LS, s=2, edgecolors='none',\
                    c=grayvalue_rm-30, cmap='gray', label='Gray Value')
    
        #ax2.plot(grainsize, depth, '+', color='black', label='mean grain size')
        plt.gray()
        
        # Super Banger Depth from Bag Nr.
        plt.axhline(y=SBB1, linewidth=1, linestyle='--', color='red')
        plt.axhline(y=SBB2, linewidth=1, linestyle='--', color='red')
        plt.axhline(y=SBB3, linewidth=1, linestyle='--', color='red')
        plt.axhline(y=SBB4, linewidth=1, linestyle='--', color='red')
        plt.axhline(y=SBB5, linewidth=1, linestyle='--', color='red')
        
        # Easy Breaks Depth from Bag Nr.
        plt.axhline(y=EBB1, linewidth=1, color='green', linestyle='--')
        plt.axhline(y=EBB2, linewidth=1, linestyle='--', color='green')
        plt.axhline(y=EBB3, linewidth=1, linestyle='--', color='green')
        
        # Abnormal Diameter Depth
        plt.axhline(y=1830, linewidth=5, linestyle='-', color='gray', alpha=0.4)
        plt.axhline(y=1845, linewidth=5, linestyle='-', color='gray', alpha=0.4)
    
        plt.gca().invert_yaxis()
        ax4.legend(loc='lower left', fontsize='12')
        plt.ylim(y1, y2)
        plt.title('Line Scanner')
        plt.yticks(np.arange(y2, y1, step=step))
        plt.grid()
        
        
        #################
        ## 5. Temperature
        
        ax5 = plt.subplot(gs[4])
        ax5.plot(LogMay_Temp, LogMay_depth, color='blue', \
                 label='Temp. 2019-05', markersize=8)
        ax5.plot(LogJune_Temp, LogJune_depth, color='red', \
                 label='Temp. 2019-06', markersize=8)
        ax5.plot(LogJuly_Temp, LogJuly_depth, color='green', \
                 label='Temp. 2019-07', markersize=8)
        
        
        plt.axhline(y=SBB1, linewidth=1, linestyle='--', color='red')
        plt.axhline(y=SBB2, linewidth=1, linestyle='--', color='red')
        plt.axhline(y=SBB3, linewidth=1, linestyle='--', color='red')
        plt.axhline(y=SBB4, linewidth=1, linestyle='--', color='red')
        plt.axhline(y=SBB5, linewidth=1, linestyle='--', color='red')
        
        # Easy Breaks Depth from Bag Nr.
        plt.axhline(y=EBB1, linewidth=1, color='green', linestyle='--')
        plt.axhline(y=EBB2, linewidth=1, linestyle='--', color='green')
        plt.axhline(y=EBB3, linewidth=1, linestyle='--', color='green')
        
        # Abnormal Diameter Depth
        plt.axhline(y=1830, linewidth=5, linestyle='-', color='gray', alpha=0.4)
        plt.axhline(y=1845, linewidth=5, linestyle='-', color='gray', alpha=0.4)
        
        
        plt.gca().invert_yaxis()
        ax5.legend(loc='lower right')
        plt.xlim(-30, -21)
        plt.ylim(y1, y2)
        plt.title('Temp. Logging July 2019')
        plt.yticks(np.arange(y2, y1, step=step))
        plt.grid()
    
    
        ################
        ## 6. Break Load
        
        ax6 = plt.subplot(gs[5])
        ax6.scatter(breakload, drill_depth, s=breakload/10,  edgecolors='none',\
                    marker='+', c=breakload, cmap='jet', \
                    label='break load', linewidth=3)
        
        plt.axhline(y=np.array(SB_depth)[0], linewidth=0.5)
        plt.axhline(y=np.array(SB_depth)[1], linewidth=0.5)
        plt.axhline(y=np.array(SB_depth)[2], linewidth=0.5)
        plt.axhline(y=np.array(SB_depth)[3], linewidth=0.5)
        plt.axhline(y=np.array(SB_depth)[4], linewidth=0.5)
        
        # Super Banger Depth from Bag Nr.
        plt.axhline(y=SBB1, linewidth=1, linestyle='--', color='red')
        plt.axhline(y=SBB2, linewidth=1, linestyle='--', color='red')
        plt.axhline(y=SBB3, linewidth=1, linestyle='--', color='red')
        plt.axhline(y=SBB4, linewidth=1, linestyle='--', color='red')
        plt.axhline(y=SBB5, linewidth=1, linestyle='--', color='red')
        
        # Easy Breaks Depth from Bag Nr.
        plt.axhline(y=EBB1, linewidth=1, color='green', linestyle='--')
        plt.axhline(y=EBB2, linewidth=1, linestyle='--', color='green')
        plt.axhline(y=EBB3, linewidth=1, linestyle='--', color='green')
        
        # Abnormal Diameter Depth
        plt.axhline(y=1830, linewidth=5, linestyle='-', color='gray', alpha=0.4)
        plt.axhline(y=1845, linewidth=5, linestyle='-', color='gray', alpha=0.4)
        
        plt.gca().invert_yaxis()
        ax6.legend(loc='lower left')
        plt.xlim(1000, 2500)
        plt.ylim(y1, y2)
        plt.title('break load')
        plt.yticks(np.arange(y2, y1, step=step))
        plt.grid()
        
        #############
        # Save Figure
        #############
        
        plt.savefig('figures/PP_EGRIP_Several_deeper.png', dpi=300)
        
        
    #%%
    
    ###########################################################################
    ###########################################################################
    ###########################################################################
    ###########################################################################
    ###########################################################################
        
        
    ######################################
    #       Plot several parameters
    # 2019 depth scale ca. (1700 - 2150m)
    ######################################
        
        
    if 1:
        
        fig = plt.subplots(figsize=(25,12))
        plt.suptitle('EGRIP - CFO and Drill Parameters (2000 - 2150 m depth)')
        
        gs = gridspec.GridSpec(1, 6,
                               width_ratios=[2, 1, 1, 1, 1, 1],
                               height_ratios=[1]
                               )
        
        y1      = 2170
        y2      = 2000
        step    = 5
        
      
        #################
        ## 1. Eigenvalues
        ax1 = plt.subplot(gs[0])
    
        ax1.plot(e1, depth, '^', color='blue', label='e1', markersize=8, alpha=0.5)
        ax1.plot(e2, depth, '<', color='purple', label='e2', markersize=8, alpha=0.5)
        ax1.plot(e3, depth, '>', color='orange', label='e3', markersize=8, alpha=0.5)
        
        
        # Second Data File
        #ax1.plot(e1_2, depth_2, '+', color='black', label='e1', markersize=3)
        #ax1.plot(e2_2, depth_2, '+', color='black', label='e2', markersize=3)
        #ax1.plot(e3_2, depth_2, '+', color='black', label='e3', markersize=3)
        
        
        # Plotting SUPER BANGER PARAMS
        ax1.plot(df_SB['eigenvalue_e1'], df_SB['depth'], '^', color='red', \
                 label='SB e1', markersize=8)
        ax1.plot(df_SB['eigenvalue_e2'], df_SB['depth'], '<', color='red', \
                 label='SB e2', markersize=8)
        ax1.plot(df_SB['eigenvalue_e3'], df_SB['depth'], '>', color='red', \
                 label='SB e3', markersize=8)
        
        
        # Plotting Easy Break PARAMS
        ax1.plot(df_EB['eigenvalue_e1'], df_EB['depth'], '^', color='green', \
                 label='EB e1', markersize=8)
        ax1.plot(df_EB['eigenvalue_e2'], df_EB['depth'], '<', color='green', \
                 label='EB e2', markersize=8)
        ax1.plot(df_EB['eigenvalue_e3'], df_EB['depth'], '>', color='green', \
                 label='EB e3', markersize=8)
        
        
        # Super Banger Depth from Bag Nr.
        plt.axhline(y=SBB1, linewidth=1, linestyle='--', color='red', \
                    label='Super Banger Depth:')
        plt.axhline(y=SBB2, linewidth=0.0, linestyle='--', color='red', \
                    label='{:.1f}m, {:.1f}m, {:.1f}m,'.format(SBB1, SBB2, SBB3))
        plt.axhline(y=SBB2, linewidth=0.0, linestyle='--', color='red', \
                    label='{:.1f}m, {:.1f}m'.format(SBB4, SBB5))
        plt.axhline(y=SBB2, linewidth=1, linestyle='--', color='red')
        plt.axhline(y=SBB3, linewidth=1, linestyle='--', color='red')
        plt.axhline(y=SBB4, linewidth=1, linestyle='--', color='red')
        plt.axhline(y=SBB5, linewidth=1, linestyle='--', color='red')
        
        # Easy Breaks Depth from Bag Nr.
        plt.axhline(y=EBB1, linewidth=1, color='green', \
                    linestyle='--', label='Easy Break Depth')
        plt.axhline(y=EBB2, linewidth=0, color='green', \
                    label='{:.1f}m, {:.1f}m, {:.1f}m,'.format(EBB1, EBB2, EBB3))
        plt.axhline(y=EBB2, linewidth=1, linestyle='--', color='green')
        plt.axhline(y=EBB3, linewidth=1, linestyle='--', color='green')
        plt.axhline(y=EBB2, linewidth=0, linestyle='--', color='green', label='  ') # dummys for legend layout
        plt.axhline(y=EBB3, linewidth=0, linestyle='--', color='green', label='  ') # dummys for legend layout
        plt.axhline(y=EBB2, linewidth=0, linestyle='--', color='green', label='  ') # dummys for legend layout
        plt.axhline(y=EBB3, linewidth=0, linestyle='--', color='green', label='  ') # dummys for legend layout
    
        plt.gca().invert_yaxis()
        ax1.legend(loc='lower center', ncol=2)
    
        plt.ylim(y1, y2)
        plt.yticks(np.arange(y2, y1, step=step))    
        plt.grid()
        plt.title('eigen vectors')
        
        
        ################
        ## 2. Grain Area
        
        ax2 = plt.subplot(gs[1])
        
        # Regular Data
        ax2.scatter(grain_area, depth, s=grain_area * 20, facecolors='none', \
                    edgecolors='black', label='Mean Grain Area (mm2)')
        # Super Bengel
        ax2.scatter(df_SB['mean_grain_size_pixel'] * 20 * 20 * 1e-6, df_SB['depth'],\
                 s=grain_area * 20, facecolors='none', edgecolors='red', \
                 label='SB Grain Area (mm2)', linewidth=1.5)
        # Easy Breaks
        ax2.scatter(df_EB['mean_grain_size_pixel'] * 20 * 20 * 1e-6, df_EB['depth'],\
                 s=grain_area * 20, facecolors='none', edgecolors='green', \
                 label='EB Grain Area (mm2)', linewidth=1.5)
    
        #ax2.plot(grain_area_2, depth_2, '+', color='black', \
        #         label='Mean Grain Area [mm^2]', markersize=3)
        #ax2.plot(grainsize, depth, '+', color='black', label='mean grain size')
    
        
        # Super Banger Depth from Bag Nr.
        plt.axhline(y=SBB1, linewidth=1, linestyle='--', color='red')
        plt.axhline(y=SBB2, linewidth=1, linestyle='--', color='red')
        plt.axhline(y=SBB3, linewidth=1, linestyle='--', color='red')
        plt.axhline(y=SBB4, linewidth=1, linestyle='--', color='red')
        plt.axhline(y=SBB5, linewidth=1, linestyle='--', color='red')
        
        # Easy Breaks Depth from Bag Nr.
        plt.axhline(y=EBB1, linewidth=1, color='green', linestyle='--')
        plt.axhline(y=EBB2, linewidth=1, linestyle='--', color='green')
        plt.axhline(y=EBB3, linewidth=1, linestyle='--', color='green')
    
        plt.gca().invert_yaxis()
        ax2.legend(loc='lower left', ncol=1)       
        plt.xlim(0, 7)
        plt.ylim(y1, y2)
        plt.title('Grain Area [mm^2]')
        plt.yticks(np.arange(y2, y1, step=step))
        plt.grid()
        
        
        ###################
        ## 3. Regelungsgrad
        
        ax3 = plt.subplot(gs[2])
        
        # Regular Data
        ax3.plot(regelungsgrad, depth, 'd', color='black', \
                 label='regelungsgrad', markersize=8, linewidth=2, alpha=0.4)
        # Super Bengel
        ax3.plot(df_SB['regelungsgrad'], df_SB['depth'], 'd', color='red', \
                 label='SB Regelungsgrad', markersize=8, linewidth=2)    
        # Easy Breaks
        ax3.plot(df_EB['regelungsgrad'], df_EB['depth'], 'd', color='green', \
                 label='SB Regelungsgrad', markersize=8, linewidth=2)  
        
        # Super Banger Depth from Bag Nr.
        plt.axhline(y=SBB1, linewidth=1, linestyle='--', color='red')
        plt.axhline(y=SBB2, linewidth=1, linestyle='--', color='red')
        plt.axhline(y=SBB3, linewidth=1, linestyle='--', color='red')
        plt.axhline(y=SBB4, linewidth=1, linestyle='--', color='red')
        plt.axhline(y=SBB5, linewidth=1, linestyle='--', color='red')
        
        # Easy Breaks Depth from Bag Nr.
        plt.axhline(y=EBB1, linewidth=1, color='green', linestyle='--')
        plt.axhline(y=EBB2, linewidth=1, linestyle='--', color='green')
        plt.axhline(y=EBB3, linewidth=1, linestyle='--', color='green')
    
        plt.gca().invert_yaxis()
        ax3.legend(loc='lower left')
        plt.ylim(y1, y2)
        plt.title('regelungsgrad')
        plt.yticks(np.arange(y2, y1, step=step))
        plt.grid()
        
        
        ###################
        ## 4. LineScanner
        
        ax4 = plt.subplot(gs[3])
        ax4.scatter(grayvalue_rm, depth_LS, s=2, edgecolors='none',\
                    c=grayvalue_rm-30, cmap='gray', label='Gray Value')
    
        #ax2.plot(grainsize, depth, '+', color='black', label='mean grain size')
        plt.gray()
        
        # Super Banger Depth from Bag Nr.
        plt.axhline(y=SBB1, linewidth=1, linestyle='--', color='red')
        plt.axhline(y=SBB2, linewidth=1, linestyle='--', color='red')
        plt.axhline(y=SBB3, linewidth=1, linestyle='--', color='red')
        plt.axhline(y=SBB4, linewidth=1, linestyle='--', color='red')
        plt.axhline(y=SBB5, linewidth=1, linestyle='--', color='red')
        
        # Easy Breaks Depth from Bag Nr.
        plt.axhline(y=EBB1, linewidth=1, color='green', linestyle='--')
        plt.axhline(y=EBB2, linewidth=1, linestyle='--', color='green')
        plt.axhline(y=EBB3, linewidth=1, linestyle='--', color='green')
    
        plt.gca().invert_yaxis()
        ax4.legend(loc='lower left', fontsize='12')
        plt.xlim(0, 200)
        plt.ylim(y1, y2)
        plt.title('Line Scanner')
        plt.yticks(np.arange(y2, y1, step=step))
        plt.grid()
        
        
        #################
        ## 5. Temperature
        
        ax5 = plt.subplot(gs[4])
        ax5.plot(LogMay_Temp, LogMay_depth, color='blue', \
                 label='Temp. 2019-05', markersize=8)
        ax5.plot(LogJune_Temp, LogJune_depth, color='red', \
                 label='Temp. 2019-06', markersize=8)
        ax5.plot(LogJuly_Temp, LogJuly_depth, color='green', \
                 label='Temp. 2019-07', markersize=8)
        
        
        plt.axhline(y=SBB1, linewidth=1, linestyle='--', color='red')
        plt.axhline(y=SBB2, linewidth=1, linestyle='--', color='red')
        plt.axhline(y=SBB3, linewidth=1, linestyle='--', color='red')
        plt.axhline(y=SBB4, linewidth=1, linestyle='--', color='red')
        plt.axhline(y=SBB5, linewidth=1, linestyle='--', color='red')
        
        # Easy Breaks Depth from Bag Nr.
        plt.axhline(y=EBB1, linewidth=1, color='green', linestyle='--')
        plt.axhline(y=EBB2, linewidth=1, linestyle='--', color='green')
        plt.axhline(y=EBB3, linewidth=1, linestyle='--', color='green')
        
        
        plt.gca().invert_yaxis()
        ax5.legend(loc='lower right')
        plt.xlim(-26, -21)
        plt.ylim(y1, y2)
        plt.title('Temp. Logging July 2019')
        plt.yticks(np.arange(y2, y1, step=step))
        plt.grid()
    
    
        ################
        ## 6. Break Load
        
        ax6 = plt.subplot(gs[5])
        ax6.scatter(breakload, drill_depth, s=breakload/10,  edgecolors='none',\
                    marker='+', c=breakload, cmap='jet', label='break load', linewidth=4)
        
        plt.axhline(y=np.array(SB_depth)[0], linewidth=0.5)
        plt.axhline(y=np.array(SB_depth)[1], linewidth=0.5)
        plt.axhline(y=np.array(SB_depth)[2], linewidth=0.5)
        plt.axhline(y=np.array(SB_depth)[3], linewidth=0.5)
        plt.axhline(y=np.array(SB_depth)[4], linewidth=0.5)
        
        # Super Banger Depth from Bag Nr.
        plt.axhline(y=SBB1, linewidth=1, linestyle='--', color='red')
        plt.axhline(y=SBB2, linewidth=1, linestyle='--', color='red')
        plt.axhline(y=SBB3, linewidth=1, linestyle='--', color='red')
        plt.axhline(y=SBB4, linewidth=1, linestyle='--', color='red')
        plt.axhline(y=SBB5, linewidth=1, linestyle='--', color='red')
        
        # Easy Breaks Depth from Bag Nr.
        plt.axhline(y=EBB1, linewidth=1, color='green', linestyle='--')
        plt.axhline(y=EBB2, linewidth=1, linestyle='--', color='green')
        plt.axhline(y=EBB3, linewidth=1, linestyle='--', color='green')
        
        plt.gca().invert_yaxis()
        ax6.legend(loc='lower left')
        plt.xlim(1000, 2500)
        plt.ylim(y1, y2)
        plt.title('break load')
        plt.yticks(np.arange(y2, y1, step=step))
        plt.grid()
        
        #############
        # Save Figure
        #############
        
        plt.savefig('figures/PP_EGRIP_Several_deeper_closer.png', dpi=300)
