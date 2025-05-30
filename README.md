# JoMS2025
Repository containing the rescheduling ASP encoding and instances of the paper "Logic-based Approach and Visualization for the Nuclear Medicine Rescheduling Problem"


# Clingo Installation 
Installation instructions for different Operating Systems building from sources or using Anaconda for Clingo v5.6.2 can be found here: https://github.com/potassco/clingo/blob/master/INSTALL.md, https://potassco.org/clingo/, https://github.com/potassco/clingo/releases/tag/v5.6.2


There are 2 main folders, one containing the ASP encoding and the other the instances.
Inside the Encoding folder, there is the ASP encoding as presented in the paper.
Inside the Input folder, there are 3 subfolders, each corresponding to one CASE: low, medium, and high. There are 6 instances in each folder. The instances are named following this schema: "input_SCEN_N.lp", where SCEN and N are the scenario R2/R3 and the number of resource/room unavailable, respectively. E.g. input_R2-1.lp means that in the scenario R2 is missing one resource (either a chair or a tomograph). 

To run the file you can execute the following command: 

```./clingo Encoding/reschedule.lp Input/CASE/input_SCEN_N.lp --opt-strategy=usc --parallel-mode 4```
