#!/usr/bin/env python
# coding: utf-8

# In[1]:


import os
import pandas as pd
import janitor
import geopandas as gpd
import sidetable
from glob import glob
from utilities import read_json


# ## Consolidate

# In[2]:


df = pd.DataFrame()

savefolder = "../output/gm-cache-payloads/places/"

for filepath in glob(os.path.join(savefolder, "*.json")):
    payload = []
    filename = filepath.split("/")[-1]
    place_id = filename.replace(".json", "")

    payload = read_json(filepath)
    payload = payload["result"]
    if len(payload) == 0:
        continue
    _df = (
        pd.DataFrame([payload])
        .assign(place_id=place_id)
    )
    df = (
        
        pd.concat([df, _df], ignore_index=True)
    )
    
gdf = (
    gpd.read_parquet("transportfacilities-1000m-residence-rgeocoded.parquet")
    .remove_columns("name")
    # ================================================================
    # Merge with gm payloads
    .merge(
        (df
        ),
        how="left",
        on="place_id",
        validate="m:1",
    )
)    
gdf


# In[3]:


gdf.stb.freq(["business_status"])


# In[8]:


len(df.query("photos==photos"))


# ## Place photos

# ### Get list of placeid to photo reference

# In[63]:


cache = []
df = (gdf.drop_duplicates("place_id").query("photos==photos")).reset_index(drop=True)

_df = (gdf.drop_duplicates("place_id").query("photos==photos")).reset_index(drop=True)
for ix, row in _df.iterrows():
    lu_index = row["lu_index"]
    name = row["name"]
    address = row["formatted_address"]
    place_id = row["place_id"]
    photos = row["photos"]
    for item in photos:
        photo_reference = item["photo_reference"]
        width = item["width"]
        height = item["height"]
        cache.append([place_id, lu_index, name, address, photo_reference, width, height])
        
df_photos = (
    gpd.read_parquet("transportfacilities-1000m-residence.parquet")
    .rename_column("index", "lu_index")
    .remove_columns(["name", "centroid"])
    .merge((
        pd.DataFrame(cache, columns=["place_id", "lu_index", "name", "address", "photo_reference", "width", "height"])
    ), how="right", on="lu_index", validate="1:m"
    )
)
#     )
#     pd.DataFrame(cache, columns=["place_id", "lu_index", "name", "address", "photo_reference", "width", "height"])
#     .merge((
#         gpd.read_parquet("transportfacilities-1000m-residence.parquet")
#         .rename_column("index", "lu_index")
#         .remove_columns(["name", "centroid"])
#     ), 
#            how="left", on="lu_index", validate="m:1")
# )
df_photos.to_parquet("place-photos.parquet", index=False)
df_photos


# ### Query photos

# In[64]:


savefolder = "../output/gm-cache-payloads/place-pictures/"
for _, row in tqdm(df_photos.iterrows(), total=len(df_photos)):
    photo_reference = row["photo_reference"]
    savefile = photo_reference + ".png"
    savepath = os.path.join(savefolder, savefile)
    if os.path.exists(savepath):
#         print(f"{place_id} done")
        continue    
    
    width = row["width"]
    
    photo_payload = gmaps.places_photo(photo_reference, max_width=width)

    f = open(savepath, 'wb')
    for chunk in photo_payload:
        if chunk:
            f.write(chunk)
    f.close()


# In[ ]:




