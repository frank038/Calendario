# Calendario
A simply program in which to store appointments.
Version 1.4

MD5SUM calendario.py_20201127.tar.gz: fe43176be8cb9d8d72633aafb96c7683

This program is free to use and modify.

Required: python3, gtk3.

Calendario stores all the events in a standard ics file.
Because of the huge specs of this format, only the necessary fields will be used:
- Summary
- Location
- Description
- Dtstart (starting date and time)
- Dtend (ending date and time).

The button bar from left:
- choose a month (click on the name to go to today)
- choose a year (click on the year to to to today)
- add a new appointment
- save the calendar
- exit the program.

Moreover, each event can be modified or deleted by clicking on the event in the right with the right button of the mouse.

Calendario tends to be a quite complite program in its semplicity.

Date limitation: if an event is longer than one day, it will appear only in the day it starts.

Personalizations: in the top of the file some settings can be changed.

![My image](https://github.com/frank038/Calendario/blob/master/image.png)
