
# Import smtplib for the actual sending function
import smtplib

# Import the email modules we'll need
from email.mime.text import MIMEText

class Emailer(object):
    
    def send_email(self,gmail_username,gmail_password,subject,message,to):    
        
        msg = MIMEText(message)        
        fr = gmail_username
        pwd = gmail_password
        
        msg['Subject'] = subject
        msg['From'] = fr
        msg['To'] = to

        server = smtplib.SMTP('smtp.gmail.com',587) #port 465 or 587
        server.ehlo()
        server.starttls()
        server.ehlo()
        server.login(fr,pwd)
        server.sendmail(fr,[to],msg.as_string())
        server.quit()
