import pandas as pd
from datetime import datetime
from time import sleep
from tqdm import tqdm
from nba_api.stats.static import players, teams
from nba_api.stats.endpoints import PlayerCareerStats


def map_team_id_to_abrv() -> dict:
    id_to_abrv = {}
    all_teams: list = teams.get_teams()
    for team in all_teams:
        id_to_abrv[team['id']] = team['abbreviation']
    assert len(id_to_abrv) == 30  # number of teams in NBA
    return id_to_abrv


def map_player_id_to_names() -> pd.DataFrame:
    all_active_players = pd.DataFrame(players.get_active_players())
    all_active_players = all_active_players.loc[:,['id','first_name','last_name']]
    all_active_players = all_active_players.set_index('id')
    return all_active_players


def team_abrv_to_csv(team_abrv: dict):
    team_abrv = pd.Series(team_abrv).to_csv('src/data/team_abbreviations.csv', header=False)


def all_player_teams_to_csv(player_names: pd.DataFrame):

    def get_current_team(player_id: str, season_id: str = '2022-23') -> pd.DataFrame:
        get_logs = PlayerCareerStats(player_id)
        logs: pd.DataFrame = get_logs.get_data_frames()[0]
        logs = logs.loc[:,['PLAYER_ID','SEASON_ID','TEAM_ID','TEAM_ABBREVIATION']]
        logs = logs[logs.loc[:,'SEASON_ID'] == season_id]
        return logs
    
    all_players = []
    for player_id in tqdm(player_names.index.values):
        try:
            player_logs = get_current_team(player_id)
        except:
            print('[%s] Timeout: sleep 30s' % (datetime.now()))
            sleep(30.0)
            player_logs: pd.DataFrame = get_current_team(player_id)
        all_players.append(player_logs)
        sleep(1)
    all_players_df: pd.DataFrame = pd.concat(all_players, axis=0).reset_index(drop=True)
    all_players_df.to_csv('src/data/player_team.csv')


if __name__ == "__main__":
    abrv = map_team_id_to_abrv()
    names = map_player_id_to_names()
    team_abrv_to_csv(team_abrv=abrv)
    all_player_teams_to_csv(player_names=names)
