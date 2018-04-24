3) Hazard goes into DECODE - TODO: link up all its outputs...
4) Forward goes into EXECUTE - TODO: link up all its outputs...

branch, branchtaken, jr all need to come from their origin to forwarding unit
branch, j, jal, jr all need to come from their origin to hazard detection



I think this is OK...I have it in a with-select and the DFF is clock-high triggered for writing....
If not, put this in a process.
5) TODO: Flushing must occur synchronously (currently async) (must flush on rising edge, try a reset)
