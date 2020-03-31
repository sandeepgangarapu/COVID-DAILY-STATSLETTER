import smtplib

from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText

# me == my email address
# you == recipient's email address
EMAIL_ADDRESS = "coronadailyupdates@gmail.com"
EMAIL_PASSWORD = "coronadailyupdates@9"

# Create message container - the correct MIME type is multipart/alternative.
msg = MIMEMultipart('alternative')
msg['Subject'] = "Link"
msg['From'] = EMAIL_ADDRESS
msg['To'] = EMAIL_ADDRESS

# Create the body of the message (a plain-text and an HTML version).
# text = "Hi!\nHow are you?\nHere is the link you wanted:\nhttp://www.python.org"
html = """\
<html>
  <head></head>
  <body>
    <p>Hi!<br>
       How are you?<br>
       Here is the <a href="http://www.python.org">link</a> you wanted.
    </p>
  </body>
</html>
"""

f = open("G:\\My Drive\\Projects\\COVID\\newsletter_generator.html", 'r')
html = f.read()
f.close()

markdown = """
# Sample Email

- Python is awesome
- Markdown is cool

"""

# Record the MIME types of both parts - text/plain and text/html.
#part1 = MIMEText(text, 'plain')
part2 = MIMEText(html, 'html')

# Attach parts into message container.
# According to RFC 2046, the last part of a multipart message, in this case
# the HTML message, is best and preferred.
#msg.attach(part1)
msg.attach(part2)

# Send the message via local SMTP server.
s = smtplib.SMTP('smtp.gmail.com', 587)
# sendmail function takes 3 arguments: sender's address, recipient's address
# and message to send - here it is sent as one string.
s.ehlo()
s.starttls()
s.ehlo()
s.login(EMAIL_ADDRESS, EMAIL_PASSWORD)
s.sendmail(EMAIL_ADDRESS, EMAIL_ADDRESS, msg.as_string())
s.quit()
