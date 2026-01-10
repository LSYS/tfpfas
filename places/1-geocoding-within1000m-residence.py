#!/usr/bin/env python
# coding: utf-8

# In[9]:


import pandas as pd
import janitor
import geopandas as gpd

from IPython.display import display
from tqdm.notebook import tqdm

import matplotlib.pyplot as plt

import fiona
fiona.drvsupport.supported_drivers["KML"] = "rw"

import warnings
warnings.filterwarnings('ignore')

from utilities import load_landuse2008_data


# In[3]:


gdf_lu2008 = (
    load_landuse2008_data()
    .query("name=='TRANSPORT FACILITIES'")
    # Original CRS is in EPSG:4326 which gives distance in degrees
    # convert to 3857 to get meters
    .to_crs("EPSG:3857")        
)
gdf_lu2008


# In[5]:


gdf_gusto = (
    gpd.read_parquet("../input/postcodes.parquet")
    .astype({"postal": int})
    # ======================================================
    .merge((
        pd.read_parquet("../input/edc-gusto.parquet")
        .remove_columns(["sid", "year", "hex9_hash", "hex8_hash", "hex7_hash"])
        .dropna(subset=["pfbs"], ignore_index=True)
    ), how="right", on="postal", validate="1:m")
    .dropna(subset=["geometry"])
    # ======================================================
    # Original CRS is in EPSG:4326 which gives distance in degrees
    # convert to 3857 to get meters
    .to_crs("EPSG:3857")        
)
display(gdf_gusto.head(3))
print(gdf_gusto.info())
gdf_gusto.crs


# In[6]:


df_output = pd.DataFrame()
for ix, row in tqdm(gdf_gusto.iterrows()):
    pc_point = row["geometry"]
    _df_output = (
        gdf_lu2008.distance(pc_point, align=False)
        .reset_index()
        .rename_column(0, "meters")
        .query("meters <= 1000")
    )
    df_output = pd.concat([df_output, _df_output], ignore_index=True)

gdf_output = (
    gdf_lu2008
    .to_crs("EPSG:4326")      
    .reset_index()
    .merge(df_output.drop_duplicates("index"), how="right", on="index", validate="1:1")    
    .assign(centroid=lambda df: df["geometry"].centroid)
    .assign(x=lambda df: df["centroid"].x)
    .assign(y=lambda df: df["centroid"].y)
)
    
gdf_output


# In[10]:


_, ax = plt.subplots(figsize=(16,12))
gdf_output.plot(ax=ax)


# In[11]:


gdf_output.to_parquet("transportfacilities-1000m-residence.parquet", index=False)

