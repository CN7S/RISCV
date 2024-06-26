// INST

`define SBTYPE_INST_OPCODE 7'b1100011
`define LOAD_INST_OPCODE 7'b0000011
`define STYPE_INST_OPCODE 7'b0100011
`define RTYPE_INST_OPCODE 7'b0110011
`define ITYPE_INST_OPCODE 7'b0010011
`define JALR_INST_OPCODE 7'b1100111
`define JTYPE_INST_OPCODE 7'b1101111
`define UTYPE_INST_OPCODE 7'b0110111 // LUI


`define FUNC_BEQ 3'b000
`define FUNC_BLT 3'b100

`define FUNC_ADD 4'b0000
`define FUNC_SUB 4'b1000
`define FUNC_SLL 4'b0001
`define FUNC_SRL 4'b0101
`define FUNC_AND 4'b0111
`define FUNC_OR 4'b0110
`define FUNC_XOR 4'b0100
`define FUNC_ADDI 3'b000
`define FUNC_XORI 3'b100
`define FUNC_ORI 3'b110
`define FUNC_ANDI 3'b111

// ALU
`define LSJ_ALUOP 2'b00
`define B_ALUOP 2'b01
`define R_ALUOP 2'b10
`define I_ALUOP 2'b11

`define ALU_ADD_OPCODE 4'b0010
`define ALU_SUB_OPCODE 4'b0110
`define ALU_AND_OPCODE 4'b0000
`define ALU_OR_OPCODE 4'b0001
`define ALU_XOR_OPCODE 4'b0011
`define ALU_SLL_OPCODE 4'b1000
`define ALU_SRL_OPCODE 4'b1100

 
`define INST_FLUSH 32'h 00000013  // addi x0,x0,0