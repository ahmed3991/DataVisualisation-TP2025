# 📊 Practical Work: Advanced Visualization, Comparative Analysis, and Interactivity

## 🎯 Objective
Critically evaluate and compare different visualization techniques for communicating global relationships. Move beyond static charts to utilize interactive and geospatial toolkits, justifying visualization choices based on data structure and communication goals.

## 🛠️ Tools
- **Python** (Pandas, NumPy, Matplotlib/Seaborn)
- **Plotly, Folium, NetworkX**
- **Optionally**: Altair

---

## 🏗️ I. Setup and Data Selection

### 1.1. 📁 Dataset Introduction
**Global Economic and Social Indicators Dataset** - Ensure it contains regional, economic, and social variables over time.

#### 🔑 Key Variables for Analysis

| Variable | Type | Role | World Bank Code | World Bank Link |
|----------|------|------|-----------------|-----------------|
| Country / Region | Categorical / Geo | Contextual and grouping variable | - | - |
| Year | Time Series | Primary axis for trend analysis | - | - |
| GDP_Per_Capita | Numerical (Economic) | Measure of economic output | NY.GDP.MKTP.CD | [GDP (current US$)](https://data.worldbank.org/indicator/NY.GDP.MKTP.CD) |
| Life_Expectancy | Numerical (Social) | Measure of social development/health | SP.DYN.LE00.IN | [Life expectancy at birth](https://data.worldbank.org/indicator/SP.DYN.LE00.IN) |
| Internet_Users_Pct | Numerical (Tech) | Measure of technological adoption | IT.NET.USER.ZS | [Internet users (% population)](https://data.worldbank.org/indicator/IT.NET.USER.ZS) |
| Population | Numerical | Variable for scaling/bubble size | SP.POP.TOTL | [Population, total](https://data.worldbank.org/indicator/SP.POP.TOTL) |

#### 💡 Data Source Note
You can download this data using Python libraries like **wbgapi** and **pandas**, or directly from the World Bank Data Portal:  
🔗 [World Development Indicators - World Bank DataBank](https://databank.worldbank.org/source/world-development-indicators#)

#### ⚙️ Setup Task
- Load data into a Pandas DataFrame
- Clean and standardize data types
- Handle missing values relevant to the labs

---

## 📈 II. Lab 4.2: Comparative Chart Choice and Correlation

### 2.1. 📊 Comparative Chart Choice: Visualizing Global Development

#### 🎯 Objective
Compare three visualization types for GDP_Per_Capita vs. Life_Expectancy relationship and justify the best choice for integrating Population.

#### 📋 Task A: Generate Comparative Plots
1. **Standard Scatter Plot** - GDP_Per_Capita (log scale) vs. Life_Expectancy
2. **Bubble Chart** - Same relationship with Population determining marker size
3. **2D Density Plot** - Hexbin or KDE to show observation concentrations

#### 📋 Task B: Justification

| Chart Type | ✅ Advantage | ❌ Disadvantage | 🎯 Best for Communicating... |
|------------|-------------|----------------|------------------------------|
| Scatter Plot | Clear relationship trend | Fails to show scale/impact | Simple bivariate correlation |
| Bubble Chart | Integrates 3rd dimension | Can be visually cluttered | Scale/impact of data points |
| Density Plot | Highlights data clusters | Loses individual point info | Concentration of observations |

#### ❓ Analysis Question
*Which chart is most effective for communicating: "Poorer nations show wide variability in Life Expectancy, but the population burden on global average Life Expectancy is heavily driven by populous, mid-range income nations." Justify your selection.*

### 2.2. 🔥 Visualizing Correlations: Heatmap

#### 🎯 Objective
Use heatmap to display linear relationships between key indicators.

#### 📋 Task A: Generate Correlation Heatmap
- Calculate Pearson's R correlation matrix for numerical variables
- Generate Seaborn heatmap with:
  - Divergent colorscale
  - Annotated correlation coefficients

#### 📋 Task B: Interpretation

#### ❓ Analysis Questions
1. Identify the strongest correlated variable pair and provide hypothesis
2. Discuss Population's relationship with other economic/social indicators

---

## 💻 III. Lab 4.3: Advanced Tools and Interactivity

### 3.1. ⏰ Time Series Interactivity with Plotly

#### 🎯 Objective
Create interactive time series visualization for exploring country trends.

#### 📋 Task A: Create Interactive Line Chart
- Select one developed and one developing country
- Use Plotly Express (`px.line`) for GDP_Per_Capita trends over time
- **Interactivity Requirements**: Hover tools + pan/zoom capabilities

### 3.2. 🌍 Geospatial Visualization with Folium

#### 🎯 Objective
Visualize social indicator using geospatial context.

#### 📋 Task A: Create Choropleth Map
- Focus on most recent year in dataset
- Create world map with Folium/Plotly Geo
- **Interactivity Requirements**: Pop-up/tooltip showing Country + Life_Expectancy

### 3.3. 🕸️ Visualizing Hierarchies/Relationships with NetworkX

#### 🎯 Objective
Visualize derived relationship structure based on regional grouping.

#### 📋 Task A: Model and Visualize Regional Hierarchy
- **Node Definition**: World (Root) → Regions (Level 1) → Countries (Level 2)
- **Edge Definition**: World→Regions, Regions→Countries
- **Visualization**: NetworkX + Matplotlib/Plotly
- **Bonus**: Use Population/GDP for node sizing

#### 💭 Discussion Question
*How could complex NetworkX graphs model economic relationships? What external data would be needed?*

---

## ✅ Submission Checklist

- [ ] 📊 Comparative charts (Scatter, Bubble, Density) for GDP vs. Life Expectancy
- [ ] 📝 Detailed justification for "best" chart choice
- [ ] 🔥 Correlation heatmap generated and interpreted
- [ ] ⏰ Interactive Plotly time series chart for two countries' GDP trends
- [ ] 🌍 Interactive Folium map displaying Life_Expectancy data
- [ ] 🕸️ NetworkX graph visualizing regional hierarchy