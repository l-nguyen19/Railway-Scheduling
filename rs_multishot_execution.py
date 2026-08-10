import sys
import re
import random
from typing import cast, Any, Callable, Optional, Sequence
from clingo.application import clingo_main, Application, ApplicationOptions
from clingo.control import Control
from clingo.solving import SolveResult
from clingo.symbol import Function, Number

class IncConfig:
    def __init__(self):
        self.imin = 1
        self.imax = None
        self.istop = "SAT"

def parse_int(conf: Any, attr: str, min_value: Optional[int] = None, optional: bool = False) -> Callable[[str], bool]:
    def parse(sval: str) -> bool:
        if optional and sval == "none":
            value = None
        else:
            value = int(sval)
            if min_value is not None and value < min_value:
                raise RuntimeError("value too small")
        setattr(conf, attr, value)
        return True
    return parse

def parse_stop(conf: Any, attr: str) -> Callable[[str], bool]:
    def parse(sval: str) -> bool:
        if sval not in ("SAT", "UNSAT", "UNKNOWN"):
            raise RuntimeError("invalid value")
        setattr(conf, attr, sval)
        return True
    return parse
    
class IncApp(Application):
    program_name: str = "Railway Scheduling with Malfunctions/delays"
    version: str = "1.0"
    _conf: IncConfig
    def __init__(self):
        self._conf = IncConfig()

    def main(self, ctl: Control, files: Sequence[str]):
        
        # list of agents
        agentlist=[]   
        
        # search for the maximum ID
        if not files:
            files = ["-"]
        for file_ in files:
            ctl.load(file_)
            try:
                with open(file_, 'r') as file:
                    text = file.read()
                    matches = re.findall('agent\((\d+)\)', text)
                    for match in matches:
                        agentID = int(match)
                        if agentID not in agentlist:
                            agentlist.append(agentID)
                    
            except FileNotFoundError:
                print(f'{file_} not found.')

        # max ID
        maxID=(max(agentlist))  

        print(f'List of agent ID\'s: {agentlist}')
        print(f'maxID: {maxID}')        

        ctl.add("check", ["t1"], "#external query1(t1).")
        ctl.add("check", ["t2"], "#external query2(t2).")
######################
        conf = self._conf
        step = 0
        ret: Optional[SolveResult] = None

        # max duration of a delay
        maxDuration= 5

        # probability of a delay
        probability = 0.05

        # list of all occurred delays
        delayList = []

        # list of trains with active delay
        delayActiveList = [False] * (maxID + 1)

        # list of the remaining durations of a delay
        delayDurationList = [0] * (maxID + 1)

        while ((conf.imax is None or step < conf.imax) and
               (ret is None or step < conf.imin or (
                   (conf.istop == "SAT" and not ret.satisfiable) or
                   (conf.istop == "UNSAT" and not ret.unsatisfiable) or
                   (conf.istop == "UNKNOWN" and not ret.unknown)))):
            parts = []
            parts.append(("check", [Number(step)]))
            parts.append(("check2", [Number(step)]))
            
            print(f'Step: {step}')  
            

            for i in range(maxID + 1):
                randomNum = random.random()
                # if a train has no delay, it may be assigned one
                if randomNum <= probability and not delayActiveList[i]:
                    duration = random.randint(1, maxDuration)
                    delayDurationList[i] = duration
                    # add new delay to delayList
                    delayList.append(f"delay(agent({i}),dur({duration}),{step})")
                    print(f"A delay has occurred: delay(agent({i}),dur({duration}),{step})")
                    delayActiveList[i] = True
            
            for i in range(maxID+1):
                # if the train has an active delay
                if delayActiveList[i]:
                    # decrement the duration
                    delayDurationList[i] -= 1
                    delay = f"delay(agent({i}),dur(1),{step})."
                    # add a new delay with duration 1 to the code
                    ctl.add("step", ["t"], delay)
                    if delayDurationList[i] <= 0:
                        delayActiveList[i] = False

            print("DelayList: " + str(delayList))
            
            if step > 0:
                ctl.release_external(Function("query1", [Number(step - 1)]))
                ctl.release_external(Function("query2", [Number(step - 1)]))
                parts.append(("step", [Number(step)]))
            else:
                parts.append(("base", []))
       
            
            # check if there is no tpgorder conflict
            print("--- TPG check...")
            ctl.ground(parts)
            ctl.assign_external(Function("query1", [Number(step)]), True)
            ret = ctl.solve()
            
            # then check the goal constraint
            print("--- GOAL check...")
            ctl.assign_external(Function("query2", [Number(step)]), True)
            ret = ctl.solve()
            step += 1

clingo_main(IncApp(), sys.argv[1:])