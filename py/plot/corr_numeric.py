import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
import data_numeric as dn
plt.style.use('ggplot')
sns.set_theme(style="white")


df: pd.DataFrame = dn.get_numeric_data()

# plot correlation matrix
corr = df.corr()
# Generate a mask for the upper triangle
mask = np.triu(np.ones_like(corr, dtype=bool))
# Set up the matplotlib figure
f, ax = plt.subplots(figsize=(11, 9))
# Generate a custom diverging colormap
cmap = sns.diverging_palette(230, 20, as_cmap=True)
# Draw the heatmap with the mask and correct aspect ratio
sns.heatmap(corr, mask=mask, cmap=cmap, vmax=1, center=0,
            square=True, linewidths=.5, cbar_kws={"shrink": .5})
plt.show()
