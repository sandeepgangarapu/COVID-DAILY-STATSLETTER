import mdmail
import smtplib


email = """
# Sample Email

- Python is awesome
- Markdown is cool

"""

EMAIL_ADDRESS = "coronadailyupdates@gmail.com"
EMAIL_PASSWORD = "coronadailyupdates@9"

email = 'Hey'
smtp = {'host': 'smtp.gmail.com',
        'port': 587,
        'tls': False,
        'ssl': True,
        'user': 'EMAIL_ADDRESS',
        'password': 'EMAIL_PASSWORD'}

mdmail.send(email, subject='Sample Email', from_email=EMAIL_ADDRESS, to_email=EMAIL_ADDRESS, smtp=smtp)


