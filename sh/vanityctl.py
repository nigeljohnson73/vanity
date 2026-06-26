import sys
import os
import json

os.chdir(os.path.dirname(__file__)+"/..")

def usage():
    print()
    print(f"{sys.argv[0]} <cmd> <base> [<val>]")
    print()
    print("    cmd  - add, remove, empty, current, thset, thget, start, stop")
    print("    base - i2p, tor, both")
    print("    val  - data value if add, remove, thset")
    print()

def error(str):
    print(f"\nERROR: {str}")
    usage()
    exit()

def readFile(base):
    fn = f"params_{base}.json"
    ret = {
            "threads":2,
            "vals":[]
          }
    try:
        with open(fn, "r") as f:
            ret = json.load(f)
    except:
        pass
    return ret

def writeFile(base, params):
    fn = f"params_{base}.json"
    try:
        with open(fn, "w") as f:
            json.dump(params, f)
            return True
    except:
        pass
    return False

def stop(base):
    os.system("killall find_i2p.sh find_tor.sh vanity_i2p vanity_tor > /dev/null 2>&1")

def start(base):
    os.system(f"nohup sh/find_{base}.sh > /tmp/output_{b}.txt &")

if len(sys.argv) < 3:
    error("Invalid number of arguments")

cmd=sys.argv[1].lower()
if cmd not in [ 'add', 'remove', 'empty', 'current', 'thset', 'thget', 'start', 'stop' ]:
    error(f"Unknown command '{cmd}'")

base=[ sys.argv[2].lower() ]
if base[0] not in [ 'tor', 'i2p', 'both' ]:
    error(f"Unknown base set '{base[0]}'")

if base[0] == "both":
    base = ["tor", "i2p"]

if cmd in [ "add", "remove", "thset"]:
    if len(sys.argv) < 4:
        error(f"Missing data value for command '{cmd}'")

if cmd in [ "thget", "current"]:
    if len(base) > 1:
        error(f"Cannot perform '{cmd}' on both base sets")

val = ""
if cmd in [ "add", "remove", "thset"]:
    if len(sys.argv) > 4:
        error(f"Missing data for '{cmd}'")
    val=sys.argv[3]

if cmd in [ "thset" ]:
    try:
        val = int(val)
    except:
        error(f"Invalid value for threads '{val}'")

    if val < 2 or val > 4:
        error(f"Invalid number of threads '{val}'")

for b in base:
    if cmd in [ "start", "stop" ]:
        if cmd == "start":
            start(b)
        if cmd == "stop":
            stop(b)

    else:
        params = readFile(b)
        #print(params)

        if cmd in [ "current", "thget" ]:
            if cmd == "thget":
                val = 2
                try:
                    val = params.get("threads")
                except:
                    pass

            if cmd == "current":
                val = ""
                try:
                    val = params.get("vals")[0]
                except:
                    pass

            print(val)

        else:
            if cmd == "thset":
                params.update({"threads":val})

            if cmd == "empty":
                params.update({"vals":[]})

            if cmd == "add":
                vals = params.get("vals")
                if val in vals:
                    print(f"Value {val} already on list for {base} - ignoring update")
                else:
                    vals.append(val)
                    params.update({"vals":vals})

            if cmd == "remove":
                vals = params.get("vals")
                if val not in vals:
                    print(f"Value {val} not in list for {base} - ignoring update")
                else:
                    vals.remove(val)
                    params.update({"vals":vals})

            #json_string = json.dumps(params)
            #print(json_string)

            if writeFile(b, params):
                print("Data updated")
            else:
                print("Failed to update data")

