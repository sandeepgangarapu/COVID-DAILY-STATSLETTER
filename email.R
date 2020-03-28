library(gmailr)
library(googlesheets4)
email_list = read_sheet("https://docs.google.com/spreadsheets/d/1HI0llUuuVHRTSnMacgnIVzQmYgZGUckQ2cRMhPTA7QM/")


setwd("G:\\My Drive\\Projects\\COVID")
#gm_auth_configure(path = "G:\\My Drive\\Projects\\COVID\\credentials.json")

html_msg <- gm_mime() %>%
  gm_bcc(email_list$email_id) %>%
  gm_from("sandeepgangarapu.iitkgp@gmail.com") %>%
  gm_subject("Latest COVID stats - Automatically Generated Email") %>% 
  gm_text_body("If you see a bug, Please reply to this email with the issue.") %>% gm_attach_file("newsletter_generator.pdf")


gm_send_message(html_msg)
