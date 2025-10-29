import sys

MAX_REG = 4
# Register descriptor: keeps track of what variable is in which register
reg_desc = [None] * MAX_REG
# False = free, True = used
reg_in_use = [False] * MAX_REG

# --- Functions ---

def get_reg(var):
    """
    A simple function to get a register for a variable.
    """
    # 1. Check if var is already in a register
    for i in range(MAX_REG):
        if reg_in_use[i] and reg_desc[i] == var:
            return i

    # 2. Find a free register
    for i in range(MAX_REG):
        if not reg_in_use[i]:
            reg_in_use[i] = True
            reg_desc[i] = var
            return i

    # 3. No free register found (spilling would happen here)
    print(f"Error: No free registers available for {var}!", file=sys.stderr)
    return -1

def generate_code(line):
    """
    Parses a single line of TAC and prints pseudo-assembly.
    """
    parts = line.split()
    
    # Operator mapping (replaces C's if/else chain)
    op_map = {
        "+": "ADD",
        "-": "SUB",
        "*": "MUL",
        "/": "DIV"
    }

    try:
        # Case 1: result = arg1 op arg2 (e.g., "t1 = a + b")
        # Check if line has 5 parts, the 2nd is '=' and the 4th is a valid operator
        if len(parts) == 5 and parts[1] == '=' and parts[3] in op_map:
            result, arg1, op, arg2 = parts[0], parts[2], parts[3], parts[4]
            
            r1 = get_reg(arg1)
            r2 = get_reg(arg2) # Get register for arg2

            if r1 == -1 or r2 == -1:
                return # Error already printed by get_reg

            op_str = op_map[op]
            
            print(f"MOV R{r1}, {arg1}")        # Load arg1
            print(f"{op_str} R{r1}, {arg2}")  # Perform operation
            print(f"MOV {result}, R{r1}")     # Store result
            
            # Update register descriptor: R1 now holds the result
            reg_desc[r1] = result
            
            # Free the register for arg2 if it's not the same as arg1's
            if r1 != r2:
                reg_in_use[r2] = False
        
        # Case 2: result = arg1 (e.g., "a = t1")
        elif len(parts) == 3 and parts[1] == '=':
            result, arg1 = parts[0], parts[2]
            
            r1 = get_reg(arg1)
            if r1 == -1:
                return
                
            print(f"MOV R{r1}, {arg1}")
            print(f"MOV {result}, R{r1}")
            
            # Update register descriptor: R1 now holds the result
            reg_desc[r1] = result
        
        # Other lines are silently ignored, just like the C code

    except Exception as e:
        print(f"// Error processing line '{line}': {e}", file=sys.stderr)


# --- Main execution (replaces the main() function from C) ---

input_file = "tac_input.txt"

try:
    # 'with open' automatically handles closing the file, even if errors occur
    with open(input_file, "r") as f:
        print("---- Generated Assembly Code ----")
        
        # Read the file line by line
        for line in f:
            line = line.strip() # Remove trailing newline
            
            if line: # Process only non-empty lines
                print(f"\n// TAC: {line}")
                generate_code(line)
        
        print("\n---------------------------------")

except FileNotFoundError:
    print(f"Error: Cannot open input file '{input_file}'", file=sys.stderr)
    sys.exit(1) # Exit with an error code, similar to C's 'return 1'