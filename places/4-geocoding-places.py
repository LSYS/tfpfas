#!/usr/bin/env python
# coding: utf-8

# In[33]:


import os
import pandas as pd
import janitor
import geopandas as gpd
import googlemaps
from tqdm.notebook import tqdm
from utilities import read_yaml, save_json
import time

key = read_yaml("secrets.yml")["gm_api"]

# https://googlemaps.github.io/google-maps-services-python/docs/index.html#googlemaps.Client
gmaps = googlemaps.Client(key=key, queries_per_second=10)
gmaps


# In[30]:


gdf = (
    gpd.read_parquet("transportfacilities-1000m-residence-rgeocoded.parquet")
    .drop_duplicates("place_id")
)
gdf.info()
gdf.head()


# ![Location types](../frozen/gm-places-fields-warning.png)
# 
# Source: https://developers.google.com/maps/documentation/places/web-service/details

# In[37]:


savefolder = "../output/gm-cache-payloads/places/"

for _, row in tqdm(gdf.iterrows(), total=len(gdf)):
    place_id = row["place_id"]
    savefile = str(place_id) + ".json"
    savepath = os.path.join(savefolder, savefile)
    if os.path.exists(savepath):
#         print(f"{place_id} done")
        continue    
        
    payload = gmaps.place(place_id, fields=["business_status", "name", "photo"])
    save_json(payload, savepath)   
    
    time.sleep(.05)


# In[38]:


get_ipython().system('ls -lh ../output/gm-cache-payloads/places/')


# In[ ]:





# In[ ]:




