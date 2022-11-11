import pandas as pd


df: pd.DataFrame = pd.read_csv('salaries.csv')
df = df[~df.Date.str.contains('file transm')]
df = df[~df.Date.str.contains('For the')]
df = df.iloc[:,1:4]
df['Date'] = pd.to_datetime(df['Date'])
df = df.set_index('Date')
df['DK Salary'] = df['DK Salary'].str.replace(r'\D','')
df = df.loc[(df.index > '10-27-2015') & (df.index < '06-19-2016')]
df = df.dropna(how='any')
