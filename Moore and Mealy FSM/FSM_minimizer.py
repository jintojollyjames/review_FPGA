# ----------------------------------------------------------
# Moore FSM Minimizer (Partition Refinement)
# ----------------------------------------------------------

from collections import defaultdict

def minimize_moore(states, inputs, transitions, outputs):
    """
    states:     list of state names        e.g. ["A","B","C","D"]
    inputs:     list of input symbols      e.g. [0,1]
    transitions: dict {(state, input): next_state}
                e.g. {("A",0):"B", ("A",1):"C", ...}
    outputs:    dict {state: output_value}
                e.g. {"A":0, "B":0, "C":1, "D":1}
    """

    # ------------------------------------------------------
    # Step 1 — Initial partition by output values
    # ------------------------------------------------------
    partition = defaultdict(list)
    for s in states:
        partition[outputs[s]].append(s)

    # Convert dict to list of sets
    P = [set(group) for group in partition.values()]

    # ------------------------------------------------------
    # Step 2 — Refinement loop
    # ------------------------------------------------------
    stable = False
    while not stable:
        stable = True
        new_P = []

        # refine each block in P
        for block in P:
            # signatures for each state in block
            signatures = defaultdict(list)

            for s in block:
                # signature = tuple of next-state block indices for each input
                sig = []
                for inp in inputs:
                    nxt = transitions[(s, inp)]
                    # find which block contains nxt
                    for i, b in enumerate(P):
                        if nxt in b:
                            sig.append(i)
                            break
                signatures[tuple(sig)].append(s)

            # If only one signature, block stays same
            if len(signatures) == 1:
                new_P.append(block)
            else:
                # block splits → refinement happened
                stable = False
                for group in signatures.values():
                    new_P.append(set(group))

        P = new_P

    # ------------------------------------------------------
    # Build minimized machine
    # Each partition block becomes one new state
    # ------------------------------------------------------
    new_states = [f"S{i}" for i in range(len(P))]

    # map old state → new state
    state_map = {}
    for i, block in enumerate(P):
        for s in block:
            state_map[s] = new_states[i]

    # output values for minimized states
    new_outputs = {
        new_states[i]: outputs[list(P[i])[0]]   # all states in block share output
        for i in range(len(P))
    }

    # transitions for minimized machine
    new_transitions = {}
    for i, block in enumerate(P):
        rep = list(block)[0]  # representative state
        for inp in inputs:
            old_next = transitions[(rep, inp)]
            new_next = state_map[old_next]
            new_transitions[(new_states[i], inp)] = new_next

    return {
        "old_partitions": P,
        "state_map": state_map,
        "new_states": new_states,
        "new_outputs": new_outputs,
        "new_transitions": new_transitions
    }


# ----------------------------------------------------------
# Example use (same as your practice problem)
# ----------------------------------------------------------
if __name__ == "__main__":
    states = ["A", "B", "C", "D"]
    inputs = [0, 1]

    transitions = {
        ("A", 0): "B", ("A", 1): "C",
        ("B", 0): "A", ("B", 1): "D",
        ("C", 0): "C", ("C", 1): "A",
        ("D", 0): "B", ("D", 1): "C",
    }

    outputs = {"A":0, "B":0, "C":1, "D":1}

    result = minimize_moore(states, inputs, transitions, outputs)

    print("\n=== Minimized Moore Machine ===")
    print("Partitions:", result["old_partitions"])
    print("State Mapping:", result["state_map"])
    print("New States:", result["new_states"])
    print("Outputs:", result["new_outputs"])
    print("Transitions:")
    for k, v in result["new_transitions"].items():
        print(f"  {k} -> {v}")
