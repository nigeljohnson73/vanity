import sys
import requests
import base64

def usage():
    print(f"{sys.argv[0]} <message>")

if len(sys.argv) < 2:
    usage()
    exit()

msg = sys.argv[1]

url = "https://api.bulksms.com/v1/messages"
headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Basic QjFBNDZGQTJFQzI0NDZCRjg1MEFEQUU4RTg4MDVCNzItMDItQzoyIUgqVVZoYWJFTzdBNVd2MVFzdThyT2IxZWREOA==',
}
payload = {
    "from": "PenguinMob",
    "to" : "447517528741",
    "body" : msg, 
}

resp = requests.post(url, headers=headers, json=payload, )
print(f"{resp.status_code} - {resp.text}")


