#!/usr/bin/env python
# coding: utf-8

# In[1]:


import os
import pandas as pd
import janitor
import geopandas as gpd
import googlemaps
from tqdm.notebook import tqdm
from utilities import read_yaml

key = read_yaml("secrets.yml")["gm_api"]

# https://googlemaps.github.io/google-maps-services-python/docs/index.html#googlemaps.Client
gmaps = googlemaps.Client(key=key, queries_per_second=10)
gmaps


# **Location types:**
# 
# ![Location types](../frozen/gm-location-type.png)
# 
# (Source: https://developers.google.com/maps/documentation/javascript/geocoding)

# **Result types:**
# ![Result types](../frozen/gm-result-type.png)
# (Source: https://developers.google.com/maps/documentation/javascript/geocoding)

# In[5]:


df = gpd.read_parquet("transportfacilities-1000m-residence.parquet")
print(df["index"].nunique())
df.head(3)


# In[3]:


savefolder = "../output/gm-cache-payloads/rgeocode/"

for _, row in tqdm(df.iterrows(), total=len(df)):
    lu_index = row["index"]
    savefile = str(lu_index) + ".json"
    savepath = os.path.join(savefolder, savefile)
    if os.path.exists(savepath):
#         print(f"{lu_index} done")
        continue
    
    latlng = (row["y"], row["x"])
    reverse_geocode_result = gmaps.reverse_geocode(latlng, )
    save_json(reverse_geocode_result, savepath)


# In[4]:


get_ipython().system('ls -lh ../output/gm-cache-payloads/rgeocode/')


# In[ ]:




