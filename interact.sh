#!/usr/bin/expect  
  
set TCMSUSER shiywang   
set PASSWORD "password"  
if { $::argc < 2 } {  
  puts "USAGE: $::argv0 case_id feature_line ..."  
  puts "EXAMPLE: $::argv0 520288 features/images/jenkins.feature:12 224841 features/cli/create.feature:6"  
  exit 1  
}  
set index 0  
while {$index < $argc} {  
  #update notes  
  catch {spawn tools/tcms_query.rb -c [lindex $argv $index] -n "\"automated by $TCMSUSER@redhat.com\""}  
  expect "TCMS user" {send $TCMSUSER\r}  
  expect "TCMS Password:" {send $PASSWORD\r}  
  interact  
  #update script  
  catch {spawn tools/tcms_query.rb -c [lindex $argv $index] -s [lindex $argv $index+1]}  
  expect "TCMS user" {send $TCMSUSER\r}  
  expect "TCMS Password:" {send $PASSWORD\r}  
  interact  
  set index [expr {$index + 2}]  
}  
