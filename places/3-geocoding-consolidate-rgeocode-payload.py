#!/usr/bin/env python
# coding: utf-8

# In[2]:


import os
import pandas as pd
import janitor
import sidetable
import numpy as np
from utilities import read_json, load_landuse2008_data
from glob import glob

savefolder = "../output/gm-cache-payloads/rgeocode/"


# In[23]:


gdf_lu2008 = (
    load_landuse2008_data().query("name=='TRANSPORT FACILITIES'")
    # Original CRS is in EPSG:4326 which gives distance in degrees
    # convert to 3857 to get meters
    .to_crs("EPSG:3857")
)
gdf_lu2008.head(3)


# In[10]:


df = pd.DataFrame()
for filepath in glob(os.path.join(savefolder, "*.json")):
    payload = []
    filename = filepath.split("/")[-1]
    lu_index = filename.replace(".json", "")

    payload = read_json(filepath)
    if len(payload) == 0:
        continue

    _df = (
        pd.DataFrame(payload)
        .assign(lu_index=lu_index)
        .assign(rank=lambda df_: 1 + df_.index)
    )
    df = pd.concat([df, _df], ignore_index=True)
print(f"LU recovered: {df['lu_index'].nunique()}")

gdf = (
    gdf_lu2008.reset_index()
    .rename_column("index", "lu_index")
    .astype({"lu_index": int})
    # ================================================================
    # Compute area
    .to_crs("EPSG:3857")
    .assign(area=lambda df_: df_["geometry"].area)
    # ================================================================
    # Merge with gm payloads
    .merge(
        (
            df.rename_column("geometry", "geoloc_metadata")
            .astype({"lu_index": int})
            # Get ntypes (number of types per row)
            .assign(ntypes=lambda df_: [len(l) for l in df_["types"]])
            .assign(
                poi=lambda df_: ["point_of_interest" in types for types in df_["types"]]
            )
        ),
        how="right",
        on="lu_index",
        validate="1:m",
    )
)
gdf


# In[24]:


gdf.to_parquet("transportfacilities-1000m-residence-rgeocoded.parquet", index=False)


# In[25]:


gdf["area"].describe()


# In[26]:


gdf["area"].plot(kind="hist")


# In[28]:


gdf.stb.freq(["poi"])


# In[30]:


counter_allmatches = {}
for ix, row in gdf.iterrows():
    types = row["types"]
    for item in types:
        if item in counter_allmatches:
            counter_allmatches[item] += 1
        else:
            counter_allmatches[item] = 1
counter_allmatches = pd.DataFrame.from_dict(
    counter_allmatches, orient="index", columns=["count"]
).sort_values("count", ascending=False)
counter_allmatches.head()


# In[31]:


counter_bestmatch = {}
for ix, row in gdf.query("rank==1").iterrows():
    types = row["types"]
    for item in types:
        if item in counter_bestmatch:
            counter_bestmatch[item] += 1
        else:
            counter_bestmatch[item] = 1
counter_bestmatch = pd.DataFrame.from_dict(
    counter_bestmatch, orient="index", columns=["count"]
).sort_values("count", ascending=False)
counter_bestmatch


# In[33]:


counter_bestmatch = {}
for ix, row in gdf.query("rank==1").query("area <= 5000").iterrows():
    types = row["types"]
    for item in types:
        if item in counter_bestmatch:
            counter_bestmatch[item] += 1
        else:
            counter_bestmatch[item] = 1
counter_bestmatch = pd.DataFrame.from_dict(
    counter_bestmatch, orient="index", columns=["count"]
).sort_values("count", ascending=False)
counter_bestmatch


# In[43]:


print(counter_bestmatch
      .reset_index()
      .assign(index=lambda df_: [s.replace("_", " ").title() for s in df_["index"]])
      .assign(ix=lambda df_: 1+df_.index)
      .reorder_columns(["ix"])
      .to_latex(index=False)
     )


# In[ ]:




