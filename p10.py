import re

def is_number(s):
    """Check if a string is a number (integer or float)."""
    try:
        float(s)
        return True
    except ValueError:
        return False

def optimize_code(tac_lines):
    """
    Performs constant folding and propagation on a list of TAC lines.
    """
    constants = {}
    optimized_code = []

    for line in tac_lines:
        line = line.strip()
        if not line:
            continue
            
        # Match expressions like 't1 = 5 * 10' or 'x = t1'
        match = re.match(r'(\w+)\s*=\s*(\w+)\s*([+\-*/])\s*(\w+)', line)
        assign_match = re.match(r'(\w+)\s*=\s*(\w+)', line)

        if match:
            result, arg1, op, arg2 = match.groups()
            
            # --- Constant Propagation ---
            # Replace args with their constant values if known
            if arg1 in constants:
                arg1 = constants[arg1]
            if arg2 in constants:
                arg2 = constants[arg2]

            # --- Constant Folding ---
            if is_number(arg1) and is_number(arg2):
                # Both arguments are numbers, we can fold them
                expression = f"{arg1} {op} {arg2}"
                value = str(eval(expression))
                print(f"Folding: {line}  -->  {result} = {value}")
                constants[result] = value
                # Add the simplified assignment to the optimized code
                optimized_code.append(f"{result} = {value}")
            else:
                # Cannot fold, add the (potentially propagated) line
                optimized_code.append(f"{result} = {arg1} {op} {arg2}")

        elif assign_match:
            result, arg1 = assign_match.groups()
            
            # --- Constant Propagation ---
            if arg1 in constants:
                value = constants[arg1]
                print(f"Propagating: {line}  -->  {result} = {value}")
                constants[result] = value
                optimized_code.append(f"{result} = {value}")
            else:
                optimized_code.append(line)
        else:
            # Not an expression or assignment we can optimize, keep as is
            optimized_code.append(line)

    return optimized_code

# --- Main Execution ---
input_filename = "unoptimized_tac.txt"
with open(input_filename, 'r') as f:
    unoptimized_code = f.readlines()

print("---- Unoptimized Code ----")
for line in unoptimized_code:
    print(line.strip())
print("--------------------------\n")

print("---- Optimization Steps ----")
optimized_code = optimize_code(unoptimized_code)
print("--------------------------\n")

print("---- Optimized Code ----")
for line in optimized_code:
    print(line.strip())
print("------------------------")