#!/usr/bin/env python
# coding: utf-8

# In[1]:


import os
import pandas as pd
import geopandas as gpd
import janitor
from PIL import Image
import matplotlib.pyplot as plt

import warnings
warnings.filterwarnings('ignore')

savefolder = "../output/gm-cache-payloads/place-pictures/"

def show_image(
    name: str,
    ix: int = 0,
    savefolder: str="../output/gm-cache-payloads/place-pictures/",
    height: int = 9,
    width: int = 12,
    all: bool = False
):
    # ==============================================================
    # Get and report characteristics of place
    place_id = (
        gdf.query(f"name=='{name}'")
        .reset_index(drop=True)
        .loc[0, "place_id"]
    )  
    meters = gdf_types.query(f"place_id=='{place_id}'")["meters"].values[0].round(0)
    meters = int(meters)
    
    area = gdf_types.query(f"place_id=='{place_id}'")["area"].values[0].round(0)
    area = int(area)
    
    types = gdf_types.query(f"place_id=='{place_id}'")["types"].values[0]
    
    adress = gdf_types.query(f"place_id=='{place_id}'")["formatted_address"].values[0]
    
    print(f"Area: {area:,}m\u00B2")
    print(f"Dist to nearest (GUSTO) residence: {meters}m")
    print(f"Classified types: {types}")
    print(f"Adress: {adress}")

    # ==============================================================
    def _show_image(photo_reference: str, height, width, savefolder):
        file = photo_reference + ".png"
        filepath = os.path.join(savefolder, file)
        image = Image.open(filepath)
        # Display the image
        plt.figure(figsize=(width, height))
        plt.imshow(image)
        plt.axis('off')  # Turn off axis ticks and labels
        plt.show()       
        
    # ==============================================================
    # Retrieve and print images
    if all:
        photo_references = (
            gdf.query(f"name=='{name}'")
            .photo_reference
            .tolist()
        )
        for photo_reference in photo_references:
            print(f"Photo reference: {photo_reference}")
            _show_image(photo_reference, height, width, savefolder)
    else:
        try:
            photo_reference = (
                gdf.query(f"name=='{name}'")
                .reset_index(drop=True)
                .loc[ix, "photo_reference"]
            )
        except:
            print("Not found, showing first image:")
            photo_reference = (
                gdf.query(f"name=='{name}'")
                .reset_index(drop=True)
                .loc[0, "photo_reference"]
            )  
        print(f"Photo reference: {photo_reference}")
        _show_image(photo_reference, height, width, savefolder)
    return None


# In[2]:


gdf = (
    gpd.read_parquet("place-photos.parquet")
)
gdf.head(3)


# In[5]:


gdf[gdf["name"].str.contains("depot", case=False)]


# In[3]:


gdf_types = (
    gpd.read_parquet("transportfacilities-1000m-residence-rgeocoded.parquet")
    .merge((
        gpd.read_parquet("transportfacilities-1000m-residence.parquet")
        .select_columns(["index", "meters"])
        .rename_column("index", "lu_index")
    ), how="left", on="lu_index", validate="m:1"
    )
    .assign(
        gas_station=lambda df_: ["point_of_interest" in types for types in df_["types"]],
        parking=lambda df_: ["parking" in types for types in df_["types"]],
        car_wash=lambda df_: ["car_wash" in types for types in df_["types"]],
    )
)
gdf_types.head(3)


# In[5]:


show_image("Caltex", all=True)


# In[6]:


# gdf["name"].unique()


# In[7]:


show_image("SBS Transit Ltd", all=True)


# In[8]:


show_image("Yio Chu Kang Int", all=True)


# In[9]:


show_image("Bt Merah Int", all=True)


# In[10]:


show_image("Yishun Int", all=True)


# In[11]:


show_image("Woodlands Bus Depot", all=True)


# In[12]:


show_image("Bef Jurong East Stn", ix=2)


# In[13]:


show_image("Bangkit Stn")


# In[14]:


show_image("Cencon Bldg", ix=4)


# In[15]:


show_image("SPC Yio Chu Kang", ix=1)


# In[16]:


show_image("Shell")


# In[17]:


show_image("LKA Auto Parts Trading Pte Ltd", ix=1)


# In[18]:


show_image("SPC Bukit Timah", ix=1)


# In[19]:


show_image("Opp Waterway Pr Sch", all=True)


# In[20]:


show_image("Kah Motor Sdn Bhd - Upper Thomson", all=True)


# ## Others

# In[21]:


def show_image2(
    photo_reference: str,
    ix: int = 0,
    savefolder: str="../output/gm-cache-payloads/place-pictures/",
    height: int = 9,
    width: int = 12,
    all: bool = False
):
    
    
    # ==============================================================
    # Get and report characteristics of place
    place_id = (
        gdf.query(f"photo_reference=='{photo_reference}'")
        .reset_index(drop=True)
        .loc[0, "place_id"]
    )  
    name = (
        gdf.query(f"photo_reference=='{photo_reference}'")
        .reset_index(drop=True)
        .loc[0, "name"]
    )  
    
    meters = gdf_types.query(f"place_id=='{place_id}'")["meters"].values[0].round(0)
    meters = int(meters)
    
    area = gdf_types.query(f"place_id=='{place_id}'")["area"].values[0].round(0)
    area = int(area)
    
    types = gdf_types.query(f"place_id=='{place_id}'")["types"].values[0]
    
    adress = gdf_types.query(f"place_id=='{place_id}'")["formatted_address"].values[0]
    
    print(f"Name: {name}")
    print(f"Area: {area:,}m\u00B2")
    print(f"Dist to nearest (GUSTO) residence: {meters}m")
    print(f"Classified types: {types}")
    print(f"Adress: {adress}")

    # ==============================================================
    def _show_image(photo_reference: str, height, width, savefolder):
        file = photo_reference + ".png"
        filepath = os.path.join(savefolder, file)
        image = Image.open(filepath)
        # Display the image
        plt.figure(figsize=(width, height))
        plt.imshow(image)
        plt.axis('off')  # Turn off axis ticks and labels
        plt.show()       
        
    _show_image(photo_reference, height, width, savefolder)
    return None


# In[22]:


id = "\\wsl.localhost\Debian\home\lsys\gusto\scripts\analyze-edc\output\gm-cache-payloads\place-pictures\Aaw_FcI0xofa2JBykzTDzj4DpcVaGvabtzqWhpzEtLSUcYMU9dOrqJBFkxql_1D7Wt5cSz_KFcDVVPZkeCHg0IrZWL5P0UcSFj3_gOU1cIGQdnGG2s-jUIJi3Ec75a6qbwu96rLSAJlTUFPBEOFBUWZ5O4ujYI3TM-7qiAMI3IJvW5GkQtrA.png"
id = id.split("\\")[-1].replace(".png", "")
show_image2(id)


# In[23]:


id = "\\wsl.localhost\Debian\home\lsys\gusto\scripts\analyze-edc\output\gm-cache-payloads\place-pictures\Aaw_FcI3rqmmsOcN48DPe9kaurgqzmowJTrcUvD1NmQ2i6RhHr9nWYBtNkUv8jUX6NnKOTPNq8m9wlgOMt63fdkTfLUm9CwRRUbtaLt2_j0hdC6Lxgdi_NVG0gyYBpkGjBkHCuheUUUMIkZTB1jSa2Ssn0gToPMDYpYY3rRtwYL6FIQCT_YZ.png"
id = id.split("\\")[-1].replace(".png", "")
show_image2(id)


# In[24]:


id = "\\wsl.localhost\Debian\home\lsys\gusto\scripts\analyze-edc\output\gm-cache-payloads\place-pictures\Aaw_FcI68A-Ondi30czt2KZvGvnOBogen4auUeGa0iycWiE9M3n_Zn2fAa8rtaxEY1G6gP6XT2dujkmvhnglI7jIg_hlVGRWOzJrS7weGmU_--5Dm0uGFGBVX3NtPDSVY-LGWx9AqT6dGSHFGYn9Udky-sF5Eanke7b1qf5smAm-nBthRX5r.png"
id = id.split("\\")[-1].replace(".png", "")
show_image2(id)


# In[25]:


id = "\\wsl.localhost\Debian\home\lsys\gusto\scripts\analyze-edc\output\gm-cache-payloads\place-pictures\Aaw_FcI-cVa4e3XlmfuiF8iuAZxN4qkplw0rUdDf_Ga5G0CrIhZQAPZr8xi6CEeFJOWfwGCn-PJb0f6Bjl2Gjwc8PTQAMSI33FqcFSfOrV9-ceIJ3V8x7tGzbPV32jDIGccjNRJScoalVXRc-0udCtG8GwfInFS7jJtelcC2Zk1AXSrH28pY.png"
id = id.split("\\")[-1].replace(".png", "")
show_image2(id)


# In[26]:


id = "\\wsl.localhost\Debian\home\lsys\gusto\scripts\analyze-edc\output\gm-cache-payloads\place-pictures\Aaw_FcIgVBeldSN5uq8NBxGTz3a_I_dyfOm_xwxROcesipzjRLhtI-we2kce5kYJ9pVD9aF4ZLF8B2AyD-5GQPENaoHWZ_KbHE8Sx7moxk-W36WsCsEARvRGcQ7D3OMvRoQDasWgLblfO9yR9D9yUl8TP2iWxk8IGnFPEV58G1XyFYhnGH24.png"
id = id.split("\\")[-1].replace(".png", "")
show_image2(id)


# In[27]:


id = "\\wsl.localhost\Debian\home\lsys\gusto\scripts\analyze-edc\output\gm-cache-payloads\place-pictures\Aaw_FcIPMFeKOoqSlbkGMXwzcY9GvCn0t_s473x6GOBbMGk0gATCsDXq94OooQXO_C11L9cv7lKS3_qGZP7O2vJB1ukza0E9MIL6agLtAX6lGmtEHaadwdVK2SgURoso8dgnkvPWVG_c1nOFaIhWI2cwUw4i_sZ4ehhgUicBLuCGRT0TW5ks.png"
id = id.split("\\")[-1].replace(".png", "")
show_image2(id)


# In[28]:


id = "\\wsl.localhost\Debian\home\lsys\gusto\scripts\analyze-edc\output\gm-cache-payloads\place-pictures\Aaw_FcIqEa_G03v8_EqCtwmWx0r2qMbh10AmxClee7o2cRfzJfctxJy6-acB9-SCdMXf9gG5N4rBRr74GuVRkGIKpNrjMbxcfHalB-f0uXVZl-vhGXnmgDEy74hesLB6FkcujuYZulWNOHHtkID6gPPMiOWtj1HJwsJGK0atk4VlsbVHIqYv.png"
id = id.split("\\")[-1].replace(".png", "")
show_image2(id)


# In[29]:


id = "\\wsl.localhost\Debian\home\lsys\gusto\scripts\analyze-edc\output\gm-cache-payloads\place-pictures\Aaw_FcIrgb1LjZ8PUPaDwJkGcyiLUL4eXKzzedqTZW25GricXe5yY8A1j3yEQ7lDSXJaeQD-ELMznIBrEHJCeM2ieXrNcJL7SxWnHsi39XGmKKA09Fo0_JWDzCFBpx4Q2KGPDtMRK_mMu2zOhM2sBclkFOTDcGOI3zydJm1MoCrg_hoBfcHU.png"
id = id.split("\\")[-1].replace(".png", "")
show_image2(id)


# In[30]:


id = "\\wsl.localhost\Debian\home\lsys\gusto\scripts\analyze-edc\output\gm-cache-payloads\place-pictures\Aaw_FcIvKUOxjxT8aG8Bmnkv0mnm1c4H0J5n3Gxk9YccIwkdQPhGgjGu1BL1o6cTDfsGyZXMnWgENDJ1otVjwzex-MHyNZ28lSHpQ9-Tw06LOV-ruuQF40NVOtLgiQ1KkE9wg82yw3tFdGVWTu0Rw2RQdLgTOVZHgEvmC7axJIC3owWrW2qx.png"
id = id.split("\\")[-1].replace(".png", "")
show_image2(id)


# In[31]:


id = "\\wsl.localhost\Debian\home\lsys\gusto\scripts\analyze-edc\output\gm-cache-payloads\place-pictures\Aaw_FcIVRFVka4w3I6A3mznql4vbEhni9ErD_bS3Wqnj7l_OS540DT0bV45kxbwmlaYVvZ9Etnnv_Dy6CYiCh0lJdIp_SnFWQEm0wTHd6xSZyAHIXUqVhL6aoo4SebB_7QudbRV7SCnEBZ6oVYg7k05R3IUOJKXwpGbE2hq0HDjpSLeSpaxA.png"
id = id.split("\\")[-1].replace(".png", "")
show_image2(id)


# In[32]:


id = "\\wsl.localhost\Debian\home\lsys\gusto\scripts\analyze-edc\output\gm-cache-payloads\place-pictures\Aaw_FcIWB6PjxTZb8gzyIHxQjxy7WEsKCwXV5KOEOHU_Q4ljHiDWFTzHrDC09IJo3pI-fYNKvM_HPb4ok2k7Al2JG8RFX798nBbZxgH5qY1US5pmGmBTzC1OLrx8VaWgsOTbfYwzAa8nZ17LK4G5lvHk-UPu5Kkxu6N8FZ1lI1oDm5TXx37F.png"
id = id.split("\\")[-1].replace(".png", "")
show_image2(id)


# In[33]:


id = "\\wsl.localhost\Debian\home\lsys\gusto\scripts\analyze-edc\output\gm-cache-payloads\place-pictures\Aaw_FcIY6WN5Pa3_IJ1Fy9dGp0uZ5Rz3EUS6HPzvM-nUAHykehVIe7sZH2uI55pEZDSHKwlmUJCVg-zIgsFWoUfWxurC1mzYlWj-3zGzIOUAGURPNbwG1DjQotBCAUFFaJbpEJ0Okvo10l55MTgs3o8Dtsi2uwQb6ooNccNCc7pI5FUrHXMa.png"
id = id.split("\\")[-1].replace(".png", "")
show_image2(id)


# In[34]:


id = "\\wsl.localhost\Debian\home\lsys\gusto\scripts\analyze-edc\output\gm-cache-payloads\place-pictures\Aaw_FcIYX8qIy7nS4x4nM3fqaGEUw8dhf5cn8mJCIUPowJZ_JhOQDBDtJy40cBo4KM7evvMAX4qTPNKmnnpkdK7QO1AI3Lhgn67q-zhzVDWtBnC0xDvTz12pp8vhiiBc-ah2JLlyXJOAqm0CVwblHkqFUe21eC9a_6tjzlhNSjifS-TzHSY.png"
id = id.split("\\")[-1].replace(".png", "")
show_image2(id)


# In[35]:


id = "\\wsl.localhost\Debian\home\lsys\gusto\scripts\analyze-edc\output\gm-cache-payloads\place-pictures\Aaw_FcJ4bB0F6o9UjF2LCNup6Z2L5hTMIVqcrExbT-jzgwwZ0Miawnrfub3kKHHYxT6pyWO1VrAiKlBZ7IhOBK3P0RG3VMlk58PLuX-5Nz8fy6do9URi06VEjaM6dy_x0vnaZG7I_dG5z7xfRERERAf9eQUUGUiFS289_t9fCWDcU1qRvrCI.png"
id = id.split("\\")[-1].replace(".png", "")
show_image2(id)


# In[36]:


id = "\\wsl.localhost\Debian\home\lsys\gusto\scripts\analyze-edc\output\gm-cache-payloads\place-pictures\Aaw_FcJ6RLycz3pFW354TxU6ZCy-UFj1cyItsJnyN3pO3CS-WYsFLcL3j5_qdvYi2SFQaT-8S33kuC8xcso_1-EiaB4E7Uw8yT8LKe8k7A83Dy5VyWWRcQpr1Z13t_ou2yvTRh17v0jYc6VR90WCjvZS5mW3FGF00c7cTrcmxVoGVaK0VsEB.png"
id = id.split("\\")[-1].replace(".png", "")
show_image2(id)


# In[37]:


id = "\\wsl.localhost\Debian\home\lsys\gusto\scripts\analyze-edc\output\gm-cache-payloads\place-pictures\Aaw_FcJ8Pwz6WQtOfh5k0hXZ7btdZPyNtduIeZIBxTon_e6JhG_fTBhvZqY499H79Q2IQ-6rulEqiDWpUlDMHFSxmaiWwgfuflyAO_qCSKbvTwrbeJt01QyDovAin4MRFGv82ZgRNkS3YuBjiCxlIyYPn9BniuXaDUHIA6C3kuczhYcrXtjd.png"
id = id.split("\\")[-1].replace(".png", "")
show_image2(id)


# In[38]:


id = "\\wsl.localhost\Debian\home\lsys\gusto\scripts\analyze-edc\output\gm-cache-payloads\place-pictures\Aaw_FcJtVc3urxc3JucFX4H22wVfcvRr1b8P341mM4E1AJHBUusMZ3aKCLLuZhxUGU2VMzf1ZiTjYlmjRdBF3q6h9PXu1tWwLj_QBLMsC1NoSZLTfGafkucytiXYdenJCNYEoQlJtLQ1RBkCJRhbrbv5-_0ize8d6M98wMefeSxn0YLa5tRw.png"
id = id.split("\\")[-1].replace(".png", "")
show_image2(id)


# In[39]:


id = "\\wsl.localhost\Debian\home\lsys\gusto\scripts\analyze-edc\output\gm-cache-payloads\place-pictures\Aaw_FcK6qfuUBFxiMMymzso377KLBzCDV9vAM2NfKgJwzHJgIjp7OcdTcU9lJFv0GEn3x7s5IGl7r1DBd5QTdCfXzeBzuTsNSGgc8bvMNjouEutV574T2GAnxZVJGNuvmKN-IK7hOLDOgPHGwam0XFdTUqbwRMlTHSsb0M0RLDLgXcKTz3Rz.png"
id = id.split("\\")[-1].replace(".png", "")
show_image2(id)


# In[40]:


id = "\\wsl.localhost\Debian\home\lsys\gusto\scripts\analyze-edc\output\gm-cache-payloads\place-pictures\Aaw_FcK23Y3UkblJBVJ0z6PVeP1wg4rG1cMWuNjEwm38wMmU6C8o0zZNYuaFYhbGpfvVZHK5tIivgDEZWokNK6vrU_gNacvhmQkU02FJkQCUL8QZusPac9AR-jy96JA_4Jyb4qJThTNqwAcQLVs3miJSkmxK4YoYQ9UMzx4rIoBcg7zi_A8C.png"
id = id.split("\\")[-1].replace(".png", "")
show_image2(id)


# In[41]:


id = "\\wsl.localhost\Debian\home\lsys\gusto\scripts\analyze-edc\output\gm-cache-payloads\place-pictures\Aaw_FcKlrHKc7dQz5cf2ZIRlAyG4s1Rn4PSTLiUnG0c8kLQsfY7AKgwhUDVsLLQ-fd0eC_y_ss3L5BfF04fpovVTpU3UjOOkEkWXUUyUApKMEZ7gdeOquomFRMQT8hCzmM_2FPUcDQ0ZTM43xMJWmNSAgKPUE6ZCFJnmoep1Ub0VKuJhdLzO.png"
id = id.split("\\")[-1].replace(".png", "")
show_image2(id)


# In[42]:


id = "\\wsl.localhost\Debian\home\lsys\gusto\scripts\analyze-edc\output\gm-cache-payloads\place-pictures\Aaw_FcKmr1l7djM1eInsEn4Emcu4f72ZMq1vYnUGUFsOwcbNGsM-47CT95BRmvgKGwQgQWfYyIrPpZFtkY1YFZJoDwLO8P-gWpj0iTeT3t5sJgInaxxTPcuK4FILyfZijtl6apoG5r8owqE0aqEKBGfBmu1NJb50Ws7LOT_9pcZ98PTmWZ5q.png"
id = id.split("\\")[-1].replace(".png", "")
show_image2(id)


# In[43]:


id = "\\wsl.localhost\Debian\home\lsys\gusto\scripts\analyze-edc\output\gm-cache-payloads\place-pictures\Aaw_FcKOF-dt0aIctGYplnYiOOESOEmifCySFV79fHX292P0ovU3gnqIUPE739zaxGtuEkY39BMRSiJ6N8GPBk5YFlUl_apvCqD1n_S6YBrZllAQUB-z9RZf1-ck6fIo3mN5ViwEMZT_SlRSEo7M2O3QZT7A3GHpOBxdeyZHYV5uABcEqhlt.png"
id = id.split("\\")[-1].replace(".png", "")
show_image2(id)


# In[44]:


id = "\\wsl.localhost\Debian\home\lsys\gusto\scripts\analyze-edc\output\gm-cache-payloads\place-pictures\Aaw_FcKPJ8yl6ZtkQwFHtYdxIbX1rbx9XmuVTml86K2vM9aYVk6yxersPy7pHbQ3UAtQRxKLma8r7WSDW6QTc4xL5VHaF0nty-mCet4Qs-ZaG_wPDqcmVoxcWJFcnClNnvPUolt7kxl9m_PxY3sM3atg_tUyc1Cvxl-c-7mufdSF8N46bdx3.png"
id = id.split("\\")[-1].replace(".png", "")
show_image2(id)


# In[45]:


id = "\\wsl.localhost\Debian\home\lsys\gusto\scripts\analyze-edc\output\gm-cache-payloads\place-pictures\Aaw_FcKQFOluBXsSgghx8-CMn4MitMt6W3KmCcFZ-jRkQAw94nZS0oZR9qYD5Zz6NuX10zd6KkkIfxhQj-3cQIAmkscTDQqispw3jQkECsjwDIVbk8V2cXFWFtZKMo4rnNAgVNlFucLnPtMNLhjKiBOTkNpSTJR4AF802xVbMb7mKLwJgb7B.png"
id = id.split("\\")[-1].replace(".png", "")
show_image2(id)


# In[46]:


id = "\\wsl.localhost\Debian\home\lsys\gusto\scripts\analyze-edc\output\gm-cache-payloads\place-pictures\Aaw_FcKUZf2pd0hU4EzSFqKreyW3rXNPuwJzThk1pfg6ENVvrVP9NWtPXCNvvilVq2EqJaHDu3p907U91sAgElJyBJoEYptyVZGDkKb80RMV6PLr6JUDhtFYCLBTemnaUvfqs7gizICt4B9MTOxCUUX635n2g9pqGRF4SbK3ohTnF9ZLQh6J.png"
id = id.split("\\")[-1].replace(".png", "")
show_image2(id)


# In[47]:


id = "\\wsl.localhost\Debian\home\lsys\gusto\scripts\analyze-edc\output\gm-cache-payloads\place-pictures\Aaw_FcKxA80YQNolBBjQlSqvMX61OkgBQUXdAGi0M5kBGRF63z8LX6ry0UaOYekLSgLrUHmRE_DriNfRkWZj1wq0ZduIc2Y0kMvxknJFMXgZ6qLQeRT4Zxej8nVD6SGzAdh8S0ji8suDhVlK5IYV7ZXZeg551zqWKKMjtnL1Kd_9xOu_SUqu.png"
id = id.split("\\")[-1].replace(".png", "")
show_image2(id)


# * Shell
# * Aaw_FcI0xofa2JBykzTDzj4DpcVaGvabtzqWhpzEtLSUcYMU9dOrqJBFkxql_1D7Wt5cSz_KFcDVVPZkeCHg0IrZWL5P0UcSFj3_gOU1cIGQdnGG2s-jUIJi3Ec75a6qbwu96rLSAJlTUFPBEOFBUWZ5O4ujYI3TM-7qiAMI3IJvW5GkQtrA

# ## Selected land parcels (from selected postcodes)

# In[100]:


lu_index = 46084
gdf.query(f"lu_index=={lu_index}")


# In[101]:


lu_index = 46084
gdf.query(f"lu_index=={lu_index}").photo_reference.tolist()


# In[110]:


show_image2(gdf.query(f"lu_index=={lu_index}").photo_reference.tolist()[0])


# In[93]:


show_image2("Aaw_FcKOF-dt0aIctGYplnYiOOESOEmifCySFV79fHX292P0ovU3gnqIUPE739zaxGtuEkY39BMRSiJ6N8GPBk5YFlUl_apvCqD1n_S6YBrZllAQUB-z9RZf1-ck6fIo3mN5ViwEMZT_SlRSEo7M2O3QZT7A3GHpOBxdeyZHYV5uABcEqhlt")


# In[98]:


show_image("Blk 774", all=True)


# In[ ]:




