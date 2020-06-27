epoch_day=86400
alert_days=7
epoch_warning=$(($(date +%s) + (alert_days*epoch_day)))
now_epoch=$(date +%s)
# Slack notification header
tittle="CERTS CHECKER"
# Slack channel
channel="#productions_notifications"
# Slack webhook
webhook=""

#ssl_check() {
#    while IFS= read -r site;
#    do
#        #echo $site
#        expire_epoch=$(openssl s_client -servername "$site" -connect "$site":"443" 2>&- | openssl x509 -enddate -noout | sed 's/^notAfter=//g' | xargs -I{} date -d {} +%s)
#        if [ $epoch_warning -gt $expire_epoch ]; then
#            alert="<$site> TLS certificate expiration date is 7 days or less"
#            #payload="payload={\"channel\": \"$channel\", \"text\": \"${alert}\"}"
#            payload="payload={\"tittle\": \"$tittle\",\"channel\": \"$channel\", \"text\": \"${alert}\"}"
#            curl -s -m 10 --data-urlencode "${payload}" $webhook > /dev/null
#        fi
#    done <"./sites_list"
#}

expiration_harvesting() {
    while IFS= read -r site;
    do
        expire_epoch=$(openssl s_client -servername "$site" -connect "$site":"443" 2>&- | openssl x509 -enddate -noout | sed 's/^notAfter=//g' | xargs -I{} date -d {} +%s)
        check_send
    done <"./sites_list"
}
check_send() {
    if [ $epoch_warning -gt $expire_epoch ]; then
                alert="The $site  site TLS certificate expiration date is 7 days or less"
                payload="payload={\"tittle\": \"$tittle\",\"channel\": \"$channel\", \"text\": \"${alert}\"}"
                curl -s -m 10 --data-urlencode "${payload}" $webhook > /dev/null
    fi
}

expiration_harvesting
