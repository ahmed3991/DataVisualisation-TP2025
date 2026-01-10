# Data Warehouse Exercises

## Exercise 1: Public Transportation System

### Case Study
A city transportation company wants to analyze the performance of its bus network using a Data Warehouse.

#### Dimensions
- **Bus** (BusID, BusType, Capacity, Manufacturer)
- **Driver** (DriverID, DriverName, LicenseLevel, ExperienceYears)
- **Line** (LineID, LineName, RouteLength, CityZone)
- **Station** (StationID, StationName, Area, Zone)
- **Date** (DateID, Day, Month, Quarter, Year)

#### Fact Table
- **Trip** (BusID, DriverID, LineID, StationID, DateID, Passengers, Delay)

### Questions

**1. Star Schema**
Draw (or clearly describe) the Star Schema for the Trip cube, including:
- The fact table
- All related dimensions
- Primary keys and foreign keys
- Relationships between fact and dimensions

**2. OLAP Operations**
Indicate which OLAP operations (ROLL-UP, DRILL-DOWN, SLICE, DICE) must be applied to obtain:

a. Total number of passengers per line per day

b. Average delay grouped by driver and bus type

c. Total number of trips per station per month

d. Total number of passengers carried by buses of a specific manufacturer

e. Average delay for all trips occurring in the Central Zone during the year 2021

---

## Exercise 2: Digital Advertising Performance

### Case Study
A digital marketing company wants to analyze online advertising campaigns across platforms.

#### Dimension Tables

**Product Dimension**

| Attribute   | Meaning                                |
|-------------|-----------------------------------------|
| ProductID   | Unique product identifier               |
| Category    | Product category (Electronics, Clothing…) |
| Brand       | Brand name                              |
| PriceRange  | Pricing segment (Low, Medium, High)     |

**Campaign Dimension**
| Attribute | Meaning |
|-----------|---------|
| CampaignID | Unique identifier |
| Objective | Goal (Awareness, Traffic, Conversions) |
| Budget | Total allocated budget |
| Platform | Platform (Facebook, Google...) |

**AdGroup Dimension**
| Attribute | Meaning |
|-----------|---------|
| AdGroupID | Unique identifier |
| AudienceType | Audience category (Students, Parents...) |
| Gender | Target gender (Male, Female, All) |
| AgeRange | Targeted age interval (e.g., 18-24) |

**Creative Dimension**
| Attribute | Meaning |
|-----------|---------|
| CreativeID | Identifier of creative asset |
| Format | Ad format (Image, Video, Carousel...) |
| MediaType | Static, Animated, Short Video... |

**Geography Dimension**
| Attribute | Meaning |
|-----------|---------|
| RegionID | Unique region identifier |
| Country | Country |
| City | City |

**Date Dimension**
| Attribute | Meaning |
|-----------|---------|
| DateID | Surrogate key |
| Day | Day number |
| Month | Month number |
| Year | Year |




#### Fact Table
**AdPerformance Fact Table**
| Attribute | Type | Meaning |
|-----------|------|---------|
| ProductID (FK) | Dimension link | |
| CampaignID (FK) | Dimension link | |
| AdGroupID (FK) | Dimension link | |
| CreativeID (FK) | Dimension link | |
| RegionID (FK) | Dimension link | |
| DateID (FK) | Dimension link | |
| Impressions | Measure | Number of ad displays |
| Clicks | Measure | Number of user clicks |
| Conversions | Measure | Number of goals achieved |
| Spend | Measure | Advertising cost |

### Questions

**1. Star Schema**
Draw the Star Schema showing:
- Dimensions around the fact table
- Keys and relationships
- Attributes inside each dimension
- Fact table at the center

**2. Snowflake Schema**
Draw the Snowflake Schema with normalized dimensions:
- Geography → Country table + City table
- Date → Year table + Month table + Day table
- Campaign → Platform as separate dimension
- Product → Brand table + Category table
Show normalized hierarchy and all FK/PK relationships

**3. Queries**
- Total spend per campaign per month
- Conversions per brand grouped by platform 
- Click-Through Rate (CTR) by audience gender (CTR = Clicks / Impressions)
- Total number of conversions per city for video ads
- Top 5 products (ProductID) with the highest CTR
- Cost per conversion for each platform (Cost per conversion = Spend / Conversions)
- Total impressions for the 18-24 age group during Q2
- Top performing product category per month (based on conversions)
 