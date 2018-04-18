1) Add a signal in control unit called MemRead that is set high when a load instruction is detected
2) Forward MemRead through IDEX
3) Hazard goes into DECODE
4) Forward goes into EXECUTE
5) Implement BranchTaken
6) Implement Branch (BEQ OR BNE)

branch, branchtaken, jr all need to come from their origin to forwarding unit


branch, j, jal, jr all need to come from their origin to hazard detection
