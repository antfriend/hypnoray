{{
       hypnoray
       a meditator
       
}}

CON
  led_pin = 10
  status_pin = 2
  heart_pin = 3
  smooth_operator = 3 'the max index

VAR
  Long is_reset
  Long log_count
  Long log_status
  Long smoothness[smooth_operator + 1] 'for 0 to smooth_operator indexing
  Long smooth_operator_iterator
  
OBJ
  system : "Propeller Board of Education"
  sd     : "PropBOE MicroSD"
  pst    : "Parallax Serial Terminal Plus"
  time   : "Timing"
  adc    : "PropBOE ADC"
  
PRI init | i
  system.Clock(80_000_000)
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
      
PUB go | current_count, tick

  init
  cosmic_orchestral_beat
  
  repeat log_count from 0 to 0 '0-10 range limit due to FileName function

    'if toggle
    
    OpenFile(log_count)
    '******************** 
    time.Pause(10)
    repeat 300
          
      time.Pause(200)
      tick := GetBreathPressure


          
    '*********************     
    
      if log_status
        sd.WriteDec(tick)
        sd.WriteByte(13)' Carriage return
        sd.WriteByte(10)' New line
         
      pst.Dec(tick)
      pst.NewLine
      
    CloseFile

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
  status_on
  sd.Mount(0)
  sd.FileDelete(FileName(log_increment))
  sd.FileNew(FileName(log_increment))
  sd.FileOpen(FileName(log_increment), "W")
  log_status := TRUE
  
  pst.Str(FileName(log_count))
  pst.Str(String(13, 10))
  
PRI CloseFile
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
  
 
      