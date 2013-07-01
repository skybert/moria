#! /usr/bin/env python

# Command which converts Wunderlist lists to Emacs Org TODO and done
# items. Each list gets its own section with each Wunderlist task as a
# TODO or DONE item.

# by torstein.k.johansen at gmail dot com.

from wunderpy import wunderlist

email_address="you@example.com"
password="youwish"

def read_list(list):
    list_title=list["title"]
    print "* " + list_title
    tasks=list["tasks"]
    
    for task in tasks:
        title=task["title"]
        completed=task["completed"]
        due_date=task["due_date"]
        last_updated=task["last_updated"]
        if completed == None:
            print "** TODO", title
            if due_date != None:
                print "   SCHEDULED <" + due_date + ">"
        else:
            print "** DONE", title
            print "   SCHEDULED <" + completed + ">"

        print ""
        

wl=wunderlist.Wunderlist(email_address, password)
login_ok=wl.login()
get_task_lists_ok=wl.get_task_lists()

for el in wl.lists:
    read_list(el)
    print ""
