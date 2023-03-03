#!/usr/bin/python
import uuid
import getopt
import sys
import os



def final_action(action):
    if action == 4:
        os.system("rm -rf /etc/v2ray/config.json")
        os.system("rm -rf /usr/bin/v2ray/data.json")
    elif action == 0:
        print ("this funcion is not completed yet")
        exit()
    else:
        print ("other options are not completed yet")
        exit()
def final_user(user):
    fastfile = open("/etc/v2ray/config.json","a")
    fastfile.write('{\n  #user: %s\n  "inbounds": [{\n' %user)
    fastfile.close()
    dataa = open("/usr/bin/v2ray/data.json","a")
    dataa.write("user: %s  " %user)
    dataa.close
def final_port(port):
    fastfile = open("/etc/v2ray/config.json","a")
    fastfile.write('    "port": %d,\n' %port)
    fastfile.close()
    dataa = open("/usr/bin/v2ray/data.json","a")
    dataa.write("port: %s  " %port)
    dataa.close
def final_inboundprotocol(inboundprotocol):
    fastfile = open("/etc/v2ray/config.json","a")
    fastfile.write('    "protocol": "%s",\n    "settings": {\n' %inboundprotocol)
    fastfile.close()
    dataa = open("/usr/bin/v2ray/data.json","a")
    dataa.write("protocol: %s  " %inboundprotocol)
    dataa.close
def final_output():
    idd = (uuid.uuid4())
    getid = idd
    fastfile = open("/etc/v2ray/config.json","a")
    fastfile.write('      "clients": [{ "id": "%s" }]\n    }\n  }],\n  "outbounds": [{\n    "protocol": "freedom",\n    "settings": {}\n  }]\n}\n' %getid)
    fastfile.close()
    dataa = open("/usr/bin/v2ray/data.json","a")
    dataa.write("id: %s  " %getid)
    dataa.write("Aid: 0\n")
    dataa.close

def fuuopts():
    try:
        optlist, args = getopt.getopt(sys.argv[1:],"hadelru:p:i:g",["help"])
        for key, setting in optlist:
            if key == "-a":
                action = 0
                final_action(action)
            elif key == "-d":
                action = 1
                final_action(action)
            elif key == "-e":
                action = 2
                final_action(action)
            elif key == "-l":
                action = 3
                final_action(action)
            elif key == "-r":
                action = 4
                final_action(action)
            elif key in ('--help','-h'):
                print ("Still working on this file")
            elif key == "-u":
                user = setting
                final_user(user)
            elif key == "-p":
                port = int(setting)
                final_port(port)
            elif key == "-i":
                inboundprotocol = setting
                final_inboundprotocol(inboundprotocol)
            elif key == "-g":
                final_output()
    except getopt.GetoptError as gg:
		print(gg)
		exit()

if __name__=="__main__":
    fuuopts()
