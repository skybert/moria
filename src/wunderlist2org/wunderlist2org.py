#! /usr/bin/env python

# Command which converts Wunderlist lists to Emacs Org TODO and done
# items. Each list gets its own section with each Wunderlist task as a
# TODO or DONE item.

# by torstein.k.johansen at gmail dot com.

import codecs
from wunderpy import wunderlist

email_address="user@example.com"
password="youwish"
output_file="/home/torstein/src/my-writings/wunderlist.org"
s=""

def read_list(list):
    list_title=list["title"]
    s="* " + list_title + '\n'
    tasks=list["tasks"]
    
    for task in tasks:
        title=task["title"]
        completed=task["completed"]
        due_date=task["due_date"]
        last_updated=task["last_updated"]
        note=task["note"]
        if completed == None:
            s+="** TODO " + title + "\n"
            if due_date != None:
                s+="   SCHEDULED <" + due_date + ">" + "\n"
        else:
            s+= "** DONE " + title + "\n"
            s+= "   SCHEDULED <" + completed + ">" + "\n"
            
        if note != None:
            s+=note + "\n"

        s+="\n"
    return s


wl=wunderlist.Wunderlist(email_address, password)
login_ok=wl.login()
get_task_lists_ok=wl.get_task_lists()

for el in wl.lists:
    s+=read_list(el)
    
f = codecs.open(output_file, 'w', 'utf-8')
f.write(s)
f.close()

