import pandas as pd
import data_numeric as dn
import matplotlib.pyplot as plt
plt.style.use('ggplot')


df: pd.DataFrame = dn.get_numeric_data()

df.hist()
plt.show()
