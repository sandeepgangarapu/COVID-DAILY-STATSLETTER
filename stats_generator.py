import pandas as pd
import gspread
from oauth2client.service_account import ServiceAccountCredentials
from jinja2 import Template
import smtplib
import ssl
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart
from credentials import sender_email, password
from datetime import date


def get_subscription_data():
    """
    This function retrieves all user subscription related data from the google sheet
    :return: user_data
    """
    # authorizing credentials for google sheets API
    scope = ['https://spreadsheets.google.com/feeds','https://www.googleapis.com/auth/drive']
    creds = ServiceAccountCredentials.from_json_keyfile_name('creds.json', scope)
    client = gspread.authorize(creds)

    # user-data from paper_form
    users = client.open('paper_form').sheet1
    user_data = users.get_all_records()
    return pd.DataFrame(user_data)


def user_to_stats(user, data, data_yest):
    """
    This function maps user preferences to custom stats from covid data
    :param user: each user data
    :param data: covid data
    :return: mapped stats for a singlr user
    """
    region_stats = []
    email = user['email']
    regions = user['region'].split(',')
    stats = user['stats'].split(',')

    for region in regions:
        values1 = data[data['region'] == region][stats].iloc[0]
        values2 = data_yest[data_yest['region'] == region][stats].iloc[0]
        vals = pd.concat([values1, values2], axis=1).reset_index()
        vals = vals.values.tolist()
        region_stat = {'region_name': region, 'values': vals}
        region_stats.append(region_stat)
    user_stat = {'email': email, 'region_stats': region_stats}
    return user_stat


def convert_to_html(user_stat):

    TEMPLATE = '''<p>Hello There,</b></p>
    <p>Here are the statistics you subscribed to. The numbers in the parenthesis are values of the same statistic for 
    yesterday.</p>
    <p> </p>
    {% for region in region_stats %}
        <h3>{{region["region_name"]}} :</h3>
        {% for feature, number, number2 in region["values"]%}
            <p>{{feature}} : {{number}} ({{number2}})</p>
        {% endfor %}
    {% endfor %}
    <p>If you find a bug, please reply to this email. Please share this with your friends
    <a href = "https://coronadailyupdates.org/custom-stats">https://coronadailyupdates.org/custom-stats.  </p>
    <p>Cheers.</p>'''
    template = Template(TEMPLATE)
    rendered_html = template.render(
        name=user_stat['email'],
        region_stats=user_stat['region_stats'])
    return rendered_html


def emailer(user_data, covid_data, covid_data_yest):
    for i, j in user_data.iterrows():
        user_stat = user_to_stats(j, covid_data, covid_data_yest)
        html = convert_to_html(user_stat)
        port = 465  # For SSL
        receiver_email = user_stat['email']
        # Create a secure SSL context
        context = ssl.create_default_context()
        # this is the message which is to be sent
        with smtplib.SMTP_SSL("smtp.gmail.com", port, context=context) as server:
            server.login(sender_email, password)
            msg = MIMEMultipart('alternative')
            msg['Subject'] = "COVID-19 Custom Statistics for " + str(date.today())
            msg['From'] = sender_email
            msg['To'] = receiver_email
            html = MIMEText(html, 'html')
            msg.attach(html)
            server.sendmail(sender_email, receiver_email, msg.as_string())
    pass


if __name__ == '__main__':
    user_data = get_subscription_data()
    data_file = 'data/country_state_list.csv'
    data_file_yest = 'data/country_state_list_yest.csv'
    covid_data = pd.read_csv(data_file)
    covid_data_yest = pd.read_csv(data_file_yest)
    emailer(user_data, covid_data, covid_data_yest)
