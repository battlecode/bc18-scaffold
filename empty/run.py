import battlecode as bc

import os
print(os.getcwd())

print("empty bot started")

gc = bc.GameController()

while True:
    gc.next_turn()
