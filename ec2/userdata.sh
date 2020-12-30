#!/bin/bash

#
# Update system
#

# amazon linux 2
yum update -y

#
# Update DNS record
#

RECORD="astropi"
ZONE="marcelloromani.name"
ZONE_ID="Z2QQXSV9NP7LNN"

IP=$(curl http://169.254.169.254/latest/meta-data/public-ipv4)
echo "PUBLIC IP = ${IP}"
CHANGES=$(cat <<EOF
{
    "Changes": [
        {
            "Action": "UPSERT",
            "ResourceRecordSet": {
                "Name": "${RECORD}.${ZONE}",
                "Type": "A",
                "TTL": 300,
                "ResourceRecords": [
                    {
                        "Value": "${IP}"
                    }
                ]
            }
        }
    ]
}
EOF
)

echo "$CHANGES"
aws route53 change-resource-record-sets --hosted-zone-id $ZONE_ID --change-batch "$CHANGES"

#
# Update SSHD settings to expose forwarded ports
#

sed -i 's/#GatewayPorts/GatewayPorts/'       /etc/ssh/sshd_config
sed -i 's/GatewayPorts no/GatewayPorts yes/' /etc/ssh/sshd_config

systemctl restart sshd
