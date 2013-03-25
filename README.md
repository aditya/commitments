# Overview #
Commitments manages multiuser task items.

# Structure #
Commitments is a multiuser database built from git repositories. There
is a root directory, with a home directory per user. Each home directory
is a git repository, independently versioned.

It looks like this:
```
./
./users
./users/xxx@b.com
./users/xxx@b.com/<task1 guid>.yaml
./users/xxx@b.com/<task2 guid>.yaml
./users/yyy@a.com
./tags
```

Each task item is stored as an individual file, versioned by git.

Task items are shared between users with symlinks.

Workflow and functionality is about generating events from diffs. Goes
like this:

* You edit one or more task item files
* Compute a logical diff between the edited files and the previous
version
* Run the task item paired with its diffness through a code 
generation template to emit a list of named events
* Execute the list of named events with the task as context

# Web Service #
The web service:
* sits in front of a commitment directory structure
* routes task files to the appropritate user home directory
* kicks off the workflow as task files are updated
* emits file changed events to connected clients
* provides autocomplete for tags and users
* provides listing for each user's home directory

# User Identity & Authentication #
Email addresses are the user identity. And email is the login. When you
get a task, commitments sends you an email. You click it. Commitments
writes out your identity to local storage so you never log in.

If you manage to delete local storage, or go to another computer, just
put in your email address and commitments will send you a link.

All links sent by commitments via email have a token indicating to whom,
    which logs you in automatically.
