## Geocoding and Characterization of Transport Facilities Near Residential Locations

### Overview

This workflow identifies transport facilities within 1000m of study participant residences using Singapore's 2008 land use data.
The pipeline uses Google Maps APIs (reverse geocoding, Places, and Photos) to characterize facility types, compute spatial metrics (area, distance), and retrieve public-contributed street-level site photos of transport facilities for manual verification. 

![schematic](../assets/gm-places-pipeline-250dpi.png)


### Overview

### 1. `transportfacilities-1-geocoding-within1000m-residence.py`

- Loads Singapore land use 2008 data and filters for transport facilities
- Calculates distances from each GUSTO participant residence to all transport facilities
- Identifies facilities within 1000m buffer of participants
 
### 2. `transportfacilities-2-geocoding-rgeocode.py`

- Reverse geocodes facility centroids using Google Maps API
- Caches JSON payloads locally to avoid redundant API calls
 
### 3. `transportfacilities-3-geocoding-consolidate-rgeocode-payload.py`

- Consolidates reverse geocoding results into structured dataset
- Extracts location types (e.g., point_of_interest, parking, car_wash, gas_station)
- Generates frequency tables of facility types
 
### 4. `transportfacilities-4-geocoding-places.py`

- Queries Google Places API for additional facility details
- Retrieves business status, names, and photo references
 
###
 5. `transportfacilities-5-geocoding-consolidate-places.py`

- Consolidates Places API results
- Downloads facility photos using Places Photos API
- Links place IDs to land use indices

### 6. `transportfacilities-6-geocoding-selected-placepictures.py`

- Visualize for manual verification
 
