# MIPS-Based 32bit Processor
## Overview
Three different types of MIPS-based processors were implemented using VHDL. The code was simulated in Modelsim and synthesized in Quartus Prime.

## Single cycle
Implemented first, the single cycle processor provided a base and proof-of-concept of a working MIPS-based processor. Since this implementation can only handle one instruction at a time, it is, in most cases, slow than the other two processors (that are both pipelined).

## Pipeline (Software-scheduled)
The implementation of the pipeline took place with this processor. I use a five stage pipeline that typically increases total execution time because, when filled, the pipeline handles up to five instructions at once, rather than just the one that the single cycle deals with.

The downside to this pipeline implementation is that the instruction fetch must be software scheduled, or written in the program. This processor does not have any sort of hazard avoidance, so the programmer must account for this by reordering instructions to not have hazards or insert NOPs.

## Pipeline (Hardware-scheduled)
This was the final implementation of a MIPS processor. This processor had the same five-stage pipeline with the addition of hazard avoidance. Forwarding, flushing, and stalling were implemented to detect and avoid control and data hazards within a given program.
