#!/usr/bin/expect  
  
set PASSWORD "YOUR_PASSWORD"  

catch {spawn kinit}  
expect "Password for" {send $PASSWORD\r}  
interact  
