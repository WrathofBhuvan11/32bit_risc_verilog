opcode = {
    'add' : 0,'sub' : 1,'inc' : 2,'dec' : 3,'and' : 4,'or'  : 5,
    'neg' : 6,'ldi' : 7,'nand': 8,'nor' : 9,'xor' : 10,
    'xnor': 11,'lshl': 12,'lshr': 13,'ashl': 14,'ashr': 15,
}


def binf(N:int, length:int)->str:
    '''Convert a number to binary string of given width'''
    Nbin = bin(N)[2:] if N>=0 else bin(N & (2**16-1))[2:]
    Nbin = '0'*(length - len(Nbin)) + Nbin if len(Nbin) <= 16 else Nbin[:16]
    return Nbin

def assemble(instr:str)->str:
    instr = ''.join(filter(lambda ch:ch.isalnum() or  ch==' ', instr))
    instr = instr.lower().split()
    res = ""
    res += binf(opcode[instr[0]], 4)
    if instr[1][0] == 'r':
        res += binf(int(instr[1][1:]), 4)
    else:
        raise ValueError("Expected register")
    if len(instr) == 2:
        res += '0'*16
    else:
        if instr[2][0] == 'r':
            res += binf(int(instr[2][1:]), 16)
        else:
            res += binf(int(instr[2], 16), 16)
    return res

def mkcoe(code:str)->str:
    coe = "memory_initialization_radix=2;\n" + "memory_initialization_vector=\n"
    code = filter(None, code.splitlines())
    for i, instr in enumerate(code):
        coe += assemble(instr) if i==0 else ',\n' + assemble(instr) 
    coe += ";\n"
    return coe

def interpret(code:str)->str:
    regbank = [0 for _ in range(16)]
    coe = "memory_initialization_radix=2;\n" + "memory_initialization_vector=\n"
    code = filter(None, code.splitlines())
    for i, instr in enumerate(code):
        instr = assemble(instr)
        opcode = int(instr[:4], 2)
        op1 = int(instr[4:8], 2)
        op2 = int(instr[8:], 2)
        
        if i!=0:
            coe += ",\n"
        
        if opcode == 0:
            regbank[op1] = int(binf(regbank[op1] + regbank[op2], 16), 2)
            coe += binf(regbank[op1], 16) 
        elif opcode == 1:
            regbank[op1] = int(binf(regbank[op1] - regbank[op2], 16), 2)
            coe += binf(regbank[op1], 16) 
        elif opcode == 2:
            regbank[op1] = int(binf(regbank[op1] + 1, 16), 2)
            coe += binf(regbank[op1], 16) 
        elif opcode == 3:
            regbank[op1] = int(binf(regbank[op1] - 1, 16), 2)
            coe += binf(regbank[op1], 16) 
        elif opcode == 4:
            regbank[op1] = int(binf(regbank[op1] & regbank[op2], 16), 2)
            coe += binf(regbank[op1], 16) 
        elif opcode == 5:
            regbank[op1] = int(binf(regbank[op1] | regbank[op2], 16), 2)
            coe += binf(regbank[op1], 16) 
        elif opcode == 6:
            regbank[op1] = int(binf(~regbank[op1], 16), 2)
            coe += binf(regbank[op1], 16) 
        elif opcode == 7:
            regbank[op1] = op2
            coe += binf(0, 16)
        elif opcode == 8:
            regbank[op1] = int(binf(~(regbank[op1] & regbank[op2]), 16), 2)
            coe += binf(regbank[op1], 16) 
        elif opcode == 9:
            regbank[op1] = int(binf(~(regbank[op1] | regbank[op2]), 16), 2)
            coe += binf(regbank[op1], 16) 
        elif opcode == 10:
            regbank[op1] = int(binf((regbank[op1] ^ regbank[op2]), 16), 2)
            coe += binf(regbank[op1], 16) 
        elif opcode == 11:
            regbank[op1] = int(binf(~(regbank[op1] ^ regbank[op2]), 16), 2)
            coe += binf(regbank[op1], 16) 
        elif opcode == 12:
            regbank[op1] = int(binf((regbank[op1] << regbank[op2]), 16), 2)
            coe += binf(regbank[op1], 16) 
        elif opcode == 13:
            regbank[op1] = int(binf((regbank[op1] >> regbank[op2]), 16), 2)
            coe += binf(regbank[op1], 16) 
        elif opcode == 14:
            regbank[op1] = int(binf((regbank[op1] << regbank[op2]), 16), 2)
            coe += binf(regbank[op1], 16) 
        elif opcode == 15:
            regbank[op1] = int(binf(((regbank[op1] >> regbank[op2]) | (2**15 & regbank[op1]) ), 16), 2)
            coe += binf(regbank[op1], 16) 
        else:
            raise ValueError("wtf")
    coe += ';\n'
    return coe

code = '''
ldi r0, 0xf00f
ldi r1, 0x002
add r0, r1
sub r0, r1
add r0, r1
add r2, r0
dec r3
inc r4
'''
#print(interpret(code))
print(mkcoe(code))