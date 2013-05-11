{{
         "hypnoray"
        a meditator

       ,aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
      d'                                                                    8
    ,P'                                                                     8
  ,dbaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa        8
  8                                                              d"8        8
  8                                                             d' 8        8
  8        aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaad'  8        8
  8        8   8                                               8   8        8
  8        8   8                                               8   8        8
  8        8  ,8aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa8aaa8        8
  8        8 ,P                                                             8
  8        8,P                                                              8
  8        8baaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaad'
  8                                                                       d'
  8                                                                      d'
  8aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaP'
                       (ascii art by Normand Veilleux)
6:17 5/11/2013 
}}

CON
  _xinfreq = 5_000_000
  _clkmode = xtal1 + pll16x

  'timing
 ' ONE_QUARTER_SECOND = 20_000_000

  'pins
  led_pin = 10
  status_pin = 11
  heart_pin = 3
  smooth_operator = 3 'the max index

  INPUT         = false         'bit pattern is all 0s
  OUTPUT        = true          'bit pattern is all 1s
  
  'LED Bar graph pin definitions
  BAR_GRAPH_0   = 0
  BAR_GRAPH_1   = 1
  BAR_GRAPH_2   = 2
  BAR_GRAPH_3   = 3
  BAR_GRAPH_4   = 4
  BAR_GRAPH_5   = 5
  BAR_GRAPH_6   = 6
  BAR_GRAPH_7   = 7
  BAR_GRAPH_8   = 8
  BAR_GRAPH_9   = 9

  Direction_Magic_Number = 3
  
'Verbalizers ***********************************************
'*** Key States ***
     'greater than 3 is the count within the debounce range 
        'DEBOUNCE= 100_000
        TRIGGER = 3
        SUSTAIN = 2
        RELEASE = 1
        SILENCE = 0
'*** mode *****************************************************
        DO_NOTHING = 0
        PLAY_PHONEMES = 1 
        RECORD_PHONEMES = 2
        PLAY_ALLOPHONES = 3
        RECORD_ALLOPHONES = 4
        PLAY_WORDS = 5
        RECORD_WORDS = 6
        MODE_S1 = 27
        MODE_S2 = 28

                  
VAR
  Long is_reset
  Long log_count
  Long log_status
  Long smoothness[smooth_operator + 1] 'for 0 to smooth_operator indexing
  Long smooth_operator_iterator
  Long logging
  Long pressure
  Long cogStack[20]
  Long Direction_Breathing_in
  Long Direction_Previous_in
  Long Direction_Previous_reading
  Long Direction_Progress_Count
  Long Direction_Bar_Level
  
  'Verbalizers *********************************************** 
  LONG Key_State[40]'each of 37 keys' Key States(TRIGGER, SUSTAIN, RELEASE, or SILENCE), but for iterating cols x rows I use 40
  BYTE The_Mode
  LONG ADC_Stack[20]'stack space allotment
  LONG Settings_Stack[20]'stack space allotment   
  BYTE Pot[19]
  BYTE serial_progress
  LONG serial_started
  'using it
  LONG Keys_pressed_status

  'timing
  LONG main_loops_count
  LONG quarter_second_increments
  LONG cnt_to_quarter_second
        
OBJ
  system : "Propeller Board of Education"
  sd     : "PropBOE MicroSD"
  'pst    : "Parallax Serial Terminal Plus"
  time   : "Timing"
  adc    : "PropBOE ADC"
  
  Verbalizations   :   "VerbalizeIt"
          
PRI init | i, the_key
  '###########################################
  '### set to TRUE to write to the SD card ###
  logging := FALSE
  '###########################################
  
  'system variables, don't touch
  system.Clock(80_000_000)
  log_status := FALSE
  log_count := 0
  is_reset := TRUE
  
  dira[led_pin] := 1
  dira[status_pin] := 1
  dira[heart_pin] := 0
  outa[heart_pin] := 1

  dira[BAR_GRAPH_9..BAR_GRAPH_0] := OUTPUT
  
  'initialize the smoothing array
  repeat i from 0 to smooth_operator
    smoothness[i] := adc.In(0)

  Set_Verbalizer_Pots
  The_Mode := PLAY_ALLOPHONES
  'The_Mode := PLAY_WORDS
  'The_Mode := PLAY_ALLOPHONES'phones
  'The_Mode := PLAY_PHONEMES
  Keys_pressed_status := FALSE

  repeat the_key from 0 to 38
    Key_State[the_key] := SILENCE
    
   'settings.start       
  Verbalizations.start(@Pot)
  
  'timing
  main_loops_count := 0
  quarter_second_increments := 0
  cnt_to_quarter_second := cnt
<<<<<<< HEAD
  'test_the_timer
=======
  test_the_timer
>>>>>>> 7adb0e53a701fc1bce5561889fe9ef0ba5cf5835
  cosmic_orchestral_beat

'PRI Quart_Second_Increment_Updater
'
'  if cnt > ONE_QUARTER_SECOND + cnt_to_quarter_second
'    
'    cnt_to_quarter_second := cnt
'    quarter_second_increments++

'PRI test_the_timer

'  repeat 4
    
'    status_on
    
'    repeat until quarter_second_increments > 3
     
'      Quart_Second_Increment_Updater

'    quarter_second_increments := 0  
'    status_off
    
'    repeat until quarter_second_increments > 3
     
<<<<<<< HEAD

    'Quart_Second_Increment_Updater
=======
<<<<<<< HEAD
'      Quart_Second_Increment_Updater
'    quarter_second_increments := 0
=======
      Quart_Second_Increment_Updater
>>>>>>> 7adb0e53a701fc1bce5561889fe9ef0ba5cf5835
    quarter_second_increments := 0
>>>>>>> parent of ed1e3f0... and better
           
PRI Set_Verbalizer_Pots
  
  Pot[0] := 16
  Pot[1] := 255
  Pot[2] := 64
  Pot[3] := 47
  Pot[4] := 122
  Pot[5] := 25
  Pot[6] := 88
  Pot[7] := 12
  Pot[8] := 23
  Pot[9] := 57
  Pot[10] := 61
  Pot[11] := 123
  Pot[12] := 1   'echo
  Pot[13] := 2
  Pot[14] := 136
  Pot[15] := 51
  Pot[16] := 7
  Pot[17] := 6
  Pot[18] := 4
  'Pot[19] := 0

PRI Verbalizer_Loop | the_key

        '******************************************************************
        Update_Keys
        
        case The_Mode
                                                
          PLAY_PHONEMES :
                                 repeat the_key from 1 to 37         
                                     if (Key_State[the_key] == RELEASE)'caught a release
                                         if Verbalizations.release_test(the_key)'if this one is stopping, then advance to SILENCE  
                                             Key_State[the_key] := SILENCE  'advance to silence
                                                      
                                 repeat the_key from 1 to 37                      
                                     if ((Key_State[the_key] == TRIGGER) OR (Key_State[the_key] == SUSTAIN))'caught a trigger
                                         if Verbalizations.go_test(the_key)
                                                        Key_State[the_key] := SUSTAIN
                                                   
          
          PLAY_ALLOPHONES : 'PLAY_ALLOPHONES = 3                      
                                repeat the_key from 1 to 37         
                                     if (Key_State[the_key] == RELEASE)'caught a release
                                         if Verbalizations.stop_if_available(the_key)'if this one is stopping, then advance to SILENCE  
                                             Key_State[the_key] := SILENCE  'advance to silence
                                 
                                repeat the_key from 1 to 37
                                     if (Key_State[the_key] == SUSTAIN)
                                        Verbalizations.go_sustain(the_key)
                                        
                                repeat the_key from 1 to 37       
                                     if (Key_State[the_key] == TRIGGER)'caught a trigger                 
                                         if Verbalizations.go_if_available(the_key)'if this one starts a voice, then advance to SUSTAIN
                                             Key_State[the_key] := SUSTAIN  'advance to sustain

          PLAY_WORDS : 'PLAY_WORDS
                                repeat the_key from 1 to 37         
                                     if (Key_State[the_key] == RELEASE)'caught a release
                                         if Verbalizations.release_word(the_key)'if this one is stopping, then advance to SILENCE  
                                             Key_State[the_key] := SILENCE  'advance to silence
                                 
                                repeat the_key from 1 to 37
                                     if (Key_State[the_key] == SUSTAIN)
                                        Verbalizations.sustain_word(the_key)
                                        
                                repeat the_key from 1 to 37       
                                     if (Key_State[the_key] == TRIGGER)'caught a trigger                 
                                         if Verbalizations.trigger_word(the_key)'if this one starts a voice, then advance to SUSTAIN
                                             Key_State[the_key] := SUSTAIN  'advance to sustain

                                             
          RECORD_WORDS : 'RECORD_WORDS = 4
                                 repeat the_key from 1 to 37                      
                                     if (Key_State[the_key] == TRIGGER)'caught a trigger
                                         Verbalizations.go_test(the_key)
          OTHER :
             'do nothing
             Verbalizations.release_test(1)
        
   
PRI Direction_Update
  ' Direction_Previous_reading

  if pressure == Direction_Previous_reading
    return

  if pressure > Direction_Previous_reading
    Direction_Breathing_in := TRUE
    
  if pressure < Direction_Previous_reading
    Direction_Breathing_in := FALSE

  'check if we are continuing in the same direction as last time
  if Direction_Breathing_in == Direction_Previous_in
  
    if Direction_Increment_Progress_t 'if Direction_Magic_Number threshold is met 
      if Direction_Breathing_in 'are we breathing in or breathing out?
      
        breathing_in
        
      else
      
        breathing_out
        
  else
    Direction_Decrement_Progress
    
  Direction_Previous_reading := pressure
  Direction_Previous_in := Direction_Breathing_in

PRI Keys_Pressed
  Keys_pressed_status := TRUE  
  'Update_Keys
  
PRI Keys_Released
  Keys_pressed_status := FALSE  
  'Update_Keys
  
PRI Update_Keys
  if Keys_pressed_status
    Update_this_Keys_State(13, TRUE)
    Update_this_Keys_State(25, TRUE)
  else
    Update_this_Keys_State(13, FALSE)
    Update_this_Keys_State(25, FALSE)        

PRI Update_this_Keys_State(the_key, is_pressed) | the_count_now

  if (is_pressed == TRUE)
    if (Key_State[the_key] <> SUSTAIN)
       Key_State[the_key] := TRIGGER
  else
    if (Key_State[the_key] == SUSTAIN)
       Key_State[the_key] := RELEASE
    else
       Key_State[the_key] := SILENCE 

PRI Direction_Decrement_Progress

  Direction_Progress_Count := Direction_Progress_Count - 1
  
  if Direction_Progress_Count < 0
    Direction_Progress_Count := 0

PRI Direction_Increment_Progress_t
  Direction_Progress_Count := Direction_Progress_Count + 1
  
  if Direction_Progress_Count > Direction_Magic_Number
    Direction_Progress_Count := Direction_Magic_Number
    
    return TRUE
  else
    return FALSE
        
PRI breathing_in
  Direction_Bar_Level := Direction_Bar_Level + 1
  
  if Direction_Bar_Level > 10
    Direction_Bar_Level := 10
  Set_the_bar(Direction_Bar_Level)

  'Update_this_Keys_State(the_key, is_pressed)
  Keys_Released
  

PRI breathing_out
  Direction_Bar_Level := Direction_Bar_Level - 1
  
  if Direction_Bar_Level < 1
    Direction_Bar_Level := 1
  Set_the_bar(Direction_Bar_Level)

<<<<<<< HEAD

  Pot[2] := Direction_Bar_Level + 2
  Pot[7] := Direction_Bar_Level + 2
   

  main_loops_count := 0

=======
<<<<<<< HEAD
  Pot[2] := Direction_Bar_Level + 2
  Pot[7] := Direction_Bar_Level + 2
   
  
=======
  main_loops_count := 0
>>>>>>> parent of ed1e3f0... and better
>>>>>>> 7adb0e53a701fc1bce5561889fe9ef0ba5cf5835
  Keys_Pressed
  
  
PRI Set_the_bar(theLevel)

  'set LED bar to equal Direction_Bar_Level
   outa[BAR_GRAPH_9..BAR_GRAPH_0] := 1<<theLevel-1   

    
PRI cosmic_orchestral_beat | timer
  {
  blinkity blink blinker
  }

    timer := 100
    {
    repeat 4
      status_on
      led_off
      time.Pause(timer)
      status_off
      led_on
      time.Pause(timer*4)
     }
    
  '  repeat 4
  '    status_off
  '    led_on
  '    SaySomething
  '    time.Pause(timer)
  '    status_on
  '    led_off
  '    time.Pause(timer*2)
  '    status_off
  '    led_off
  '    Keys_Pressed
  '    Verbalizer_Loop
  '    time.Pause(timer*4)
     
    repeat 4
      status_on
      led_off
      time.Pause(timer)
      status_off
      led_on
      Keys_Pressed
      Verbalizer_Loop
      time.Pause(timer*2)
      Verbalizer_Loop
      time.Pause(timer*2)
      status_off
      led_off
      Keys_Released
      Verbalizer_Loop 
      time.Pause(timer*4)
      Verbalizer_Loop
     
    led_off
    status_off

PRI SaySomething  | timer
      timer := 100
      
      Update_this_Keys_State(3, TRUE)
      Verbalizer_Loop
      time.Pause(timer)

      Update_this_Keys_State(3, TRUE)
      Verbalizer_Loop
      time.Pause(timer)

      Update_this_Keys_State(3, FALSE)
      Verbalizer_Loop
      time.Pause(timer)

      Update_this_Keys_State(3, FALSE)
      Verbalizer_Loop
      time.Pause(timer)
<<<<<<< HEAD

=======
>>>>>>> 7adb0e53a701fc1bce5561889fe9ef0ba5cf5835

<<<<<<< HEAD
=======
  init
  logging_toggler := FALSE
    
    repeat 'THE MAIN LOOP ################################
    
      'check if logging button is pressed
      if logging_toggler
        'if logging is false(off) turn it true(on) and visa versa
        if logging
          CloseFile
          logging := FALSE
          log_count++
        else
          logging := TRUE
          OpenFile(log_count)
        'debounce - big time
        time.Pause(500)

    
      time.Pause(100)
      
      pressure := AdjustTheScale(GetBreathPressure)
      Direction_Update
    '*********************     
    
      if log_status
 
        'sd.WriteDec(pressure) 
        sd.WriteDec(Direction_Bar_Level)
        sd.WriteByte(13)' Carriage return
        sd.WriteByte(10)' New line
         
      pst.Dec(pressure)
      pst.NewLine

      main_loops_count++
      
      if main_loops_count > 20
        Keys_Released
          
      Verbalizer_Loop
      
      
 
>>>>>>> parent of ed1e3f0... and better
PRI AdjustTheScale(thePressure)
  thePressure := thePressure / 2
  thePressure := thePressure - 40
  return thePressure
  
PRI GetBreathPressure | i,  rolling_average
' using these globals
' smooth_operator
' Long smoothness[smooth_operator]
' Long smooth_operator_iterator
  smooth_operator_iterator := smooth_operator_iterator + 1
  if smooth_operator_iterator > smooth_operator
    smooth_operator_iterator := 0
  smoothness[smooth_operator_iterator] := adc.In(0)
  rolling_average := 0
  
  repeat i from 0 to smooth_operator
    rolling_average := rolling_average + smoothness[i]  
  rolling_average := rolling_average / smooth_operator
  
  return rolling_average

PRI OpenFile(log_increment)
  if logging
    status_on
    sd.Mount(0)
    sd.FileDelete(FileName(log_increment))
    sd.FileNew(FileName(log_increment))
    sd.FileOpen(FileName(log_increment), "W")
    log_status := TRUE
     
    'pst.Str(FileName(log_count))
    'pst.Str(String(13, 10))
  
PRI CloseFile
  if logging 
    sd.FileClose  
    sd.Unmount
    log_status := FALSE
    status_off
       
PRI FileName(x)
  
  'ASCII0_STREngine_1.integerToDecimal(log_count, 2)
  case x
    0 : return String("breath00.txt")
    1 : return String("breath01.txt")
    2 : return String("breath02.txt")
    3 : return String("breath03.txt")
    4 : return String("breath04.txt")
    5 : return String("breath05.txt")
    6 : return String("breath06.txt")
    7 : return String("breath07.txt")
    8 : return String("breath08.txt")
    9 : return String("breath09.txt")
    10 : return String("breath10.txt") 
  'return String("hrt1", ".txt")
  'x := String(stringo.integerToDecimal(log_count, 2))
  'return String("hrt", x, ".txt")

PRI led_on
  outa[led_pin] := 1

PRI led_off
  outa[led_pin] := 0

PRI status_on
  outa[status_pin] := 1
  
PRI status_off
  outa[status_pin] := 0
  

PRI RunBarGraph | modified_pressure

  'show the modified pressure
  repeat
    if pressure < 0
      modified_pressure := 0
    else
      modified_pressure := pressure
    outa[BAR_GRAPH_9..BAR_GRAPH_0] := 1<<modified_pressure - 1   'Continually set the value of the scaled pressure to the LED bar graph pins.
                                                        'Do a little bitwise manipulation to make the LEDs look nice.

     
PUB Main | current_count, logging_toggler

  init
  logging_toggler := FALSE
    
    repeat 'THE MAIN LOOP ################################
    
      'check if logging button is pressed
      if logging_toggler
        'if logging is false(off) turn it true(on) and visa versa
        if logging
          CloseFile
          logging := FALSE
          log_count++
        else
          logging := TRUE
          OpenFile(log_count)
        'debounce - big time
        time.Pause(500)

    
      time.Pause(100)
      
      pressure := AdjustTheScale(GetBreathPressure)
      Direction_Update
    '*********************     
    
      if log_status
 
        'sd.WriteDec(pressure) 
        sd.WriteDec(Direction_Bar_Level)
        sd.WriteByte(13)' Carriage return
        sd.WriteByte(10)' New line
         
      'pst.Dec(pressure)
      'pst.NewLine

      main_loops_count++
      
      if main_loops_count > 12
        Keys_Released
          
      Verbalizer_Loop
'*****END MAIN LOOP************************************************************************************************************* 
      
 
DAT

{{
==================================================================================================================================
=                                                   TERMS OF USE: MIT License                                                    =                                                            
==================================================================================================================================
= Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation     = 
= files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy,     =
= modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software =
= is furnished to do so, subject to the following conditions:                                                                    =
=                                                                                                                                =
= The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software. =
=                                                                                                                                =
= THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE           =
= WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR          =
= COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,    =
= ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.                          =
==================================================================================================================================
}} 
      