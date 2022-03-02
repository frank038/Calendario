#!/usr/bin/env python3
# V. 1.5
############# PERSONALIZATION #############
# size of the main window
WWIDTH=1100
WHEIGHT=800

# name of the days
# TWEEKDAYS = ("  ", "Lun","Mar","Mer","Gio","Ven","Sab","Dom")
TWEEKDAYS = ("  ","Mon","Tue","Wed","Thu","Fri","Sat","Sun")

# name of the months
# TMONTSH = ("Gennaio", "Febbraio", "Marzo", "Aprile", "Maggio", "Giugno", "Luglio", "Agosto", "Settembre", "Ottobre", "Novembre", "Dicembre")
TMONTSH = ("January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December")

# the width of the month button at left top of the program
BCD = 150

# width of each cell in term of pixels
WIDTH_CELL = 140

# with of the right part of the window
WIDTH_CELL2 = 620

# the colour of the number of the selected day
color_selected_cell = "blue"

# list of colours
COLORS = ("red", "yellow", "green", "orange", "pink", "purple", "brown", "grey")

# the symbol used as the first coloured character of each appointments
LIST_SYMBOL = "•"

# number of events to show in each cell - 0 to disable
NUMBER_EVENTS = 3

# the max width in chars of the bottom right box (its widget)
RIGHT_BOX_EVENT = 30

################### END ###################

LEN_COLORS = len(COLORS)-1

import gi
gi.require_version("Gtk", "3.0")
from gi.repository import Gtk, Gdk
import datetime, os, sys


# info dialog
class DialogBox(Gtk.Dialog):
 
    def __init__(self, parent, info):
        Gtk.Dialog.__init__(self, title="Info", transient_for=parent, flags=0)
        self.add_buttons(Gtk.STOCK_OK, Gtk.ResponseType.OK)
 
        self.set_default_size(150, 100)
        
        label = Gtk.Label(label=info)
 
        box = self.get_content_area()
        box.add(label)
        self.show_all()

# load the database
fopen = "eventdb.ics"
all_events = None
if not os.path.exists(fopen):
    try:
        f = open("eventdb.ics", "w")
        f.write("""BEGIN:VCALENDAR
VERSION:2.0
CALSCALE:GREGORIAN
END:VCALENDAR""")
        f.close()
    except Exception as E:
        dialog = DialogBox(None, str(E))
        dialog.run()
        dialog.destroy()
        sys.exit()
try:
    with open(fopen, "r") as f:
        all_events = f.readlines()
except Exception as E:
    dialog = DialogBox(None, str(E))
    dialog.run()
    dialog.destroy()
    sys.exit()


# one for each event in the calendar
class sEvent:
    SUMMARY=None
    DTSTART=None
    DTEND=None
    LOCATION=None
    DESCRIPTION=None


# the program
class MainWindow(Gtk.Window):

    def __init__(self):
        Gtk.Window.__init__(self)
        self.set_default_size(WWIDTH, WHEIGHT)
        header = Gtk.HeaderBar(title="Calendario")
        header.props.show_close_button = False
        
        ## month navigation
        self.monthnavigationbox = Gtk.Box(orientation=0)
        Gtk.StyleContext.add_class(self.monthnavigationbox.get_style_context(), "linked")
        
        self.buttonBack = Gtk.Button(label=None, image = Gtk.Image.new_from_icon_name("go-previous-symbolic", Gtk.IconSize.BUTTON))
        self.buttonBack.connect("clicked", self.selectMonth, -1)
        self.monthnavigationbox.add(self.buttonBack)
        
        self.buttonCurrentDate = Gtk.Button(label=None)
        #self.buttonCurrentDate.set_size_request(100,-1)
        Gtk.Widget.set_size_request(self.buttonCurrentDate,BCD,-1)
        self.buttonCurrentDate.connect("clicked", self.resetToCurrentDate)
        self.monthnavigationbox.add(self.buttonCurrentDate)
        
        self.buttonForward = Gtk.Button(label=None, image = Gtk.Image.new_from_icon_name("go-next-symbolic", Gtk.IconSize.BUTTON))
        self.buttonForward.connect("clicked", self.selectMonth, 1)
        self.monthnavigationbox.add(self.buttonForward)
        
        header.pack_start(self.monthnavigationbox)
        
        ## year navigation
        self.yearnavigationbox = Gtk.Box(orientation=0)
        Gtk.StyleContext.add_class(self.yearnavigationbox.get_style_context(), "linked")
        
        self.buttonBack2 = Gtk.Button(label=None, image=Gtk.Image.new_from_icon_name("go-previous-symbolic", Gtk.IconSize.BUTTON))
        self.buttonBack2.connect("clicked", self.selectYear, -1)
        self.yearnavigationbox.add(self.buttonBack2)
        self.buttonCurrentDate2 = Gtk.Button(label=None)
        self.buttonCurrentDate2.connect("clicked", self.resetToCurrentDate)
        self.yearnavigationbox.add(self.buttonCurrentDate2)
        
        self.buttonForward2 = Gtk.Button(label=None, image=Gtk.Image.new_from_icon_name("go-next-symbolic", Gtk.IconSize.BUTTON))
        self.buttonForward2.connect("clicked", self.selectYear, 1)
        self.yearnavigationbox.add(self.buttonForward2)
        header.pack_start(self.yearnavigationbox)
        
        ## close this program
        close_button = Gtk.Button(label=None, image=Gtk.Image.new_from_icon_name("exit", Gtk.IconSize.BUTTON))
        close_button.set_tooltip_text("Exit")
        self.connect("delete-event", self.on_exit)
        close_button.connect("clicked", self.on_exit2)
        header.pack_end(close_button)
        
        ## button save the database
        save_button = Gtk.Button(label=None, image=Gtk.Image.new_from_icon_name("document-save", Gtk.IconSize.BUTTON))
        save_button.set_tooltip_text("Save the calendar")
        save_button.connect("clicked", self.on_save_calendar)
        header.pack_end(save_button)
        
        ## button add a new event
        # Add button to header to display calendar dialog.
        addevent_button = Gtk.Button(label=None, image=Gtk.Image.new_from_icon_name("appointment-new", Gtk.IconSize.BUTTON))
        addevent_button.set_tooltip_text("Add a new event")
        addevent_button.connect("clicked", self.on_cal_clicked)
        header.pack_end(addevent_button)
        
        self.set_titlebar(header)
        
        # when a cell is been selected or today
        self.selected_year = 0
        self.selected_month = 0
        self.selected_day = 0
        
        ## today - datetime.date(2020, 9, 25)
        self.opening_data = datetime.datetime.now().date()
        
        #### the main box
        self.mbox = Gtk.Box(orientation=0, spacing=0)
        
        self.add(self.mbox)
        
        # bottom - the data of the selected event in the right box
        self.bframe = Gtk.Frame()
        
        ### table - the calendar
        self.gbox = Gtk.Box(orientation=1, spacing=0)
        self.mbox.add(self.gbox)
        self.grid = Gtk.Grid()
        self.gbox.add(self.grid)
        
        # the list of all the events
        self.list_events = []
        
        # get the events
        self.get_events(all_events)
        
        # cell frame label to restore when another cell is selected
        self.label_to_restore = None
        
        ## right part
        # main right box
        self.rbox = Gtk.Box(orientation=1, spacing=0)
        self.mbox.pack_end(self.rbox, True, True, 0)
        
        # top label - the data of the selected day or today
        tframe = Gtk.Frame()
        self.tlabel = Gtk.Label()
        self.tlabel.set_size_request(WIDTH_CELL2, -1)
        self.tlabel.set_xalign(0)
        tframe.add(self.tlabel)
        self.rbox.add(tframe)
        
        # middle - the events of the day
        self.mframe = Gtk.Frame()
        self.mframe.set_vexpand(True)
        self.scrolled_window = Gtk.ScrolledWindow()
        self.scrolled_window.set_border_width(10)
        self.scrolled_window.set_policy(Gtk.PolicyType.NEVER, Gtk.PolicyType.AUTOMATIC)
        self.mframe.add(self.scrolled_window)
        self.swbox = Gtk.Box(orientation=1, spacing=0)
        self.scrolled_window.add(self.swbox)
        self.rbox.add(self.mframe)
        
        # populate everything
        self.dateServiceFun(self.opening_data)
        
        # the menu when right clicking on the label in the right
        self.event_context_menu()
        
        # the calendar has been changed
        self.calendar_has_been_changed = 0
        
        #
        self.rbox.add(self.bframe)
    
    
    # main window
    def on_exit(self, w, e):
        self.on_exit2(w)
        return True
    
    # button quit
    def on_exit2(self, w):
        if self.calendar_has_been_changed:
            dialog = DialogYN(self, "  Quit?  ", "\n The calendar has been modified. \n")
            response = dialog.run()
            if response == Gtk.ResponseType.OK:
                dialog.destroy()
                Gtk.main_quit()
            dialog.destroy()
        else:
            Gtk.main_quit()
    
    
    # save the calendar
    def on_save_calendar(self, w):
        try:
            f = open(fopen,"w")
            f.write("""BEGIN:VCALENDAR
VERSION:2.0
CALSCALE:GREGORIAN\n""")
            # self.list_events - list of events
            for ev in self.list_events:
                f.write("BEGIN:VEVENT\n")
                f.write("SUMMARY:"+ev.SUMMARY+"\n")
                f.write("LOCATION:"+ev.LOCATION+"\n")
                f.write("DTSTART:"+ev.DTSTART+"\n")
                f.write("DTEND:"+ev.DTEND+"\n")
                f.write("DESCRIPTION:"+ev.DESCRIPTION+"\n")
                f.write("END:VEVENT\n")
            f.write("""END:VCALENDAR""")
            f.close()
        except Exception as E:
            dialog = DialogBox(self, str(E))
            dialog.run()
            dialog.destroy()
            return
        # reset
        self.calendar_has_been_changed = 0
        #
        dialog = DialogBox(self, "Done!")
        dialog.run()
        dialog.destroy()
    
    
    # empty the right bottom frame
    def empty_bframe(self):
        if self.bframe.get_children():
            self.bframe.get_children()[0].destroy()
    
    
    # put all the events from the file in self.list_events
    def get_events(self, _events):
        if _events is None:
            return
        if _events == []:
            return
        #
        s_event = None
        for el in _events:
            
            if el.strip("\n") == "BEGIN:VEVENT":
                s_event = sEvent()
                
            elif el.strip("\n")[0:8] == "SUMMARY:":
                s_event.SUMMARY = el.strip("\n")[8:]
            
            elif el.strip("\n")[0:8] == "DTSTART:":
                s_event.DTSTART = el.strip("\n")[8:]
            
            elif el.strip("\n")[0:6] == "DTEND:":
                s_event.DTEND = el.strip("\n")[6:]
            
            elif el.strip("\n")[0:9] == "LOCATION:":
                s_event.LOCATION = el.strip("\n")[9:]
            
            elif el.strip("\n")[0:12] == "DESCRIPTION:":
                s_event.DESCRIPTION = el.strip("\n")[12:]
            
            elif el.strip("\n") == "END:VEVENT":
                #
                self.list_events.append(s_event)
                s_event = None
            
            elif el.strip("\n") == "END:VCALENDAR":
                s_event = None
                break
    
    
    # content of the top label in the right
    def on_tlabel(self, text):
        self.tlabel.set_markup(text)
    
    
    # date service function
    def on_date(self, TODAY):
        self.NAME_TODAY = TODAY.strftime('%A')
        self.NAME_TOMONTH = TODAY.strftime('%B')
        self.TODAY_WEEKDAY = TODAY.weekday()
        self.NUM_TODAY = TODAY.day
        self.NUM_MONTH = TODAY.month
        self.NUM_YEAR = TODAY.year
        
        # set the month in this headbar button
        self.buttonCurrentDate.set_label(self.NAME_TOMONTH)
        # set the year in this headbar button
        self.buttonCurrentDate2.set_label(str(self.NUM_YEAR))
        
        # when a cell is been selected or today
        self.selected_year = self.NUM_YEAR
        self.selected_month = self.NUM_MONTH
        self.selected_day = self.NUM_TODAY
    
    
    # change the view by month
    def selectMonth(self, w, incr):
        new_year = self.NUM_YEAR
        # set the new date
        if incr == 1:
            if self.NUM_MONTH < 12:
                new_month = self.NUM_MONTH + 1
            else:
                new_month = 1
                new_year += 1
        elif incr == -1:
            if self.NUM_MONTH == 1:
                new_month = 12
                new_year -= 1
            else:
                new_month = self.NUM_MONTH - 1
        
        new_date = datetime.date(new_year, new_month, 1)
        #
        self.dateServiceFun(new_date)
    
    
    # change the view by year
    def selectYear(self, w, incr):
        new_year = self.NUM_YEAR + incr
        new_date = datetime.date(new_year, self.NUM_MONTH, 1)
        self.dateServiceFun(new_date)
    
    
    # repopulate everythig in this program after every changes
    def dateServiceFun(self, new_date):
    
        self.on_date(new_date)
        
        # set the date in the top label in the right
        ttext = "<span size='xx-large'>{}</span>\n<span size='large'>{} {}, {}</span>".format(self.NAME_TODAY.title(), self.NAME_TOMONTH.title(), self.NUM_TODAY, self.NUM_YEAR)
        self.on_tlabel(ttext)
        
        # delete the appointment widgets of the box in the right
        swwidgets = self.swbox.get_children()
        for sww in swwidgets:
            sww.destroy()
        
        # populate the month view
        self.month_view(new_date)
        
    
    # reset to today
    def resetToCurrentDate(self, w):
        self.dateServiceFun(self.opening_data)
    
    
    # month view
    def month_view(self, todata):
        
        # empty the grid
        ch_list = self.grid.get_children()
        for ch in ch_list:
            ch.destroy()
        
        # empty the right bottom frame
        self.empty_bframe()
        
        ## cells
        
        # the name of the days
        weekDays = TWEEKDAYS
        
        # column name - the name of the days
        for i in range(8):
            fframe = Gtk.Frame()
            label = Gtk.Label(label=weekDays[i])
            label.set_xalign(0.5)
            label.set_yalign(0.5)
            if i > 0:
                label.set_size_request(WIDTH_CELL, -1)
            fframe.add(label)
            self.grid.attach(fframe, i,0,1,1)
        
        # this month and previous month number of days
        DAYS_THIS_MONTH, DAYS_PREV_MONTH = self.num_days_month(datetime.date(self.NUM_YEAR, self.NUM_MONTH, 1))
        self.FIRST_WEEKDAY = datetime.date(self.NUM_YEAR, self.NUM_MONTH, 1).weekday()
        
        PM = DAYS_PREV_MONTH - self.FIRST_WEEKDAY + 1
        SM = DAYS_THIS_MONTH - DAYS_THIS_MONTH + 1
        NM = 1
        
        # the list of all events - list of lists
        LEVENTS = self.list_events
        
        ## cells inside
        
        # first column - week numbers
        first_month_week = datetime.date(self.NUM_YEAR, self.NUM_MONTH, 1).isocalendar()[1]
        number_of_weeks_in_year = datetime.date(self.NUM_YEAR, 12, 28).isocalendar()[1]
        
        iidx = 0
        ck = 0
        
        for i in range(6):
            fframe = Gtk.Frame()
            
            if self.NUM_MONTH == 1 and ck == 0 and first_month_week > 1:
                label = Gtk.Label(label=first_month_week)
                iidx = 0
                first_month_week = 1
                ck += 1
            else:
                label = Gtk.Label(label=iidx+first_month_week)
                if iidx+first_month_week == number_of_weeks_in_year:
                    iidx = 0
                    first_month_week = 1
                else:
                    iidx += 1
            
            fframe.add(label)
            self.grid.attach(fframe, 0,i+1,1,1)
        
        # populate the calendar
        # rows
        for i in range(6):
            # columns
            for ii in range(7):
                
                pfframe = Gtk.Frame()
                pfframe.set_label_align(0.97,0)
                fframe = Gtk.Frame()
                fframe.set_label_align(0.97,0)
                nfframe = Gtk.Frame()
                nfframe.set_label_align(0.97,0)
                
                flabel = Gtk.Label()
                flabel.set_hexpand(True)
                flabel.set_vexpand(True)
                
                # previous month days
                if PM <= DAYS_PREV_MONTH:
                    # flabel.set_markup("<i>"+str(PM)+"</i>")
                    # pfframe.set_label_widget(flabel)
                    self.grid.attach(pfframe, ii+1,i+1,1,1)
                    PM += 1
                else:
                    # current month days
                    if SM <= DAYS_THIS_MONTH:
                        # it is today
                        if (self.opening_data.day == todata.day) and (SM == self.opening_data.day) and (self.NUM_YEAR == self.opening_data.year) and (self.NUM_MONTH == self.opening_data.month):
                            flabel.set_markup("<span color='{}'><b>".format(color_selected_cell)+str(SM)+"</b></span>")
                            fframe.set_label_widget(flabel)
                            # label to restore when another cell il selected
                            self.label_to_restore = flabel
                        # when an event is been added - cell of today
                        elif (self.opening_data.day != todata.day) and (SM == self.opening_data.day) and (self.NUM_YEAR == self.opening_data.year) and (self.NUM_MONTH == self.opening_data.month):
                            flabel.set_markup("<b>"+str(SM)+"</b>")
                            fframe.set_label_widget(flabel)
                        # when an event is been added - cell of the new event
                        elif (SM == todata.day) and (self.NUM_YEAR == todata.year) and (self.NUM_MONTH == todata.month):
                            flabel.set_markup("<span color='{}'>".format(color_selected_cell)+str(SM)+"</span>")
                            fframe.set_label_widget(flabel)
                            # label to restore when another cell il selected
                            self.label_to_restore = flabel
                        # it isnt doday
                        else:
                            flabel.set_markup(str(SM))
                            fframe.set_label_widget(flabel)
                        SM += 1
                        
                        #
                        eb = Gtk.EventBox()
                        
                        # Connect signals
                        eb.connect("button-press-event", self.on_grid_click)
                        
                        ## the events of the day
                        fframe = self.find_events(fframe, flabel)
                        # row and col
                        eb.rownm = i
                        eb.colnm = ii
                        eb.add(fframe)
                        #
                        self.grid.attach(eb, ii+1,i+1,1,1)
                        ####### end cell
                    #
                    # following month days
                    else:
                        # flabel.set_markup("<i>"+str(NM)+"</i>")
                        # nfframe.set_label_widget(flabel)
                        self.grid.attach(nfframe, ii+1,i+1,1,1)
                        NM += 1
        #
        # populate the right box
        self.set_content_frame_w(todata.day)
                
        self.mbox.show_all()
        
    
    # find the events for the given day
    def find_events(self, fframe, flabel):
        ####### appointments
        LEVENTS = self.list_events
        # the cell label that contains the events
        alabel = Gtk.Label()
        alabel.set_ellipsize(3)
        # will be stored in the label above
        LABEL_CONTENT = ""
        ic = 0
        # number of events
        num_ev = 0
        for c, ell in enumerate(LEVENTS):
            
            TDATE = ell.DTSTART.split("T")[0]
            ydate = int(TDATE[0:4])
            mdate = int(TDATE[4:6])
            ddate = int(TDATE[6:8])
            #
            if (ydate == self.NUM_YEAR) and (mdate == self.NUM_MONTH) and (ddate == int(flabel.get_text())):
                SUMMARY = ell.SUMMARY
                
                if NUMBER_EVENTS > 0:
                    num_ev += 1
                    if num_ev <= NUMBER_EVENTS:
                        LABEL_CONTENT += "<span color='{}'><b>{}</b></span><b>{}</b>".format(COLORS[ic], LIST_SYMBOL, SUMMARY)+"\n"
                else:
                    LABEL_CONTENT += "<span color='{}'><b>{}</b></span><b>{}</b>".format(COLORS[ic], LIST_SYMBOL, SUMMARY)+"\n"
            #
            # at the last colour in the list starts from the beginning
            if COLORS[ic] == COLORS[LEN_COLORS]:
                ic = 0
            else:
                ic += 1
        #
        # add the number of events in the label if it is the case
        if NUMBER_EVENTS > 0:
            if num_ev > NUMBER_EVENTS:
                LABEL_CONTENT += "Total: {}".format(num_ev)+"\n"
        #
        alabel.set_markup(LABEL_CONTENT[:-1])
        alabel.set_halign(Gtk.Align.START)
        fframe.add(alabel)
        ####### end appointments
        return fframe
    
    
    # number of days for the given month of the year
    def num_days_month(self, TODAY):
        
        today = TODAY.day
        month = TODAY.month
        year = TODAY.year
        
        if month < 12:
            DAYS_THIS_MONTH = (datetime.date(year, month+1, 1) - datetime.date(year, month, 1)).days
        else:
            DAYS_THIS_MONTH = (datetime.date(year+1, 1, 1) - datetime.date(year, 12, 1)).days
        
        if month == 2:
            DAYS_PREV_MONTH = (datetime.date(year, 1, 1) - datetime.date(year-1, 12, 1)).days
        elif month == 1:
            DAYS_PREV_MONTH = (datetime.date(year-1, 12, 1) - datetime.date(year-1, 11, 1)).days
        else:
            DAYS_PREV_MONTH = (datetime.date(year, month-1, 1) - datetime.date(year, month-2, 1)).days
        
        return (DAYS_THIS_MONTH, DAYS_PREV_MONTH)
    
    
    # selecting a calendar cell
    # w is event box
    def on_grid_click(self, w, e):
        selected_frame = w.get_children()[0]
        selected_frame_label = selected_frame.get_label_widget()
        if selected_frame_label:
            selected_frame_label_text = selected_frame_label.get_text()
            self.set_content_frame(selected_frame, int(selected_frame_label_text))
        else:
            return
        #
        if self.label_to_restore is not None:
            # restore the frame text of the previous selected cell
            prev_fr_text = self.label_to_restore.get_text()
            # if today
            if (prev_fr_text == str(self.opening_data.day)) and (self.opening_data.month == self.NUM_MONTH) and (self.opening_data.year == self.NUM_YEAR):
                self.label_to_restore.set_markup("<b>{}</b>".format(prev_fr_text))
            else:
                self.label_to_restore.set_text(prev_fr_text)
            
        # the new selected frame label is blue if it is today
        if (selected_frame_label_text == str(self.opening_data.day)) and (self.opening_data.month == self.NUM_MONTH) and (self.opening_data.year == self.NUM_YEAR):
            # colored text if it is today
            selected_frame_label.set_markup("<span color='{}'><b>".format(color_selected_cell)+selected_frame_label_text+"</b></span>")
        else:
            selected_frame_label.set_markup("<span color='{}'>".format(color_selected_cell)+selected_frame_label_text+"</span>")
        
        # label to restore when another cell il selected
        self.label_to_restore = selected_frame_label
        
        # change the content of the top label in the right
        name_selected_day = datetime.date(self.NUM_YEAR, self.NUM_MONTH, int(selected_frame_label_text)).strftime("%A")
        ttext = "<span size='xx-large'>{}</span>\n<span size='large'>{} {}, {}</span>".format(name_selected_day.title(), self.NAME_TOMONTH.title(), selected_frame_label_text, self.NUM_YEAR)
        self.on_tlabel(ttext)
        
        # when a cell is been selected - update day
        self.selected_day = int(selected_frame_label_text)
        
        # empty the right bottom frame
        self.empty_bframe()
    
    
    def set_content_frame(self, w, to_day):
        self.set_content_frame_w(to_day)
    
    
    # box in the right - contains the events of the day 
    def set_content_frame_w(self, to_day):
        #
        # delete the widgets of the box in the right
        swwidgets = self.swbox.get_children()
        for sww in swwidgets:
            sww.destroy()
        #
        ic = 0
        #
        for ell in self.list_events:
            
            sdate, stime = ell.DTSTART.split("T")
            TDATE = sdate
            ydate = int(TDATE[0:4])
            mdate = int(TDATE[4:6])
            ddate = int(TDATE[6:8])
            temp_smonth = sdate[4:6]
            smonth = TMONTSH[int(temp_smonth)-1]
            sdate2 = "{} {} {}".format(sdate[0:4], smonth, sdate[6:8])
            temp_stime_h = stime[0:2]
            temp_stime_m = stime[2:4]
            stime2 = "{}:{}".format(temp_stime_h, temp_stime_m)
                
            #
            if (ydate == self.NUM_YEAR) and (mdate == self.NUM_MONTH) and (ddate == to_day):
                SUMMARY = ell.SUMMARY
                elabel = Gtk.Label()
                elabel.set_xalign(0)
                elabel.set_yalign(0)
                elabel.set_markup("<span color='{}'><b>{}</b></span><b> {}</b>".format(COLORS[ic], LIST_SYMBOL, SUMMARY))
                
                edate, etime = ell.DTEND.split("T")
                temp_emonth = edate[4:6]
                emonth = TMONTSH[int(temp_emonth)-1]
                edate2 = "{} {} {}".format(edate[0:4], emonth, edate[6:8])
                temp_etime_h = etime[0:2]
                temp_etime_m = etime[2:4]
                etime2 = "{}:{}".format(temp_etime_h, temp_etime_m)
                elabel.set_tooltip_markup("<i>Summary:</i> {}\n<i>Location:</i> {}\n<i>Description:</i> {}\n<i>Start:</i> {} at {}\n<i>End:</i> {} at {}".format(SUMMARY, ell.LOCATION, ell.DESCRIPTION.replace("\\n","\n"), sdate2, stime2, edate2, etime2))
                # link the whole event to the label
                elabel.evnt = ell
                elabel.set_has_window(True)
                elabel.set_events(Gdk.EventMask.BUTTON_PRESS_MASK)
                elabel.connect("button-press-event", self.eventLabel)
                self.swbox.add(elabel)
            
            # at the last colour in the list starts from the beginning
            if COLORS[ic] == COLORS[LEN_COLORS]:
                ic = 0
            else:
                ic += 1
        
        self.mbox.show_all()
    
    
    #
    def viewEvent(self, w):
        
        dialog = viewEventClass(self, "View this event", None, self.modev)
        response = dialog.run()
        
        result = None

        if response == Gtk.ResponseType.OK:
            dialog.destroy()
        
        dialog.destroy()
    
    #
    def modifyEvent(self, w):
        
        dialog = modifyEventClass(self, "Modify this event", None, self.modev)
        response = dialog.run()
        
        result = None

        if response == Gtk.ResponseType.OK:
            result = dialog.get_result()
            
        dialog.destroy()
        
        # 
        if result:
            # modify the event
            self.modev.SUMMARY=result[0]
            self.modev.LOCATION=result[1]
            self.modev.DESCRIPTION=result[2]
            self.modev.DTSTART=result[3]
            self.modev.DTEND=result[4]
            # reload the calendar
            ddate = self.modev.DTSTART.split("T")[0]
            dyear = int(ddate[0:4])
            dmonth = int(ddate[4:6])
            dday = int(ddate[6:8])
            # reload and change everything in the calendar
            self.dateServiceFun(datetime.date(dyear, dmonth, dday))
            
            # the calendar has been changed
            self.calendar_has_been_changed = 1
    
    
    # delete an event
    def deleteEvent(self, w):
        #
        summary=self.modev.SUMMARY
        location=self.modev.LOCATION
        description=self.modev.DESCRIPTION
        sdateT,stimeT=self.modev.DTSTART.split("T")
        smonth = TMONTSH[int(sdateT[4:6])-1]
        sdate="{} {} {} at {}:{}".format(sdateT[0:4],smonth,sdateT[6:8],stimeT[0:2],stimeT[2:4])
        edateT,etimeT=self.modev.DTEND.split("T")
        emonth = TMONTSH[int(edateT[4:6])-1]
        edate="{} {} {} at {}:{}".format(edateT[0:4],emonth,edateT[6:8],etimeT[0:2],etimeT[2:4])
        
        dialog = DialogYN(self, " Delete? ", "\n Summary: {}\n Location: {}\n Description: {}\n Start: {} \n End: {} \n".format(summary,location,description.replace("\\n", "\n"),sdate,edate))
        response = dialog.run()

        if response == Gtk.ResponseType.OK:
            #
            evidx = self.list_events.index(self.modev)
            ddate = self.list_events[evidx].DTSTART.split("T")[0]
            dyear = int(ddate[0:4])
            dmonth = int(ddate[4:6])
            dday = int(ddate[6:8])
            
            self.list_events.remove(self.modev)
            
            # reload and change everything in the calendar
            self.dateServiceFun(datetime.date(dyear, dmonth, dday))
            
            # the calendar has been changed
            self.calendar_has_been_changed = 1
            
        dialog.destroy()
    
    
    # contextual menu
    def event_context_menu(self):
        self.menu = Gtk.Menu.new()
        self.itemv = Gtk.MenuItem.new_with_label("View")
        self.itemv.connect("activate", self.viewEvent)
        self.menu.append(self.itemv)
        self.itema = Gtk.MenuItem.new_with_label("Modify")
        self.itema.connect("activate", self.modifyEvent)
        self.menu.append(self.itema)
        self.itemb = Gtk.MenuItem.new_with_label("Delete")
        self.itemb.connect("activate", self.deleteEvent)
        self.menu.append(self.itemb)
        self.menu.show_all()
    
    
    # event in the right
    def eventLabel(self, w, e):
        
        if e.type == Gdk.EventType.BUTTON_PRESS and e.button == 3:
        
            self.modev = w.evnt
            self.modwidgt = w
            self.menu.popup_at_pointer()
        #
        elif e.type == Gdk.EventType.BUTTON_PRESS and e.button == 1:
            
            self.modwidgt = w
            btmlabel = Gtk.Label(label=None)
            btmlabel.set_markup(w.get_tooltip_markup())
            btmlabel.set_xalign(0.1)
            btmlabel.set_yalign(0.1)
            btmlabel.set_max_width_chars(RIGHT_BOX_EVENT)
            btmlabel.set_line_wrap(True)
            self.empty_bframe()
            self.bframe.add(btmlabel)
            self.bframe.show_all()
        #
        elif e.type == Gdk.EventType.DOUBLE_BUTTON_PRESS and e.button == 1:
            self.modev = w.evnt
            dialog = viewEventClass(self, "View this event", None, self.modev)
            response = dialog.run()
            
            result = None

            if response == Gtk.ResponseType.OK:
                dialog.destroy()
            
            dialog.destroy()
    
    
    # add a new event
    def on_cal_clicked(self, w):
        
        caldata = [self.selected_year, self.selected_month-1, self.selected_day]
        dialog = addEvent(self, "Add a new event", None, caldata)
        response = dialog.run()

        if response == Gtk.ResponseType.OK:
            result = dialog.get_result()
            # add to the events list
            s_event = sEvent()
            s_event.SUMMARY = result[0]
            s_event.DTSTART = result[3]
            s_event.DTEND = result[4]
            s_event.LOCATION = result[1]
            s_event.DESCRIPTION = result[2]
            
            temp_ev_data = 0
            temp_ev_starttime = 0
            temp_ev_endtime = 0
            
            # 
            len_list = len(self.list_events)
            
            if len_list > 0:
                
                len_l = len(self.list_events)
                for i in reversed(range(len_l)):
                    newdata, newtime = result[3].split("T")
                    olddata, oldtime = self.list_events[i].DTSTART.split("T")
                    newdata2, newtime2 = result[4].split("T")
                    olddata2, oldtime2 = self.list_events[i].DTEND.split("T")
                    #############
                    #
                    if int(newdata) == int(olddata):
                        if i > 0:
                            if int(newtime) < int(oldtime):
                                continue
                            elif int(newtime) == int(oldtime):
                                olddatap, oldtimep = self.list_events[i-1].DTSTART.split("T")
                                if int(newtime) > int(oldtimep):
                                    continue
                                else:
                                    temp_ev_data = i
                                    break
                                
                            elif int(newtime) > int(oldtime):
                                temp_ev_data = i + 1
                                break
                        #
                        else:
                            if int(newtime) > int(oldtime):
                                temp_ev_data = 1
                            else:
                                if int(newtime2) < int(oldtime2):
                                    temp_ev_data = 0
                                else:
                                    temp_ev_data = 1
                    #
                    elif int(newdata) > int(olddata):
                        temp_ev_data = len_list - i
                    #
                    elif int(newdata) < int(olddata):
                        if i > 0:
                            continue
                        else:
                            temp_ev_data = i
                #
                self.list_events.insert(temp_ev_data, s_event)
            #
            else:
                self.list_events.append(s_event)
            
            # populate the month view
            ddate = s_event.DTSTART.split("T")[0]
            dyear = int(ddate[0:4])
            dmonth = int(ddate[4:6])
            dday = int(ddate[6:8])
            
            # reload and change everything in the calendar
            self.dateServiceFun(datetime.date(dyear, dmonth, dday))
            
            # the calendar has been changed
            self.calendar_has_been_changed = 1
        
        dialog.destroy()


# dialog : view the event
class viewEventClass(Gtk.Dialog):
    def __init__(self, parent, title, info, data):
        Gtk.Dialog.__init__(self, title=title, transient_for=parent, flags=0)
        self.add_buttons(Gtk.STOCK_OK, Gtk.ResponseType.OK)

        self.set_default_size(500, 100)
        # the event
        self.data = data
        #
        
        box = self.get_content_area()
        
        #
        lsummary = Gtk.Label(label="Summary")
        box.add(lsummary)
        self.summary = Gtk.Entry()
        self.summary.set_text(self.data.SUMMARY)
        box.add(self.summary)
        
        #
        llocation = Gtk.Label(label="Location")
        box.add(llocation)
        self.location = Gtk.Entry()
        self.location.set_text(self.data.LOCATION)
        box.add(self.location)
        
        #
        ldescription = Gtk.Label(label="Description")
        box.add(ldescription)
        self.description = Gtk.TextView()
        buffer = self.description.get_buffer()
        buffer.set_text(str(self.data.DESCRIPTION.replace("\\n","\n")))
        box.add(self.description)
        
        # box for date and time
        dtbox = Gtk.Box(orientation=0)
        
        ## date and time
        # start
        sframe = Gtk.Frame(label=" Date and Time ")
        box.add(sframe)
        sframe.add(dtbox)
        
        # calendar start
        self.scalendar = Gtk.Calendar()
        self.scalendar.set_tooltip_text("Start")
        # date and time
        sdate, stime = self.data.DTSTART.split("T")
        self.scalendar.select_month(int(sdate[4:6])-1, int(sdate[0:4]))
        self.scalendar.select_day(int(sdate[6:8]))
        #
        lstext = "{}{}{}".format(self.scalendar.get_date().year, self.scalendar.get_date().month, self.scalendar.get_date().day)
        dtbox.add(self.scalendar)
        
        # hours
        scb_store = Gtk.ListStore(str)
        for i in range(0, 24, 1):
            scb_store.append(["{:02d}".format(i)])
        self.scb = Gtk.ComboBox.new_with_model(scb_store)
        self.scb.set_tooltip_text("Hours")
        renderer_text = Gtk.CellRendererText()
        self.scb.pack_start(renderer_text, True)
        self.scb.add_attribute(renderer_text, "text", 0)
        hins = int(stime[0:2])
        self.scb.set_active(int(hins))
        dtbox.add(self.scb)
        
        #minutes
        scbm_store = Gtk.ListStore(str)
        for i in range(0, 60, 5):
            scbm_store.append(["{:02d}".format(i)])
        self.scbm = Gtk.ComboBox.new_with_model(scbm_store)
        self.scbm.set_tooltip_text("Minutes")
        renderer_text = Gtk.CellRendererText()
        self.scbm.pack_start(renderer_text, True)
        self.scbm.add_attribute(renderer_text, "text", 0)
        mins = int(stime[2:4]) / 5
        self.scbm.set_active(int(mins))
        dtbox.add(self.scbm)
        
        # separator
        tstext = Gtk.Label(label="  ")
        dtbox.add(tstext)
        
        # calendar end
        self.ecalendar = Gtk.Calendar()
        self.ecalendar.set_tooltip_text("Finish")
        # date and time
        edate, etime = self.data.DTEND.split("T")
        self.ecalendar.select_month(int(edate[4:6])-1, int(edate[0:4]))
        self.ecalendar.select_day(int(edate[6:8]))
        #
        letext = "{}{}{}".format(self.ecalendar.get_date().year, self.ecalendar.get_date().month, self.ecalendar.get_date().day)
        dtbox.add(self.ecalendar)
        
        # hours
        ecb_store = Gtk.ListStore(str)
        for i in range(0, 24, 1):
            ecb_store.append(["{:02d}".format(i)])
        self.ecb = Gtk.ComboBox.new_with_model(ecb_store)
        self.ecb.set_tooltip_text("Hour")
        renderer_text = Gtk.CellRendererText()
        self.ecb.pack_start(renderer_text, True)
        self.ecb.add_attribute(renderer_text, "text", 0)
        hine = int(etime[0:2])
        self.ecb.set_active(int(hine))
        dtbox.add(self.ecb)
        
        #minutes
        ecbm_store = Gtk.ListStore(str)
        for i in range(0, 60, 5):
            ecbm_store.append(["{:02d}".format(i)])
        self.ecbm = Gtk.ComboBox.new_with_model(ecbm_store)
        self.ecbm.set_tooltip_text("Minutes")
        renderer_text = Gtk.CellRendererText()
        self.ecbm.pack_start(renderer_text, True)
        self.ecbm.add_attribute(renderer_text, "text", 0)
        mine = int(etime[2:4]) / 5
        self.ecbm.set_active(int(mine))
        dtbox.add(self.ecbm)
        
        #
        self.summary.set_editable(False)
        self.location.set_editable(False)
        self.description.set_editable(False)
        self.scb.set_sensitive(False)
        self.scbm.set_sensitive(False)
        self.scalendar.set_sensitive(False)
        self.ecalendar.set_sensitive(False)
        self.ecb.set_sensitive(False)
        self.ecbm.set_sensitive(False)
        ##
        self.show_all()


# dialog : modify an event
class modifyEventClass(Gtk.Dialog):
    def __init__(self, parent, title, info, data):
        Gtk.Dialog.__init__(self, title=title, transient_for=parent, flags=0)
        self.add_buttons(
            Gtk.STOCK_CANCEL, Gtk.ResponseType.CANCEL, Gtk.STOCK_OK, Gtk.ResponseType.OK
        )

        self.set_default_size(500, 100)
        # the event to modify
        self.data = data
        
        # the returning value
        self.value = None
        
        #
        self.connect("response", self.on_response)

        box = self.get_content_area()
        
        #
        lsummary = Gtk.Label(label="Summary")
        box.add(lsummary)
        self.summary = Gtk.Entry()
        self.summary.set_text(self.data.SUMMARY)
        box.add(self.summary)
        
        #
        llocation = Gtk.Label(label="Location")
        box.add(llocation)
        self.location = Gtk.Entry()
        self.location.set_text(self.data.LOCATION)
        box.add(self.location)
        
        #
        ldescription = Gtk.Label(label="Description")
        box.add(ldescription)
        self.description = Gtk.TextView()
        buffer = self.description.get_buffer()
        buffer.set_text(str(self.data.DESCRIPTION.replace("\\n","\n")))
        box.add(self.description)
        
        # box for date and time
        dtbox = Gtk.Box(orientation=0)
        
        
        ## date and time
        # start
        sframe = Gtk.Frame(label=" Date and Time ")
        box.add(sframe)
        #sbox = Gtk.Box(orientation=0)
        sframe.add(dtbox)
        
        # calendar start
        self.scalendar = Gtk.Calendar()
        self.scalendar.set_tooltip_text("Start")
        sdate, stime = self.data.DTSTART.split("T")
        self.scalendar.select_month(int(sdate[4:6])-1, int(sdate[0:4]))
        self.scalendar.select_day(int(sdate[6:8]))
        #
        lstext = "{}{}{}".format(self.scalendar.get_date().year, self.scalendar.get_date().month, self.scalendar.get_date().day)
        dtbox.add(self.scalendar)
        
        # hours
        scb_store = Gtk.ListStore(str)
        for i in range(0, 24, 1):
            scb_store.append(["{:02d}".format(i)])
        self.scb = Gtk.ComboBox.new_with_model(scb_store)
        self.scb.set_tooltip_text("Hours")
        renderer_text = Gtk.CellRendererText()
        self.scb.pack_start(renderer_text, True)
        self.scb.add_attribute(renderer_text, "text", 0)
        hins = int(stime[0:2])
        self.scb.set_active(int(hins))
        dtbox.add(self.scb)
        
        #minutes
        scbm_store = Gtk.ListStore(str)
        for i in range(0, 60, 5):
            scbm_store.append(["{:02d}".format(i)])
        self.scbm = Gtk.ComboBox.new_with_model(scbm_store)
        self.scbm.set_tooltip_text("Minutes")
        renderer_text = Gtk.CellRendererText()
        self.scbm.pack_start(renderer_text, True)
        self.scbm.add_attribute(renderer_text, "text", 0)
        mins = int(stime[2:4]) / 5
        self.scbm.set_active(int(mins))
        dtbox.add(self.scbm)
        
        # separator
        tstext = Gtk.Label(label="  ")
        dtbox.add(tstext)
        
        # calendar end
        self.ecalendar = Gtk.Calendar()
        self.ecalendar.set_tooltip_text("Finish")
        # date and time
        edate, etime = self.data.DTEND.split("T")
        self.ecalendar.select_month(int(edate[4:6])-1, int(edate[0:4]))
        self.ecalendar.select_day(int(edate[6:8]))
        #
        letext = "{}{}{}".format(self.ecalendar.get_date().year, self.ecalendar.get_date().month, self.ecalendar.get_date().day)
        dtbox.add(self.ecalendar)
        
        # hours
        ecb_store = Gtk.ListStore(str)
        for i in range(0, 24, 1):
            ecb_store.append(["{:02d}".format(i)])
        self.ecb = Gtk.ComboBox.new_with_model(ecb_store)
        self.ecb.set_tooltip_text("Hour")
        renderer_text = Gtk.CellRendererText()
        self.ecb.pack_start(renderer_text, True)
        self.ecb.add_attribute(renderer_text, "text", 0)
        hine = int(etime[0:2])
        self.ecb.set_active(int(hine))
        dtbox.add(self.ecb)
        
        #minutes
        ecbm_store = Gtk.ListStore(str)
        for i in range(0, 60, 5):
            ecbm_store.append(["{:02d}".format(i)])
        
        self.ecbm = Gtk.ComboBox.new_with_model(ecbm_store)
        self.ecbm.set_tooltip_text("Minutes")
        renderer_text = Gtk.CellRendererText()
        self.ecbm.pack_start(renderer_text, True)
        self.ecbm.add_attribute(renderer_text, "text", 0)
        mine = int(etime[2:4]) / 5
        self.ecbm.set_active(int(mine))
        dtbox.add(self.ecbm)
        
        ##
        self.show_all()
        
    #
    def on_response(self, widget, response_id):
        self.value = []
        # summary
        if self.summary.get_text().strip() == "":
            self.value.append("Summary")
        else:
            self.value.append(self.summary.get_text())
        # location
        self.value.append(self.location.get_text())
        # description
        buffer = self.description.get_buffer()
        startIter, endIter = buffer.get_bounds()    
        text = buffer.get_text(startIter, endIter, False).replace("\n","\\n")
        self.value.append(text)
        # calendar date - start
        lstext = "{}{:02d}{:02d}".format(self.scalendar.get_date().year, self.scalendar.get_date().month+1, self.scalendar.get_date().day)
        # hours and minutes - start
        cbindex = self.scb.get_active() 
        cbtext = self.scb.get_model()[cbindex][0]
        cbmindex = self.scbm.get_active() 
        cbmtext = self.scbm.get_model()[cbmindex][0]
        self.value.append(lstext+"T"+cbtext+cbmtext+"00")
        # calendar date - end
        letext = "{}{:02d}{:02d}".format(self.ecalendar.get_date().year, self.ecalendar.get_date().month+1, self.ecalendar.get_date().day)
        #
        if int(letext) < int(lstext):
            letext = lstext
        # hours and minutes - end
        cb2index = self.ecb.get_active() 
        cb2text = self.ecb.get_model()[cb2index][0]
        #
        if int(letext) == int(lstext):
            if int(cb2text) < int(cbtext):
                cb2text = cbtext
        cbm2index = self.ecbm.get_active()
        cbm2text = self.ecbm.get_model()[cbm2index][0]
        #
        if int(letext) == int(lstext):
            if int(cbm2text) < int(cbmtext):
                cbm2text = str(int(cbmtext) + 15)
        self.value.append(letext+"T"+cb2text+cbm2text+"00")
    
    #
    def get_result(self):
        return self.value


# dialog for adding a new event
class addEvent(Gtk.Dialog):
    def __init__(self, parent, title, info, caldata):
        Gtk.Dialog.__init__(self, title=title, transient_for=parent, flags=0)
        self.add_buttons(
            Gtk.STOCK_CANCEL, Gtk.ResponseType.CANCEL, Gtk.STOCK_OK, Gtk.ResponseType.OK
        )

        self.set_default_size(500, 100)
        # [year, month, day]
        self.caldata = caldata
        
        self.today = datetime.datetime.today()
        
        day_data = [self.today.year, self.today.month-1, self.today.day]
        # is today - 0 no 1 yes
        self.is_today = 0
        if day_data == self.caldata:
            self.is_today = 1
        
        # the returning value
        self.value = None
        
        #
        self.connect("response", self.on_response)

        box = self.get_content_area()
        
        #
        lsummary = Gtk.Label(label="Summary")
        box.add(lsummary)
        self.summary = Gtk.Entry()
        box.add(self.summary)
        
        #
        llocation = Gtk.Label(label="Location")
        box.add(llocation)
        self.location = Gtk.Entry()
        box.add(self.location)
        
        #
        ldescription = Gtk.Label(label="Description")
        box.add(ldescription)
        self.description = Gtk.TextView()
        box.add(self.description)
        
        # box for date and time
        dtbox = Gtk.Box(orientation=0)
        
        
        ## date and time
        # start
        sframe = Gtk.Frame(label=" Date and Time ")
        box.add(sframe)
        sframe.add(dtbox)
        
        # calendar start
        self.scalendar = Gtk.Calendar()
        self.scalendar.set_tooltip_text("Start")
        self.scalendar.select_day(self.caldata[2])
        self.scalendar.select_month(self.caldata[1], self.caldata[0])
        lstext = "{}{}{}".format(self.scalendar.get_date().year, self.scalendar.get_date().month, self.scalendar.get_date().day)
        dtbox.add(self.scalendar)
        
        # hours
        scb_store = Gtk.ListStore(str)
        for i in range(0, 24, 1):
            scb_store.append(["{:02d}".format(i)])
        self.scb = Gtk.ComboBox.new_with_model(scb_store)
        self.scb.set_tooltip_text("Hours")
        renderer_text = Gtk.CellRendererText()
        self.scb.pack_start(renderer_text, True)
        self.scb.add_attribute(renderer_text, "text", 0)
        #
        if self.is_today:
            hins = self.today.hour
            self.scb.set_active(int(hins))
        else:
            self.scb.set_active(8)
        
        dtbox.add(self.scb)
        
        #minutes
        scbm_store = Gtk.ListStore(str)
        for i in range(0, 60, 5):
            scbm_store.append(["{:02d}".format(i)])
        self.scbm = Gtk.ComboBox.new_with_model(scbm_store)
        self.scbm.set_tooltip_text("Minutes")
        renderer_text = Gtk.CellRendererText()
        self.scbm.pack_start(renderer_text, True)
        self.scbm.add_attribute(renderer_text, "text", 0)
        
        if self.is_today:
            rounded_min = int(self.today.minute) - int(self.today.minute) % 5
            mins = rounded_min / 5
            self.scbm.set_active(mins)
        else:
            self.scbm.set_active(0)
        
        dtbox.add(self.scbm)
        
        # separator
        tstext = Gtk.Label(label="  ")
        dtbox.add(tstext)
        
        # calendar end
        self.ecalendar = Gtk.Calendar()
        self.ecalendar.set_tooltip_text("Finish")
        self.ecalendar.select_day(self.caldata[2])
        self.ecalendar.select_month(self.caldata[1], self.caldata[0])
        letext = "{}{}{}".format(self.ecalendar.get_date().year, self.ecalendar.get_date().month, self.ecalendar.get_date().day)
        dtbox.add(self.ecalendar)
        
        # hours
        ecb_store = Gtk.ListStore(str)
        for i in range(0, 24, 1):
            ecb_store.append(["{:02d}".format(i)])
        self.ecb = Gtk.ComboBox.new_with_model(ecb_store)
        self.ecb.set_tooltip_text("Hour")
        renderer_text = Gtk.CellRendererText()
        self.ecb.pack_start(renderer_text, True)
        self.ecb.add_attribute(renderer_text, "text", 0)
        
        if self.is_today:
            hine = self.today.hour
            self.ecb.set_active(int(hins))
        else:
            self.ecb.set_active(8)
        
        dtbox.add(self.ecb)
        
        #minutes
        ecbm_store = Gtk.ListStore(str)
        for i in range(0, 60, 5):
            ecbm_store.append(["{:02d}".format(i)])
        self.ecbm = Gtk.ComboBox.new_with_model(ecbm_store)
        self.ecbm.set_tooltip_text("Minutes")
        renderer_text = Gtk.CellRendererText()
        self.ecbm.pack_start(renderer_text, True)
        self.ecbm.add_attribute(renderer_text, "text", 0)
        
        if self.is_today:
            rounded_min = int(self.today.minute) - int(self.today.minute) % 5
            mins = rounded_min / 5
            self.ecbm.set_active(mins)
        else:
            self.ecbm.set_active(0)
        
        dtbox.add(self.ecbm)
        
        #
        self.show_all()
        
    #
    def on_response(self, widget, response_id):
        
        self.value = []
        # summary
        if self.summary.get_text().strip() == "":
            self.value.append("Summary")
        else:
            self.value.append(self.summary.get_text())
        # location
        self.value.append(self.location.get_text())
        # description
        buffer = self.description.get_buffer()
        startIter, endIter = buffer.get_bounds()    
        text = buffer.get_text(startIter, endIter, False).replace("\n","\\n")
        self.value.append(text)
        # calendar date - start
        lstext = "{}{:02d}{:02d}".format(self.scalendar.get_date().year, self.scalendar.get_date().month+1, self.scalendar.get_date().day)
        # hours and minutes - start
        cbindex = self.scb.get_active() 
        cbtext = self.scb.get_model()[cbindex][0]
        cbmindex = self.scbm.get_active() 
        cbmtext = self.scbm.get_model()[cbmindex][0]
        self.value.append(lstext+"T"+cbtext+cbmtext+"00")
        # calendar date - end
        letext = "{}{:02d}{:02d}".format(self.ecalendar.get_date().year, self.ecalendar.get_date().month+1, self.ecalendar.get_date().day)
        #
        if int(letext) < int(lstext):
            letext = lstext
        # hours and minutes - end
        cb2index = self.ecb.get_active() 
        cb2text = self.ecb.get_model()[cb2index][0]
        #
        if int(letext) == int(lstext):
            if int(cb2text) < int(cbtext):
                cb2text = cbtext
        cbm2index = self.ecbm.get_active()
        cbm2text = self.ecbm.get_model()[cbm2index][0]
        #
        if int(letext) == int(lstext):
            if int(cbm2text) < int(cbmtext):
                cbm2text = str(int(cbmtext) + 15)
        self.value.append(letext+"T"+cb2text+cbm2text+"00")
    
    #
    def get_result(self):
        return self.value
    


# dialog
class DialogYN(Gtk.Dialog):
    def __init__(self, parent, title, info):
        Gtk.Dialog.__init__(self, title=title, transient_for=parent, flags=0)
        self.add_buttons(
            Gtk.STOCK_CANCEL, Gtk.ResponseType.CANCEL, Gtk.STOCK_OK, Gtk.ResponseType.OK
        )

        self.set_default_size(150, 100)

        label = Gtk.Label(label=info)

        box = self.get_content_area()
        box.add(label)
        self.show_all()


if __name__ == "__main__":
    win = MainWindow()
    win.show_all()
    Gtk.main()
