# Calendario
A simply program in which to store appointments.
Version 1.6

MD5SUM calendario.py_20201217.tar.gz: 80407524f2c5ccb79e3179c8482ac981

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

This program accept the data as argument in the form yyyymmdd, e.g. 20220302, and the calendar opens selecting that date. 

Calendario tends to be a quite complete program in its semplicity.

Date limitation: if an event is longer than one day, it will appear only in the day it starts.

Personalizations: in the top of the file some settings can be changed.

![My image](https://github.com/frank038/Calendario/blob/master/image.png)
