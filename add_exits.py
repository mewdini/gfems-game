import json
import os
import sys

def scan_dir(obj):
    for entry in obj:
        if entry.is_dir():
            scan_dir(os.scandir(entry))
        else:
            f = open(entry.path,encoding="utf8")
            data = json.load(f)
            lines = data["lines"]
            for key, value in lines.items():
                    n = value["next"]
                    if len(n) == 0:
                        n.append({})
                        n = n[0]
                        n["id"] = "-1"
                        n["text"] = "*Leave*"
            f.close()
            with open(entry.path, 'w', encoding='utf-8') as f:
                json.dump(data, f, ensure_ascii=False, indent=4)


scan_obj = os.scandir("C:\\Users\\pablo\\Documents\\classes\\gfems\\gfems-game\\dialogue")
scan_dir(scan_obj)
