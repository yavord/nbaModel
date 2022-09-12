import pandas as pd
from datetime import timedelta


def __min_to_seconds(
    x: str,  # mm:ss string
) -> float:
    mins, secs = map(int, x.split(':'))
    td = timedelta(minutes=mins, seconds=secs)
    return td.total_seconds()


def __player_name_fix(
    x: str,  # name str
):
    return x.split(x[0]+'.')[0]


def preprocess_full(
    df: pd.DataFrame,
) -> pd.DataFrame:
    df = df.drop(columns=['Unnamed: 0.1','Unnamed: 0'])  # drop player numbers
    df = df.set_index('DATE')
    df['MIN'] = df['MIN'].apply(__min_to_seconds)
    df['PLAYER'] = df['PLAYER'].apply(__player_name_fix)
    df[['HOME','AWAY']] = df['MATCHUP'].str.split(' vs ', 1, expand=True)  # split matchup into home/away cols
    df = df.drop(['MATCHUP'], axis=1)

    return df


x = preprocess_full(pd.read_csv('stats.csv')).to_csv('pp_test.csv')
# x = 'Deni AvdijaD. Avdija'
# __name_fix(x)

# x = 'Washington Wizards vs Charlotte Hornets'
# __matchup_split(x)
