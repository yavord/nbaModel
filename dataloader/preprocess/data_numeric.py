import pandas as pd
from datetime import timedelta


# convert 'MIN' to seconds
def __min_to_seconds(
    x: str,  # mm:ss string
):
    mins, secs = map(int, x.split(':'))
    td = timedelta(minutes=mins, seconds=secs)
    return td.total_seconds()


def get_numeric_data(
    file: str = '../data/stats.xlsx',
):
    df: pd.DataFrame = pd.read_excel(file)
    # drop player numbers
    df.drop(columns=['Unnamed: 0'], inplace=True)

    df['MIN'] = df['MIN'].apply(__min_to_seconds)
    numerical = df.iloc[:, 1:21]  # select only numerical var
    return numerical
