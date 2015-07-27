#Install Shenzhen
#Install Testflight

# echo "HELLO!"
# ITUNES_CONNECT_ACCOUNT = "benjam1.bouaziz@gmail.com"
# echo "HELLO2!"
# echo "ITUNES_CONNECT_ACCOUNT"
# ITUNES_CONNECT_PASSWORD = "Moun2067"
# echo ITUNES_CONNECT_PASSWORD
ipa build
ipa distribute:itunesconnect -a benjam1.bouaziz@gmail.com -p Moun2067 -i 1010506731 --upload --verbose