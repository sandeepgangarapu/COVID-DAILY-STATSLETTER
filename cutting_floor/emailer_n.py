import smtplib
import ssl

port = 465  # For SSL
sender_email = "covid19.customstatsletter@gmail.com"  # admin-email
password = "91divoc@91"  # admin-email password
receiver_email = "sandeepgangarapu.iitkgp@gmail.com"

# Create a secure SSL context
context = ssl.create_default_context()


# this is the message which is to be sent
message = """\
Subject: COVID-19 Daily Stats

Hey, today's updated covid-19 statistics :--- \n\n"""


# sending the message as email to receiver-user
with smtplib.SMTP_SSL("smtp.gmail.com", port, context=context) as server:
    server.login(sender_email, password)
    server.sendmail(sender_email, receiver_email, message)

# email-sent to this user
print("Sent mail to " + receiver_email)