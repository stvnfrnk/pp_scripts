
import pandas as pd
import numpy as np
import geopy.distance

from matplotlib import pyplot as plt
from matplotlib import gridspec
from matplotlib.ticker import FormatStrFormatter



path = '/Users/sfranke/Documents/CSARP_combined_3_sub_apertures/20180510_01/'
data = 'Data_20180510_01_002_elevation.csv'
meta =  'Data_20180510_01_002_meta_v2.csv'


df   = pd.read_csv(path + data)
meta = pd.read_csv(path + meta)

cmp = np.array(range(1, len(df.columns) +1))


elevation = np.array(df['ElevationWGS84'])
del df['ElevationWGS84']

# set number of ticks on x axis
number_of_xticks = 50
step = np.round(df.shape[1] / number_of_xticks).astype(int)

# Here we define our x-axis distance
# (1) We take our lat/lon info to calculate distance from point to point,
# (2) then we sum sum everything up (cumsum) to get our distance array
# (3) Then we set our spacing for the y axis in meters

spacing = np.array(0)

# (1)
for i in range(1, len(meta)-1):
	coord_1 = (meta['Lat'][i], meta['Lon'][i])
	coord_2 = (meta['Lat'][i + 1], meta['Lon'][i + 1])
	f = geopy.distance.geodesic(coord_1, coord_2).kilometers
	spacing = np.append(spacing, f)

# (2)	    
distance = np.around(np.cumsum(spacing[0:-1]), 0)

# (3) 
y_spacing = 50
offset = np.min([y for y in elevation[0::y_spacing] if y > 0])

#%%

surf = meta['Arctic_DEM']
velo = meta['Velocity_Gradient']
EGRIP = 799

x_step = 133


fig = plt.subplots(figsize=(15,15))

gs = gridspec.GridSpec(3, 1,
                       width_ratios=[1],
                       height_ratios=[1, 6, 1]
                       )
## Surface
ax1 = plt.subplot(gs[0])
ax1.plot(cmp, surf, linewidth=2, color='blue')
plt.axvline(x=velo.idxmax(), color='black', linestyle='dashed', linewidth=0.5)
plt.title('ArcticDEM Surface Elevation')


plt.xlim(0, len(surf))
plt.xticks(np.array(range(1, len(distance), x_step)), distance[0::x_step])
plt.ylabel(' Surface Elevation a.s.l. [m]')


## Radargram
ax2 = plt.subplot(gs[1])
ax2.imshow(df, cmap='bone_r', aspect="auto")

#ax2.plot(cmp, als, linewidth=5, color='white')
ax2.set_ylim(3000, 0)
plt.yticks(np.array(df.index)[offset::250], elevation[offset::250])
plt.xticks(np.array(range(1, len(distance), x_step)), distance[0::x_step])#['250', '200', '150', '100', '50', '0'])
plt.ylim(3000, 0)
#plt.xlim(0, len(als))
plt.axvline(x=velo.idxmax(), color='black', linestyle='dashed', linewidth=0.5, label='shear margin')
plt.axvline(x=EGRIP, color='white', label='EGRIP Camp')
plt.legend()
plt.ylabel('Elevation a.s.l. [m]')
plt.title('AWI UWB Profile 180-210 MHz - 2018-05-10')


## Velocity
ax3 = plt.subplot(gs[2])
ax3.plot(cmp, velo, linewidth=2, color='black')

plt.xlim(0, len(velo))
plt.xticks(np.array(range(1, len(distance), x_step)), distance[0::x_step])
plt.xlabel('Distance [km]')
plt.ylabel('Velocity Gradient')
plt.title('Surface Velocity Gradient')

plt.savefig(path + data + '_extra.png', dpi=300, bbox_inches='tight')
plt.show()