# Deregulation Index Data Files

This directory contains clean, web-ready CSV files of the U.S. Deregulation Index.

## Files

### deregulation_index_headline.csv
Main deregulation index and key variants.

**Columns:**
- `date`: Date in YYYY-MM-DD format
- `deregulation_index`: Main U.S. deregulation index (365-day MA, mean=100 in 1960-2019)
- `regulation_index`: U.S. regulation index (365-day MA, mean=100 in 1960-2019)
- `foreign_deregulation_index`: Foreign deregulation index (365-day MA)
- `deregulation_proposed`: Proposed deregulation measures (365-day MA)
- `deregulation_enacted`: Enacted deregulation measures (365-day MA)

Higher values indicate more activity. The index is normalized to mean=100 over 1960-2019.

### deregulation_index_sectors.csv (available after sectoral processing)
Sectoral breakdown of deregulation activity.

**Expected columns:**
- `date`: Date in YYYY-MM-DD format
- `finance`: Financial sector deregulation
- `energy`: Energy sector deregulation
- `telecom`: Telecommunications sector deregulation
- `transport`: Transportation sector deregulation
- `trade`: Trade sector deregulation
- `health`: Healthcare sector deregulation
- `housing`: Housing sector deregulation
- `agriculture`: Agriculture sector deregulation

All sector indexes are 365-day moving averages, normalized to mean=100 over 1960-2019.

### deregulation_index_geography.csv
Regional/country-level breakdown of deregulation activity.

**Columns:**
- `date`: Date in YYYY-MM-DD format
- `usa`: United States deregulation
- `canada`: Canada deregulation
- `uk`: United Kingdom deregulation
- `western_europe`: Western Europe deregulation
- `eastern_europe`: Eastern Europe deregulation
- `japan`: Japan deregulation
- `china`: China deregulation
- `asia`: Asia (excluding China & Japan) deregulation
- `australia`: Australia deregulation
- `latin_america`: Latin America deregulation
- `middle_east`: Middle East deregulation
- `russia`: Russia deregulation
- `africa`: Africa deregulation

All geography indexes are raw daily values, normalized to mean=100 over 1960-2019.
Client-side moving average computation recommended for visualization.

### metadata.json
Comprehensive metadata including:
- Dataset description and methodology
- Variable definitions and units
- Coverage information
- Citation information
- Construction details (articles analyzed, LLM model, etc.)

## Usage Examples

### Python (pandas)
```python
import pandas as pd

# Load headline index
df = pd.read_csv('deregulation_index_headline.csv')
df['date'] = pd.to_datetime(df['date'])

# Plot main index
import matplotlib.pyplot as plt
plt.plot(df['date'], df['deregulation_index'])
plt.title('U.S. Deregulation Index')
plt.show()
```

### R
```r
library(tidyverse)

# Load headline index
df <- read_csv('deregulation_index_headline.csv')
df$date <- as.Date(df$date)

# Plot main index
ggplot(df, aes(x = date, y = deregulation_index)) +
  geom_line() +
  labs(title = 'U.S. Deregulation Index')
```

### JavaScript (D3.js)
```javascript
d3.csv('deregulation_index_headline.csv').then(data => {
  data.forEach(d => {
    d.date = new Date(d.date);
    d.deregulation_index = +d.deregulation_index;
  });

  // Use data for visualization
});
```

## Data Quality
- All values rounded to 2 decimal places
- Missing values (if any) represented as empty strings
- Date format: ISO 8601 (YYYY-MM-DD)
- Encoding: UTF-8

## Citation
Cascaldi-Garcia, Danilo, and Matteo Iacoviello (2026).
"Quantifying Deregulation and its Economic Effects: A Large Language Model Approach."
Federal Reserve Board.

## License
[To be determined by authors]

## Contact
For questions or issues, please contact:
- Danilo Cascaldi-Garcia: danilo.cascaldi-garcia@frb.gov
- Matteo Iacoviello: matteo.iacoviello@frb.gov

## Notes
- The deregulation index measures news coverage of deregulation activity
- Higher values indicate more intense deregulation activity as captured by newspaper articles
- Moving averages should be computed client-side (raw daily values provided)
- Data is normalized to mean=100 over the period 1960-2019
- Sectoral indexes will be available after sectoral classification completes
- Geography indexes provide regional/country-level deregulation activity
