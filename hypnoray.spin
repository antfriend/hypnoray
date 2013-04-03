{{
       hypnoray
       a meditator

       now?
}}

CON
  _xinfreq = 5_000_000
  _clkmode = xtal1 + pll16x

  led_pin = 10
  status_pin = 2
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
  
VAR
  Long is_reset
  Long log_count
  Long log_status
  Long smoothness[smooth_operator + 1] 'for 0 to smooth_operator indexing
  Long smooth_operator_iterator
  Long logging
  long pressure
  long cogStack[20]
  
OBJ
  system : "Propeller Board of Education"
  sd     : "PropBOE MicroSD"
  pst    : "Parallax Serial Terminal Plus"
  time   : "Timing"
  adc    : "PropBOE ADC"
  
PRI init | i
  system.Clock(80_000_000)
  
  logging := FALSE 
  log_status := FALSE
  log_count := 0
  is_reset := TRUE
  
  dira[led_pin] := 1
  dira[status_pin] := 1
  dira[heart_pin] := 0
  outa[heart_pin] := 1
  
  'initialize the smoothing array
  repeat i from 0 to smooth_operator
    smoothness[i] := adc.In(0)
  
PRI cosmic_orchestral_beat
  {
  blinkity blink blinker
  }
    repeat 4
      status_on
      led_off
      time.Pause(100)
      status_off
      led_on
      time.Pause(400)
     
    repeat 4
      status_off
      led_on
      time.Pause(50)
      status_on
      led_off
      time.Pause(200)
      status_off
      led_off
      time.Pause(400)

    repeat 4
      status_off
      led_on
      time.Pause(50)
      status_on
      led_off
      time.Pause(200)
      status_off
      led_off
      time.Pause(400)
      
PUB go | current_count

  init
  'cosmic_orchestral_beat
  
  'Launch additional cog
  cognew(RunBarGraph, @cogStack)
  
  repeat log_count from 0 to 2 '0-10 range limit due to FileName function

    'if toggle
    
    OpenFile(log_count)
    '******************** 
    time.Pause(10)
    repeat 100
          
      time.Pause(100)
      pressure := AdjustTheScale(GetBreathPressure)

    '*********************     
    
      if log_status
 
        sd.WriteDec(pressure)
        sd.WriteByte(13)' Carriage return
        sd.WriteByte(10)' New line
         
      pst.Dec(pressure)
      pst.NewLine
      
    CloseFile     

  'now just run forever
  repeat
    time.Pause(100)
    pressure := AdjustTheScale(GetBreathPressure) 
    pst.Dec(pressure)
    pst.NewLine
    
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
     
    pst.Str(FileName(log_count))
    pst.Str(String(13, 10))
  
PRI CloseFile
  if logging 
    sd.FileClose  
    sd.Unmount
    log_status := FALSE
    status_off
       
PRI FileName(x)
  
  'ASCII0_STREngine_1.integerToDecimal(log_count, 2)
  case x
    0 : return String("hrt00.txt")
    1 : return String("hrt01.txt")
    2 : return String("hrt02.txt")
    3 : return String("hrt03.txt")
    4 : return String("hrt04.txt")
    5 : return String("hrt05.txt")
    6 : return String("hrt06.txt")
    7 : return String("hrt07.txt")
    8 : return String("hrt08.txt")
    9 : return String("hrt09.txt")
    10 : return String("hrt10.txt") 
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
  

PUB RunBarGraph | modified_pressure

  dira[BAR_GRAPH_9..BAR_GRAPH_0] := OUTPUT              'set range of pins to output
                                                        '(this works in this case because the pins are consecutive)
  repeat
    if pressure < 0
      modified_pressure := 0
    else
      modified_pressure := pressure
    outa[BAR_GRAPH_9..BAR_GRAPH_0] := 1<<modified_pressure - 1   'Continually set the value of the scaled pressure to the LED bar graph pins.
                                                        'Do a little bitwise manipulation to make the LEDs look nice.


DAT

{{
????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????
?                                                   TERMS OF USE: MIT License                                                  ?                                                            
????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????
?Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation    ? 
?files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy,    ?
?modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software?
?is furnished to do so, subject to the following conditions:                                                                   ?
?                                                                                                                              ?
?The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.?
?                                                                                                                              ?
?THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE          ?
?WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR         ?
?COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,   ?
?ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.                         ?
????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????
}} 
      