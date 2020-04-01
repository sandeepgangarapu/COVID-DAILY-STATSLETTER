import gspread
from oauth2client.service_account import ServiceAccountCredentials


def sub_data():
    # authorizing credentials for google sheets API
    scope = ['https://spreadsheets.google.com/feeds','https://www.googleapis.com/auth/drive']
    creds = ServiceAccountCredentials.from_json_keyfile_name('creds.json', scope)
    client = gspread.authorize(creds)

    # user-data from paper_form
    users = client.open('paper_form').sheet1
    user_data = users.get_all_records()
    return user_data
