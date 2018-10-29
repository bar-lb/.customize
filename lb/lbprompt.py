import os
import time # TODO: no actual need
import sys
import json
import requests
import subprocess

PROMETHEUS_HOST = "prometheus"
PROMETHEUS_PORT = "9090"

QUERY = "/api/v1/query?query=up{user=\"%s\"}"
FILE="{home}/.lbprompt".format(home=os.getenv("HOME"))
PYTHON = "python"

# send promLQ query and return the result
def _run_cmd_get(url, data=None, timeout_secs=60):
    uri = 'http://{}:{}'.format(PROMETHEUS_HOST, PROMETHEUS_PORT) + url
    with requests.Session() as session:
        req = requests.Request("GET", uri, data=json.dumps(data) if data else None)
        req.headers.update({'Accept' : 'application/json'})
        # -H 'Expect:'  will prevent us to get the 100 Continue response from curl
        req.headers.update({'Expect' : ''})
        prepped = req.prepare()
        response = session.send(prepped, timeout=timeout_secs)
        response.raise_for_status()
        return_value = response.json()
        return return_value

# get a list of machine inaugurated by s pecific user
def check_for_name(name):
    res = _run_cmd_get(QUERY % name)
    alerts = res['data']['result']
    machines = []
    if len(alerts) > 0:
        machines = set([str(result["metric"]["instance"].split(":")[0]) for result in res['data']['result']])
    return machines

# shortening a new of machine
def short_name(long_name):
    return long_name.replace("rack","r").replace("server","s")

def set_msg(msg_file=FILE, detailed=False):
    if type(msg_file) == file:
        f = msg_file
    else:
        f = open(FILE,"w+")
    try:
        name = raw_input()
        machines = [short_name(machine) for machine in check_for_name(name)]
    
        if len(machines) > 0:
            if detailed:
                msg = "inaugurated on %s machines: %s" % (len(machines), ", ".join(machines))
            else:
                msg = "inaugurated on %s machines" % (len(machines))
        else:
            msg = "You are not using the lab"
        f.write(msg)
    except requests.ConnectionError:
        f.write("Lab unreachable")

    f.close()

def print_msg(msg_file=FILE):
    set_msg(sys.stdout)

if __name__ == "__main__":
    if "async" in sys.argv:
        # set message asyncronically
        script_file = os.path.abspath(sys.argv[0])
        args = [PYTHON, script_file, "__async"]
        subprocess.Popen(args)
    elif "__async" in sys.argv:
        set_msg()
    else:
        print_msg() 
